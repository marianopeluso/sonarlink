#!/bin/bash
# SonarLink v1.0 - macOS Installation Script
# Supports both Intel (x86_64) and Apple Silicon (ARM64) Macs

echo "======================================="
echo "  SonarLink v1.0 - macOS Installer"
echo "======================================="
echo ""

# Detect architecture
ARCH=$(uname -m)
echo "[1/6] Detecting Mac architecture..."
echo "[OK] Architecture: $ARCH"

case $ARCH in
    x86_64)
        ARCH_TYPE="Intel"
        ;;
    arm64)
        ARCH_TYPE="Apple Silicon"
        ;;
    *)
        echo "[WARNING] Unknown architecture: $ARCH"
        ARCH_TYPE="Unknown"
        ;;
esac

echo "[OK] Mac type: $ARCH_TYPE"
echo ""

# Check for Homebrew
echo "[2/6] Checking Homebrew..."

if ! command -v brew &> /dev/null; then
    echo "[WARNING] Homebrew not found"
    echo ""
    echo "Homebrew is required for installing dependencies."
    echo "Install Homebrew from: https://brew.sh"
    echo ""
    echo "Run this command:"
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    echo ""
    read -p "Press Enter after installing Homebrew, or Ctrl+C to exit..."
    
    # Check again
    if ! command -v brew &> /dev/null; then
        echo "[ERROR] Homebrew still not found"
        exit 1
    fi
fi

echo "[OK] Homebrew found"
brew --version
echo ""

# Check Python
echo "[3/6] Checking Python installation..."

if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    echo "[OK] $PYTHON_VERSION found"
    
    # Extract version
    PYTHON_MAJOR=$(python3 -c "import sys; print(sys.version_info.major)")
    PYTHON_MINOR=$(python3 -c "import sys; print(sys.version_info.minor)")
    echo "[OK] Python version: $PYTHON_MAJOR.$PYTHON_MINOR"
else
    echo "[WARNING] Python 3 not found"
    echo "Installing Python 3 via Homebrew..."
    brew install python3
fi

echo ""

# Install system dependencies
echo "[4/6] Installing system dependencies..."

echo "Installing PortAudio..."
brew install portaudio

if [ $? -ne 0 ]; then
    echo "[WARNING] Failed to install portaudio"
    echo "Continuing anyway..."
fi

echo ""

# Check pip
echo "[5/6] Checking pip..."

if command -v pip3 &> /dev/null; then
    echo "[OK] pip3 found"
else
    echo "Installing pip..."
    python3 -m ensurepip --upgrade
fi

# Upgrade pip
echo "Upgrading pip..."
python3 -m pip install --upgrade pip --user

echo ""

# Install Python packages
echo "[6/6] Installing Python packages..."
echo ""

# Special handling for Apple Silicon
if [ "$ARCH_TYPE" = "Apple Silicon" ]; then
    echo "[INFO] Apple Silicon detected"
    echo "[INFO] Some packages may need Rosetta 2 or native compilation"
    echo ""
fi

echo "Installing PyAudio..."

# Try pip first
python3 -m pip install --user pyaudio

if [ $? -ne 0 ]; then
    echo "[WARNING] pip installation failed, trying with portaudio flags..."
    
    # Get portaudio paths from Homebrew
    PORTAUDIO_PATH=$(brew --prefix portaudio)
    
    if [ -d "$PORTAUDIO_PATH" ]; then
        echo "Using portaudio from: $PORTAUDIO_PATH"
        
        # Set compiler flags
        export CFLAGS="-I$PORTAUDIO_PATH/include"
        export LDFLAGS="-L$PORTAUDIO_PATH/lib"
        
        python3 -m pip install --user --no-cache-dir pyaudio
        
        # Unset flags
        unset CFLAGS
        unset LDFLAGS
    else
        echo "[ERROR] Could not locate portaudio installation"
        echo ""
        echo "Please try:"
        echo "  brew reinstall portaudio"
        echo "  pip3 install --user pyaudio"
        echo ""
        read -p "Continue with other packages? (y/N): " continue
        if [ "$continue" != "y" ] && [ "$continue" != "Y" ]; then
            exit 1
        fi
    fi
fi

echo ""
echo "Installing ggwave-wheels..."
python3 -m pip install --user ggwave-wheels

echo ""
echo "Installing cryptography..."
python3 -m pip install --user cryptography

echo ""
echo "Installing numpy..."
python3 -m pip install --user numpy

echo ""

# Verify installation
echo "======================================="
echo "  Verifying Installation"
echo "======================================="
echo ""

FAILED=0

echo -n "Checking pyaudio... "
python3 -c "import pyaudio; print('[OK] Version:', pyaudio.__version__)" 2>/dev/null || { echo "[FAILED]"; FAILED=1; }

echo -n "Checking ggwave... "
python3 -c "import ggwave; print('[OK]')" 2>/dev/null || { echo "[FAILED]"; FAILED=1; }

echo -n "Checking cryptography... "
python3 -c "import cryptography; print('[OK]')" 2>/dev/null || { echo "[FAILED]"; FAILED=1; }

echo -n "Checking numpy... "
python3 -c "import numpy; print('[OK] Version:', numpy.__version__)" 2>/dev/null || { echo "[FAILED]"; FAILED=1; }

echo ""

# Architecture-specific notes
if [ "$ARCH_TYPE" = "Apple Silicon" ]; then
    echo "======================================="
    echo "  Apple Silicon Notes"
    echo "======================================="
    echo ""
    echo "Running on Apple Silicon (M1/M2/M3)"
    echo "- All packages should work natively"
    echo "- Performance is excellent"
    echo "- Audio processing is very fast"
    echo ""
elif [ "$ARCH_TYPE" = "Intel" ]; then
    echo "======================================="
    echo "  Intel Mac Notes"
    echo "======================================="
    echo ""
    echo "Running on Intel Mac"
    echo "- All packages should work normally"
    echo "- Performance depends on processor"
    echo ""
fi

if [ $FAILED -eq 0 ]; then
    echo "======================================="
    echo "  Installation Complete!"
    echo "======================================="
    echo ""
    echo "To start SonarLink:"
    echo "  python3 sonarlink.py"
    echo ""
    echo "For help, see README.md"
    echo ""
else
    echo "======================================="
    echo "  Installation Completed with Errors"
    echo "======================================="
    echo ""
    echo "Some packages failed to install."
    echo "Please check the error messages above."
    echo ""
    echo "Common solutions:"
    echo "1. Reinstall portaudio: brew reinstall portaudio"
    echo "2. Try manual install: pip3 install --user pyaudio"
    echo ""
fi

# Make sonarlink.py executable if it exists
if [ -f "sonarlink.py" ]; then
    chmod +x sonarlink.py
    echo "Made sonarlink.py executable"
    echo ""
fi

echo "Note: On macOS, you may need to grant microphone permissions"
echo "in System Settings > Privacy & Security > Microphone"
echo ""
