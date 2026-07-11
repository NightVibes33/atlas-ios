#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_DIR="$ROOT/apps/ios"
DERIVED_DATA="$ROOT/build/DerivedData"
ARTIFACT_DIR="$ROOT/build/artifacts"
PAYLOAD_DIR="$ARTIFACT_DIR/Payload"
APP_PATH="$DERIVED_DATA/Build/Products/Release-iphoneos/Atlas.app"
IPA_PATH="$ARTIFACT_DIR/Atlas-unsigned.ipa"

rm -rf "$DERIVED_DATA" "$ARTIFACT_DIR"
mkdir -p "$PAYLOAD_DIR"

command -v xcodegen >/dev/null || { echo "xcodegen is required" >&2; exit 1; }
(cd "$PROJECT_DIR" && xcodegen generate)

xcodebuild \
  -project "$PROJECT_DIR/Atlas.xcodeproj" \
  -scheme AtlasApp \
  -configuration Release \
  -sdk iphoneos \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "$DERIVED_DATA" \
  ONLY_ACTIVE_ARCH=NO \
  ARCHS=arm64 \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY='' \
  DEVELOPMENT_TEAM='' \
  build

[[ -d "$APP_PATH" ]] || { echo "Built app not found at $APP_PATH" >&2; exit 1; }
rm -rf "$APP_PATH/_CodeSignature"
rm -f "$APP_PATH/embedded.mobileprovision"
cp -R "$APP_PATH" "$PAYLOAD_DIR/Atlas.app"

(
  cd "$ARTIFACT_DIR"
  /usr/bin/zip -qry "$(basename "$IPA_PATH")" Payload
)

EXECUTABLE="$PAYLOAD_DIR/Atlas.app/Atlas"
[[ -f "$EXECUTABLE" ]] || { echo "Atlas executable missing" >&2; exit 1; }
file "$EXECUTABLE"
lipo -info "$EXECUTABLE"

if codesign -dvv "$PAYLOAD_DIR/Atlas.app" >/dev/null 2>&1; then
  echo "The app still contains a code signature" >&2
  exit 1
fi

unzip -t "$IPA_PATH"
shasum -a 256 "$IPA_PATH" | tee "$IPA_PATH.sha256"
echo "Unsigned device IPA created: $IPA_PATH"
