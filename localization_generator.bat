@echo off
REM Regenerates lib/generated/ from assets/translations/{ar,en}.json.
cd /d "%~dp0"
call dart run easy_localization:generate -S assets/translations -O lib/generated -o codegen_loader.g.dart
call dart run easy_localization:generate -S assets/translations -O lib/generated -o locale_keys.g.dart -f keys
