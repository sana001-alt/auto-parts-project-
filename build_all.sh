#!/bin/bash
set -e

echo "=== 1. Installing Java and Unzip ==="
killall -9 apt-get apt dpkg 2>/dev/null || true
rm -f /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/lib/apt/lists/lock /var/cache/apt/archives/lock
export DEBIAN_FRONTEND=noninteractive
dpkg --configure -a --force-confold --force-confdef
apt-get update
apt-get install -y -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" openjdk-21-jdk-headless unzip

echo "=== 2. Setting up Android SDK ==="
rm -rf /app/applet/android-sdk
mkdir -p /app/applet/android-sdk/cmdline-tools
curl -L https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o cmdline-tools.zip
unzip -q cmdline-tools.zip -d /app/applet/android-sdk/cmdline-tools
rm cmdline-tools.zip
mv /app/applet/android-sdk/cmdline-tools/cmdline-tools /app/applet/android-sdk/cmdline-tools/latest

echo "=== 3. Installing Platform 35, Build Tools 35, and Platform-Tools ==="
yes | /app/applet/android-sdk/cmdline-tools/latest/bin/sdkmanager --sdk_root=/app/applet/android-sdk "platforms;android-35" "build-tools;35.0.0" "platform-tools"
yes | /app/applet/android-sdk/cmdline-tools/latest/bin/sdkmanager --sdk_root=/app/applet/android-sdk --licenses

echo "=== 4. Setting local.properties ==="
echo "sdk.dir=/app/applet/android-sdk" > /app/applet/android/local.properties

echo "=== 5. Replacing corrupt Gradle Wrapper jar ==="
curl -L https://raw.githubusercontent.com/gradle/gradle/v8.14.3/gradle/wrapper/gradle-wrapper.jar -o /app/applet/android/gradle/wrapper/gradle-wrapper.jar

echo "=== 6. Compiling Android Debug APK ==="
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
chmod +x /app/applet/android/gradlew
/app/applet/android/gradlew clean assembleDebug -p /app/applet/android

echo "=== 7. Copying generated APK to workspace root ==="
cp /app/applet/android/app/build/outputs/apk/debug/app-debug.apk /app/applet/app-debug.apk

echo "=== 8. Validating APK Integrity and Badging ==="
/app/applet/android-sdk/build-tools/35.0.0/aapt dump badging /app/applet/app-debug.apk
/app/applet/android-sdk/build-tools/35.0.0/apksigner verify /app/applet/app-debug.apk

echo "=== BUILD AND VALIDATION SUCCESSFUL ==="
