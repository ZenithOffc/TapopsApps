#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install -y wget unzip git openjdk-17-jdk

cd /workspaces
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:/workspaces/flutter/bin"
echo 'export PATH="$PATH:/workspaces/flutter/bin"' >> ~/.bashrc

mkdir android-sdk
cd android-sdk
wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip
unzip commandlinetools-linux-8512546_latest.zip

export ANDROID_SDK_ROOT=/workspaces/android-sdk
export ANDROID_HOME=/workspaces/android-sdk
export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/bin"
echo 'export ANDROID_SDK_ROOT=/workspaces/android-sdk' >> ~/.bashrc
echo 'export ANDROID_HOME=/workspaces/android-sdk' >> ~/.bashrc
echo 'export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/bin"' >> ~/.bashrc
source ~/.bashrc

yes | sdkmanager --sdk_root=/workspaces/android-sdk --licenses
sdkmanager --sdk_root=/workspaces/android-sdk "platforms;android-33" "build-tools;33.0.2" "platform-tools"

flutter precache
flutter config --enable-android

cd /workspaces/xyz_project
flutter clean
flutter pub get
flutter build apk --release

ls -la build/app/outputs/flutter-apk/
echo "APK siap: build/app/outputs/flutter-apk/app-debug.apk"