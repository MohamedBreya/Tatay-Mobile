#!/usr/bin/env bash
# Linux/macOS twin of localization_generator.bat.
# Regenerates lib/generated/ from assets/translations/{ar,en}.json.
set -euo pipefail
cd "$(dirname "$0")"
dart run easy_localization:generate -S assets/translations -O lib/generated -o codegen_loader.g.dart
dart run easy_localization:generate -S assets/translations -O lib/generated -o locale_keys.g.dart -f keys
