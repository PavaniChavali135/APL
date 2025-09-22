@echo off
REM Direct compilation using MSVC compiler

echo ========================================
echo Employee Schedule Manager Script using C++ 
echo ========================================

REM Clean up any existing executable
if exist "main.exe" (
    echo Cleaning up previous build...
    del main.exe
)

echo.
echo.
echo Attempting to compile with MSVC...
cl >nul 2>&1
if not errorlevel 1 (
    echo [OK] Found MSVC compiler
    echo Compiling source files...
    cl /std:c++11 /EHsc /W4 /O2 /Fe:main.exe main.cpp Employee.cpp Shift.cpp Schedule.cpp ScheduleManager.cpp
    
    if not errorlevel 1 (
        echo [OK] Build successful with MSVC!
        goto :run_program
    ) else (
        echo [ERROR] Build failed with MSVC
        goto :error_exit
    )
) else (
    echo [ERROR] No suitable compiler found!
    echo Please install either:
    echo   1. MinGW-w64 (includes g++)
    echo   2. Visual Studio Build Tools (includes MSVC)
    goto :error_exit
)

:run_program
echo.
echo ========================================
echo Build completed successfully!
echo ========================================
echo.
if exist "main.exe" (
    echo Executable created: main.exe
    echo.
    choice /c YN /m "Do you want to run the program now"
    if errorlevel 2 (
        echo.
        echo To run the program later, execute: main.exe
        echo.
        pause
        exit /b 0
    )
    if errorlevel 1 (
        echo.
        echo Starting Employee Schedule Management System...
        echo.
        main.exe
    )
) else (
    echo [ERROR] Executable not found after successful build
)

echo.
echo Program execution completed.
pause
exit /b 0

:error_exit
echo.
echo Build failed! Please check the error messages above.
pause
exit /b 1