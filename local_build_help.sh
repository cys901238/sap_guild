#!/bin/bash
# local_build_help.sh - helper instructions to build sap_guild locally

set -euo pipefail
cat <<'EOS'
Local build helper for sap_guild Android project

1) Install JDK 11 and Android SDK if not installed.
   - On Ubuntu: sudo apt install openjdk-11-jdk
   - Use Android Studio or sdkmanager to install SDK platforms and build-tools for API 33.

2) Create local.properties with sdk.dir, e.g.:
   sdk.dir=/home/youruser/Android/Sdk

3) Ensure Gradle wrapper exists. If ./gradlew is missing, install Gradle or generate wrapper from a machine with Gradle:
   - Option A: Install Gradle (apt or sdkman) and run: gradle wrapper
   - Option B: Manually copy a gradlew and gradle/wrapper files from a working project

4) Build:
   chmod +x ./gradlew
   ./gradlew assembleDebug

5) Install to emulator/device:
   adb install -r app/build/outputs/apk/debug/app-debug.apk
   # For real device, expose host backend:
   adb reverse tcp:3000 tcp:3000

EOS
