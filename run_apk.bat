@echo off
setlocal enabledelayedexpansion

REM ====== 사용자 환경에 맞게 여기만 확인/수정 ======
set "SDK_ROOT=D:\Android_dev\Sdk"
set "ADB=%SDK_ROOT%\platform-tools\adb.exe"
set "EMU=%SDK_ROOT%\emulator\emulator.exe"
set "AVD_NAME=test"
REM APK 경로를 인자로 받을 수도 있고, 없으면 아래 기본값 사용
set "DEFAULT_APK=D:\somi_work\sap_guild\app-debug-ci.apk"
REM =================================================

REM 1) APK 경로 결정 (bat 실행 시 첫번째 인자 있으면 그걸 사용)
set "APK=%~1"
if "%APK%"=="" set "APK=%DEFAULT_APK%"

REM 2) 파일 존재 체크
if not exist "%ADB%" (
  echo [ERROR] adb not found: "%ADB%"
  echo SDK_ROOT 경로가 맞는지 확인하세요.
  exit /b 1
)
if not exist "%EMU%" (
  echo [ERROR] emulator not found: "%EMU%"
  echo SDK_ROOT 경로가 맞는지 확인하세요.
  exit /b 1
)
if not exist "%APK%" (
  echo [ERROR] APK not found: "%APK%"
  echo bat 실행 시 APK 경로를 인자로 주거나 DEFAULT_APK를 수정하세요.
  exit /b 1
)

REM 3) ADB 서버 리셋
echo [1/8] Restarting adb server...
"%ADB%" kill-server >nul 2>&1
"%ADB%" start-server >nul 2>&1

REM 4) 에뮬레이터 실행 여부 확인 (없으면 실행)
echo [2/8] Checking emulator...
set "EMURUN="
for /f "tokens=1,2" %%A in ('"%ADB%" devices') do (
  if "%%A"=="emulator-5554" if "%%B"=="device" set "EMURUN=1"
)
if not defined EMURUN (
  echo [3/8] Starting emulator "%AVD_NAME%"...
  REM -netdelay none -netspeed full : 빠르게
  REM -no-boot-anim : 부팅 애니메이션 생략
  start "" "%EMU%" -avd "%AVD_NAME%" -netdelay none -netspeed full -no-boot-anim
) else (
  echo [3/8] Emulator already running.
)

REM 5) 디바이스 연결 대기
echo [4/8] Waiting for device...
"%ADB%" wait-for-device

REM 6) 간단한 화면 초기화 (HOME, BACK, WAKE) - 사용자 요청으로 추가
echo [5/8] Sending keyevents to try to unlock/return home...
"%ADB%" shell input keyevent 26 >nul 2>&1
timeout /t 1 >nul
"%ADB%" shell input keyevent 82 >nul 2>&1
timeout /t 1 >nul
"%ADB%" shell input keyevent 3 >nul 2>&1
timeout /t 1 >nul
"%ADB%" shell input keyevent 4 >nul 2>&1

REM 'offline'일 때를 대비해 몇 번 재시도
set /a RETRY=0
:CHECK_DEVICE
set "STATE="
for /f "tokens=1,2" %%A in ('"%ADB%" devices') do (
  if "%%A"=="emulator-5554" set "STATE=%%B"
)
if /i "%STATE%"=="device" goto DEVICE_OK
set /a RETRY+=1
if %RETRY% GEQ 10 (
  echo [ERROR] Device not ready. Current state: "%STATE%"
  echo 에뮬레이터가 완전히 부팅됐는지 확인 후 다시 실행해보세요.
  exit /b 1
)
echo Device state="%STATE%" ... retry %RETRY%/10
"%ADB%" reconnect >nul 2>&1
timeout /t 2 >nul
goto CHECK_DEVICE

:DEVICE_OK
echo Device is ready: emulator-5554 (device)

REM 7) APK 설치
echo [6/8] Installing APK: "%APK%" ...
"%ADB%" install -r "%APK%"
if errorlevel 1 (
  echo [ERROR] Install failed.
  exit /b 1
)

REM 8) (선택) 앱 자동 실행 (패키지/액티비티 알고 있으면 사용)
echo [7/8] Launching app (if package/activity known)...
REM 예: "%ADB%" shell am start -n com.example.helloworld/.MainActivity
REM 또는 런처로 실행:
REM "%ADB%" shell monkey -p com.example.helloworld -c android.intent.category.LAUNCHER 1

echo [8/8] Done.
echo Installed: %APK%
echo.
pause
endlocal
