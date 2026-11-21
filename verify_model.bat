
@echo off
setlocal

set "BASE=%~dp0.."
set "NUSMV=%BASE%\bin\NuSMV.exe"

if "%~1"=="" (
    echo ERROR: Model file not specified.
    exit /b 1
)

set "MODEL=%~1"

echo ======================================
echo NuSMV Automated Verification
echo ======================================
echo Model: %MODEL%
echo.

if not exist "%MODEL%" (
    echo ERROR: Model file not found.
    exit /b 1
)

"%NUSMV%" "%MODEL%" > "%TEMP%\nusmv_result.txt" 2>&1

if errorlevel 1 (
    type "%TEMP%\nusmv_result.txt"
    echo.
    echo VERIFICATION ERROR
    exit /b 1
)

type "%TEMP%\nusmv_result.txt"

findstr /C:"is false" "%TEMP%\nusmv_result.txt" >nul

if not errorlevel 1 (
    echo.
    echo VERIFICATION FAILED
    exit /b 1
)

findstr /C:"is true" "%TEMP%\nusmv_result.txt" >nul

if errorlevel 1 (
    echo.
    echo ERROR: No verification results found.
    exit /b 1
)

echo.
echo VERIFICATION PASSED
exit /b 0
