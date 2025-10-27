@echo off
REM SonarLink v1.0 - Windows Manual Installation (Python 3.13)
REM Use this if automatic installer fails

echo =======================================
echo   SonarLink v1.0 - Manual Install
echo   Windows + Python 3.13
echo =======================================
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found!
    pause
    exit /b 1
)

echo [OK] Python found:
python --version
echo.

REM Detect architecture
python -c "import platform; arch = platform.machine(); print('Architecture:', arch)" > temp_arch.txt
set /p ARCH_LINE=<temp_arch.txt
del temp_arch.txt

echo %ARCH_LINE%
echo.

echo =======================================
echo   Step 1: Download PyAudio Wheel
echo =======================================
echo.
echo Please download PyAudio wheel manually:
echo.
echo 1. Open this link in your browser:
echo    https://github.com/intxcc/pyaudio_portaudio/releases
echo.
echo 2. Download the correct file:
echo    - For 64-bit Windows: PyAudio-0.2.14-cp313-cp313-win_amd64.whl
echo    - For 32-bit Windows: PyAudio-0.2.14-cp313-cp313-win32.whl
echo.
echo 3. Save it to this folder: %CD%
echo.
echo 4. Press any key when done...
pause >nul
echo.

REM Check if wheel exists
if exist "PyAudio-0.2.14-cp313-cp313-win_amd64.whl" (
    set WHEEL=PyAudio-0.2.14-cp313-cp313-win_amd64.whl
    goto :install
)

if exist "PyAudio-0.2.14-cp313-cp313-win32.whl" (
    set WHEEL=PyAudio-0.2.14-cp313-cp313-win32.whl
    goto :install
)

echo [ERROR] PyAudio wheel not found in current directory!
echo.
echo Please make sure you:
echo 1. Downloaded the .whl file
echo 2. Saved it to: %CD%
echo 3. File name is exactly: PyAudio-0.2.14-cp313-cp313-win_amd64.whl
echo    (or win32.whl for 32-bit)
echo.
pause
exit /b 1

:install
echo =======================================
echo   Step 2: Installing PyAudio
echo =======================================
echo.
echo Found: %WHEEL%
echo Installing...
pip install "%WHEEL%"

if errorlevel 1 (
    echo [ERROR] Failed to install PyAudio
    pause
    exit /b 1
)

echo [OK] PyAudio installed
echo.

echo =======================================
echo   Step 3: Installing Other Packages
echo =======================================
echo.

pip install ggwave-wheels cryptography numpy

if errorlevel 1 (
    echo [ERROR] Failed to install packages
    pause
    exit /b 1
)

echo.
echo =======================================
echo   Verification
echo =======================================
echo.

python -c "import pyaudio; print('[OK] PyAudio:', pyaudio.__version__)" 2>nul || echo [FAILED] PyAudio
python -c "import ggwave; print('[OK] ggwave')" 2>nul || echo [FAILED] ggwave
python -c "import cryptography; print('[OK] cryptography')" 2>nul || echo [FAILED] cryptography
python -c "import numpy; print('[OK] numpy:', numpy.__version__)" 2>nul || echo [FAILED] numpy

echo.
echo =======================================
echo   Installation Complete!
echo =======================================
echo.
echo You can now delete the .whl file if you want.
echo.
echo To start SonarLink:
echo   python sonarlink.py
echo.
pause
