# 実行サンプル
# chmod +x buildAndroid.sh
# buildAndroid.sh stg [--beta] [--offline]             STG向け一般モジュール作成
# buildAndroid.sh stg ccweb [--beta] [--offline]       STG向けCCWebモジュール作成
# buildAndroid.sh pub aab/apk [0] [--beta] [--offline] 本番向け一般モジュール作成
# buildAndroid.sh pub ccweb [--beta] [--offline]       本番向けCCWebモジュール作成
# [--beta]はbetaバージョン、以外は通常バージョン
#「0」はGoogleStoreへの申請回数です。

# keystore配置ファイル：android/key.properties
# keystore保存場所
# /usr/local/Android/.keystore/ispeed_android-key.keystore

# パラメーター取得
# 事前準備
echo "事前準備..."

# ビルト環境
mode="stg"

# ビルトファイルタイプ
type="apk"

# CCWEB指定
ccweb=false
beta=false
ccName=""

# オフライン指定
offline=false

# ビルトバージョン（build.gradle用）
versionCodeFlag=""
versionCodeName=""

# モジュールファイル名称
name="shisankeisei"

# ビルトしたファイルパス
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
  elif [ "$param" == "ccweb" ]; then
    echo "ccwebに設定..."
    ccweb=true
    ccName="cc-"
  elif [ "$param" == "--beta" ]; then
    echo "betaに設定..."
    beta=true
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

if [ "$type" == "aab" ] && [ "$mode" == "pub" ] && [ "$ccweb" == false ]; then
  # 本番、CCWEB以外でaab指定可能
  type="aab"
else
  type="apk"
fi

# システム環境変数設定（build.gradle用）
export envFlg="$mode"
if [ "$mode" == "pub" ] && [ "$versionCodeFlag" != "" ]; then
  echo "申請回数をシステム環境変数に設定"
  export versionCodeFlag="$versionCodeFlag"
fi

# モジュールファイル名称作成
if [ "$mode" == "pub" ]; then
  module="$name-$versionCodeName$ccName$mode.$type"
else
  module="$name-$ccName$mode.$type"
fi

# 出力フォルダ作成(フォルダあれば、削除して作成)
rm -rf apkOutput
mkdir apkOutput

# バックアップフォルダ作成(フォルダあれば、削除して作成)
rm -rf backup
mkdir backup
mkdir backup/env

# ファイルのバックアップ実行
cp -rf env backup
cp -rf ios/Pods/Manifest.lock backup/
cp -rf android/key.properties backup/

# 環境情報設定
if [ "$mode" == "pub" ]; then
  echo "pub向け環境情報作成..."
  cp -f ./env/.env.pub ./env/.env
else
  echo "stg向け環境情報作成..."
  cp -f ./env/.env.stg ./env/.env
fi

# CCWEB設定
if [ "$ccweb" == true ]; then
  search_key="CCWEB_MODE = "
  search_value="true"
  file_path="./env/.env"
  sed -i "" "s/\(${search_key}\).*/\1${search_value}/" $file_path
fi

# BETA設定
if [ "$beta" == true ]; then
  search_key="BETA_VERSION = "
  search_value="true"
  file_path="./env/.env"
  sed -i "" "s/\(${search_key}\).*/\1${search_value}/" $file_path
fi

# keystoreパス設定
search_key="key.store.genapk="
search_value="/usr/local/Android/.keystore/ispeed_android-key.keystore"
file_path="android/key.properties"
sed -i "" "s#\(${search_key}\).*#\1${search_value}/#" $file_path

# モジュール作成

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
  # モジュール移動
  cp -rf "build/app/outputs/bundle/release/app-release.$type" "apkOutput/$module"
else
  echo "apk作成..."
  flutter build apk --release --no-pub --obfuscate --split-debug-info=apkOutput --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json
  # モジュール移動
  cp -rf "build/app/outputs/flutter-apk/app-release.$type" "apkOutput/$module"
  cp -rf "build/app/outputs/flutter-apk/app-release.$type.sha1" "apkOutput/$module.sha1"
fi

# バックアップファイル復帰
cp -rf backup/env/ env/
cp -rf backup/Manifest.lock ios/Pods/Manifest.lock
cp -rf backup/key.properties android/key.properties
rm -rf backup

open apkOutput
