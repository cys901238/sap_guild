# sap_guild

SAP Guild test Android app (simple demo). Build with Gradle and install APK to emulator/device.

## Build (local)

1. Ensure Android SDK and JDK are installed and `local.properties` points to sdk.dir.
2. Build debug APK:

```bash
./gradlew assembleDebug
```

3. APK location:

```
app/build/outputs/apk/debug/app-debug.apk
```

## Run backend (development)

- Backend location (example): `/home/cys90/.openclaw/workspace/backend`
- Emulator base URL: `http://10.0.2.2:3000/`

## Install to device/emulator

```bash
adb install -r app/build/outputs/apk/debug/app-debug.apk
# or if testing with device and backend on host:
adb reverse tcp:3000 tcp:3000
```

## Notes
- Keep credentials out of the repository. Use `.env` for backend configuration.
- This repo intentionally excludes build artifacts and SDK bundles (.gitignore).

