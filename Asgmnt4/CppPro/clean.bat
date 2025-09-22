@echo off
REM Clean script for Employee Schedule Manager
echo ========================================
echo Cleaning build artifacts...
echo ========================================

REM Remove executable
if exist "main.exe" (
    echo Removing main.exe...
    del main.exe
)

REM Remove object files (if any)
if exist "*.o" (
    echo Removing object files...
    del *.o
)

REM Remove Visual Studio temporary files (if any)
if exist "*.obj" (
    echo Removing Visual Studio object files...
    del *.obj
)

if exist "*.pdb" (
    echo Removing debug files...
    del *.pdb
)

if exist "*.ilk" (
    echo Removing incremental link files...
    del *.ilk
)

echo.
echo Clean completed!
pause