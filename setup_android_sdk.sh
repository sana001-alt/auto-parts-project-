#!/bin/bash
set -e

echo "=== Creating Android SDK directories ==="
mkdir -p /opt/android-sdk/cmdline-tools

echo "=== Downloading Android CommandLine Tools ==="
curl -L https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o cmdline-tools.zip

echo "=== Extracting CommandLine Tools ==="
unzip -q cmdline-tools.zip -d /opt/android-sdk/cmdline-tools
rm cmdline-tools.zip

echo "=== Organizing directories for latest ==="
# Inside /opt/android-sdk/cmdline-tools, the root of zip extraction is 'cmdline-tools'.
# We rename it to 'latest'.
mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest

echo "=== Installing Platform 35, Build Tools 35, and Platform-Tools ==="
yes | /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager --sdk_root=/opt/android-sdk "platforms;android-35" "build-tools;35.0.0" "platform-tools"

echo "=== Accepting Licenses ==="
yes | /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager --sdk_root=/opt/android-sdk --licenses

echo "=== Creating local.properties ==="
echo "sdk.dir=/opt/android-sdk" > /app/applet/android/local.properties

echo "=== Android SDK setup completed successfully! ==="
