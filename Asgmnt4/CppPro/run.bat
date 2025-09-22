@echo off
REM run script for Employee Schedule Manager
echo ========================================
echo Employee Schedule Management System
echo ========================================

if exist "main.exe" (
    echo Starting program...
    echo.
    main.exe
) else (
    echo [ERROR] main.exe not found!
    echo Please build the project first by running: build.bat
    echo.
    pause
)

echo.
echo Program finished.
pause