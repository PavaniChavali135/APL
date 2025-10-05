@echo off
echo ==========================================
echo    RIDE SHARING SYSTEM - DEMO script
echo ==========================================
echo.


echo Compilation Start ... 

cl /EHsc /std:c++11 main.cpp Ride.cpp StandardRide.cpp PremiumRide.cpp Driver.cpp Rider.cpp /Fe:ride_sharing_system.exe >nul 2>&1
if %errorlevel% == 0 (
    echo Compilation successful.
    del *.obj >nul 2>&1
    goto :success
) else (
    echo Compilation failed.
)


goto :end

:success
echo.
echo RUNNING THE PROGRAM...\r\n
echo.
if exist ride_sharing_system.exe (
    ride_sharing_system.exe
) else (
    echo Error: Executable not found!
)

:end
echo.
echo Press any key to exit...
pause >nul