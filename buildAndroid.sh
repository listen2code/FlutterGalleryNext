#!/bin/bash

# 実行サンプル
# chmod +x buildAndroid.sh
# buildAndroid.sh stg [--offline]             STG向け一般モジュール作成
# buildAndroid.sh pub aab/apk [0] [--offline] 本番向け一般モジュール作成
#「0」はGoogleStoreへの申請回数です。

# --- Configuration ---
# keystore and properties files are located in: android/keystore/
# Keystore file: flutter_gallery_next.jks
# Properties file: keystore.properties

# --- Script Start ---
echo "事前準備..."

# Default values
mode="stg"
type="apk"
offline=false
versionCodeFlag=""
versionCodeName=""
name="shisankeisei"

# Parameter parsing
from="build/app/outputs/flutter-apk"
for param in "$@"; do
  if [ "$param" == "pub" ]; then
    echo "pubに設定..."
    mode="pub"
  elif [ "$param" == "stg" ]; then
    echo "stgに設定..."
    mode="stg"
  elif [ "$param" == "aab" ]; then
    echo "aabに設定..."
    type="aab"
    from="build/app/outputs/bundle/release"
  elif [ "$param" == "apk" ]; then
    echo "apkに設定..."
    type="apk"
    from="build/app/outputs/flutter-apk"
  elif [ "$param" == "--offline" ]; then
    echo "offlineに設定..."
    offline=true
  elif [ "$param" == "--online" ]; then
    echo "onlineに設定..."
    offline=false
  elif [[ "$param" =~ ^[0-9]+$ ]]; then
    echo "申請回数[$param]に設定..."
    versionCodeFlag="$param"
    versionCodeName="$versionCodeFlag-"
  fi
done

# Validate build type
if [ "$type" == "aab" ] && [ "$mode" == "pub" ]; then
  type="aab"
else
  type="apk"
fi

# Set environment variables for build.gradle
export envFlg="$mode"
if [ "$mode" == "pub" ] && [ "$versionCodeFlag" != "" ]; then
  echo "申請回数をシステム環境変数に設定"
  export versionCodeFlag="$versionCodeFlag"
fi

# Create output module filename
if [ "$mode" == "pub" ]; then
  module="$name-$versionCodeName$mode.$type"
else
  module="$name-$mode.$type"
fi

# Create output and backup directories
rm -rf apkOutput
mkdir apkOutput

rm -rf backup
mkdir backup
mkdir backup/env
mkdir backup/keystore

# Backup files
echo "Backing up files..."
cp -rf env backup/env
cp -rf ios/Pods/Manifest.lock backup/
cp -rf android/keystore/keystore.properties backup/keystore/

# Set up environment for the build
if [ "$mode" == "pub" ]; then
  echo "pub向け環境情報作成..."
  cp -f ./env/.env.pub ./env/.env
else
  echo "stg向け環境情報作成..."
  cp -f ./env/.env.stg ./env/.env
fi

# Build the module
if [ "$offline" == false ]; then
  echo "flutter pub get online 執行..."
  flutter clean
  flutter pub get
else
  echo "flutter pub get offline 執行..."
  flutter clean
  flutter pub get --offline
fi

if [ "$type" == "aab" ]; then
  echo "aab作成..."
  flutter build appbundle --no-pub --release --obfuscate --split-debug-info=apkOutput --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json
  # Move module
  cp -rf "build/app/outputs/bundle/release/app-release.$type" "apkOutput/$module"
else
  echo "apk作成..."
  flutter build apk --release --no-pub --obfuscate --split-debug-info=apkOutput --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json
  # Move module
  cp -rf "build/app/outputs/flutter-apk/app-release.$type" "apkOutput/$module"
  cp -rf "build/app/outputs/flutter-apk/app-release.$type.sha1" "apkOutput/$module.sha1"
fi

# Restore backup files
echo "Restoring files..."
cp -rf backup/env/ env/
cp -rf backup/Manifest.lock ios/Pods/Manifest.lock
cp -rf backup/keystore/keystore.properties android/keystore/
rm -rf backup

echo "Build finished. Opening output directory..."
open apkOutput
