앱 개발 설정

요약
- 프로젝트: sap_guild / hello-world-android 기반 (HelloWorld 분리 유지)
- 목표: Android 개발 환경(로컬/CI), MariaDB 백엔드 연결, 빌드 → APK 생성 → Windows로 복사 및 에뮬레이터 설치 자동화

현재 상태 (핵심)
- 로컬 빌드 및 APK
  - APK 경로: /home/cys90/.openclaw/workspace/sap_guild/app/build/outputs/apk/debug/app-debug.apk
  - Windows 복사본: D:\somi_work\sap_guild\app-debug-ci.apk
  - APK SHA-256: b1917df7d71024469bb867459e1a643817af656128e0ce3971575647efb6388f
  - 크기: 5,377,182 bytes
- Gradle / CI
  - AGP: com.android.tools.build:gradle:7.4.2
  - Gradle wrapper: 재생성(Gradle 7.5, AGP 호환)
  - .github/workflows/android.yml: adb 설치, cmdline-tools 설치, sdkmanager, per-step 로그 업로드, 실패시 workspace-debug.tar.gz 업로드 등 진단 단계 추가
  - CI 상태: 액티브 디버깅 중(스모크 테스트로 Runner/아티팩트 업로드는 정상)
- 스크립트/도구
  - run_apk.bat: D:\somi_work\sap_guild\run_apk.bat (ADB 재시작 → 에뮬레이터 확인/실행 → 홈/백/잠금 해제 키 이벤트 → APK 설치 → (선택) 앱 실행)
- DB / 백엔드
  - MariaDB 준비(WSL) — 초기 스키마: /home/cys90/.openclaw/workspace/mariadb-docker/initial_schema.sql
  - Node.js 백엔드 템플릿 존재: /home/cys90/.openclaw/workspace/backend
- 메모
  - memory/2026-02-25.md 에 주요 작업 기록 저장됨

권장 다음 단계
- Notion 통합 초대 → 제가 자동 추가
- 또는 제가 레포지토리에 Markdown 파일로 정리해 커밋(자동 삽입 불가 시 우회)

원하실 행동을 골라 한 줄로 알려 주세요
- “통합 초대했음 — 지금 추가해줘” — 제가 바로 삽입
- “통합 초대하기 전인데 레포지토리로 커밋해줘” — 제가 파일로 추가
- “어떻게 초대하는지 그림으로 보여줘” — 초대 방법 안내
