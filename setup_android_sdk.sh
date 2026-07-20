#!/bin/bash
set -e

echo "=== Creating Android SDK directories ==="
mkdir -p /app/applet/android-sdk/cmdline-tools

echo "=== Downloading Android CommandLine Tools ==="
curl -L https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o cmdline-tools.zip

echo "=== Extracting CommandLine Tools ==="
unzip -q cmdline-tools.zip -d /app/applet/android-sdk/cmdline-tools
rm cmdline-tools.zip

echo "=== Organizing directories for latest ==="
# Inside /app/applet/android-sdk/cmdline-tools, the root of zip extraction is 'cmdline-tools'.
# We rename it to 'latest'.
mv /app/applet/android-sdk/cmdline-tools/cmdline-tools /app/applet/android-sdk/cmdline-tools/latest

echo "=== Installing Platform 35, Build Tools 35, and Platform-Tools ==="
yes | /app/applet/android-sdk/cmdline-tools/latest/bin/sdkmanager --sdk_root=/app/applet/android-sdk "platforms;android-35" "build-tools;35.0.0" "platform-tools"

echo "=== Accepting Licenses ==="
yes | /app/applet/android-sdk/cmdline-tools/latest/bin/sdkmanager --sdk_root=/app/applet/android-sdk --licenses

echo "=== Creating local.properties ==="
echo "sdk.dir=/app/applet/android-sdk" > /app/applet/android/local.properties

echo "=== Android SDK setup completed successfully! ==="
