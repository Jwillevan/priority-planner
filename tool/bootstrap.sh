#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
command -v flutter >/dev/null || { echo 'Install Flutter stable first; see README.md.' >&2; exit 1; }
flutter --version
scaffold="$PWD/.bootstrap/priority_planner"
if [ -e "$scaffold" ]; then
  echo 'Remove the previous .bootstrap directory before retrying.' >&2
  exit 1
fi
flutter create --no-pub --platforms android --org com.priorityplanner --project-name priority_planner "$scaffold"
mkdir -p android/gradle/wrapper
cp "$scaffold/android/gradlew" android/gradlew
cp "$scaffold/android/gradlew.bat" android/gradlew.bat
cp "$scaffold/android/gradle/wrapper/gradle-wrapper.jar" android/gradle/wrapper/gradle-wrapper.jar
chmod +x android/gradlew
flutter pub get
dart run build_runner build --delete-conflicting-outputs
echo 'Bootstrap complete. Run flutter analyze, flutter test, and flutter build apk --debug.'
