#!/bin/bash
# SonarLink v1.0 - Linux Installation Script
# Supports multiple distributions and architectures (x86_64, ARM64, ARM32)

echo "======================================="
echo "  SonarLink v1.0 - Linux Installer"
echo "======================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo "[WARNING] Running as root. This is not recommended."
    echo "Consider running as a normal user with sudo when needed."
    echo ""
fi

# Detect architecture
ARCH=$(uname -m)
echo "[1/6] Detecting system architecture..."
echo "[OK] Architecture: $ARCH"

case $ARCH in
    x86_64|amd64)
        ARCH_TYPE="x86_64"
        ;;
    aarch64|arm64)
        ARCH_TYPE="arm64"
        ;;
    armv7l|armv6l)
        ARCH_TYPE="arm32"
        ;;
    *)
        echo "[WARNING] Unknown architecture: $ARCH"
        ARCH_TYPE="unknown"
        ;;
esac

echo "[OK] Detected architecture type: $ARCH_TYPE"
echo ""

# Detect Linux distribution
echo "[2/6] Detecting Linux distribution..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    echo "[OK] Detected: $PRETTY_NAME"
elif [ -f /etc/debian_version ]; then
    DISTRO="debian"
    echo "[OK] Detected: Debian-based"
elif [ -f /etc/arch-release ]; then
    DISTRO="arch"
    echo "[OK] Detected: Arch Linux"
elif [ -f /etc/fedora-release ]; then
    DISTRO="fedora"
    echo "[OK] Detected: Fedora"
else
    echo "[WARNING] Unknown distribution"
    echo "Proceeding with generic installation..."
    DISTRO="unknown"
fi

echo ""

# Check Python
echo "[3/6] Checking Python installation..."

if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    echo "[OK] $PYTHON_VERSION found"
    
    # Extract major and minor version
    PYTHON_MAJOR=$(python3 -c "import sys; print(sys.version_info.major)")
    PYTHON_MINOR=$(python3 -c "import sys; print(sys.version_info.minor)")
    echo "[OK] Python version: $PYTHON_MAJOR.$PYTHON_MINOR"
else
    echo "[ERROR] Python 3 not found"
    echo "Installing Python 3..."
    
    case $DISTRO in
        ubuntu|debian|linuxmint|raspbian)
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm python python-pip
            ;;
        fedora|rhel|centos)
            sudo dnf install -y python3 python3-pip
            ;;
        *)
            echo "[ERROR] Please install Python 3 manually"
            exit 1
            ;;
    esac
fi

echo ""

# Install system dependencies
echo "[4/6] Installing system dependencies..."

case $DISTRO in
    ubuntu|debian|linuxmint|raspbian)
        echo "Installing packages for Debian/Ubuntu-based systems..."
        sudo apt-get update
        sudo apt-get install -y \
            portaudio19-dev \
            python3-dev \
            build-essential \
            gcc \
            git
        
        # Try to install python3-pyaudio from system repos
        echo ""
        echo "Attempting to install PyAudio from system repository..."
        sudo apt-get install -y python3-pyaudio 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo "[OK] PyAudio installed from system repository"
            PYAUDIO_INSTALLED=1
        else
            echo "[INFO] System PyAudio not available, will use pip"
            PYAUDIO_INSTALLED=0
        fi
        ;;
    arch|manjaro)
        echo "Installing packages for Arch Linux..."
        sudo pacman -S --noconfirm \
            portaudio \
            python-pyaudio \
            base-devel \
            git
        
        PYAUDIO_INSTALLED=1
        ;;
    fedora|rhel|centos)
        echo "Installing packages for Fedora/RHEL..."
        sudo dnf install -y \
            portaudio-devel \
            python3-devel \
            gcc \
            gcc-c++ \
            git
        
        PYAUDIO_INSTALLED=0
        ;;
    opensuse*)
        echo "Installing packages for openSUSE..."
        sudo zypper install -y \
            portaudio-devel \
            python3-devel \
            gcc \
            gcc-c++ \
            git
        
        PYAUDIO_INSTALLED=0
        ;;
    *)
        echo "[WARNING] Unknown distribution - skipping system packages"
        echo "You may need to install: portaudio-dev, python3-dev, build-essential"
        PYAUDIO_INSTALLED=0
        ;;
esac

if [ $? -ne 0 ]; then
    echo "[WARNING] Some system packages failed to install"
    echo "Continuing with Python packages..."
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

# Install PyAudio if not already installed from system repos
if [ $PYAUDIO_INSTALLED -eq 0 ]; then
    echo "Installing PyAudio from pip..."
    
    # For ARM architectures, might need special handling
    if [ "$ARCH_TYPE" = "arm64" ] || [ "$ARCH_TYPE" = "arm32" ]; then
        echo "[INFO] ARM architecture detected"
        echo "[INFO] Installing PyAudio with --no-cache-dir flag..."
        python3 -m pip install --user --no-cache-dir pyaudio
    else
        python3 -m pip install --user pyaudio
    fi
    
    if [ $? -ne 0 ]; then
        echo "[WARNING] PyAudio installation failed"
        echo ""
        echo "Common solutions:"
        echo "1. Install system package:"
        echo "   - Ubuntu/Debian: sudo apt-get install python3-pyaudio"
        echo "   - Arch: sudo pacman -S python-pyaudio"
        echo ""
        echo "2. Install development libraries:"
        echo "   - Ubuntu/Debian: sudo apt-get install portaudio19-dev python3-dev"
        echo "   - Fedora: sudo dnf install portaudio-devel python3-devel"
        echo ""
        read -p "Continue with other packages? (y/N): " continue
        if [ "$continue" != "y" ] && [ "$continue" != "Y" ]; then
            exit 1
        fi
    fi
else
    echo "[OK] PyAudio already installed from system repository"
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
if [ "$ARCH_TYPE" = "arm64" ]; then
    echo "======================================="
    echo "  ARM64 Notes"
    echo "======================================="
    echo ""
    echo "Running on ARM64 architecture (e.g., Raspberry Pi 4/5, Apple Silicon)"
    echo "- All packages should work normally"
    echo "- Performance may vary based on hardware"
    echo ""
elif [ "$ARCH_TYPE" = "arm32" ]; then
    echo "======================================="
    echo "  ARM32 Notes"
    echo "======================================="
    echo ""
    echo "Running on ARM32 architecture (e.g., Raspberry Pi 3/Zero)"
    echo "- Some packages may compile slowly"
    echo "- Audio processing may be slower"
    echo "- Consider using smaller files"
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
    echo "You may need to install missing packages manually:"
    echo "  pip3 install --user pyaudio ggwave-wheels cryptography numpy"
    echo ""
    echo "Or install system packages:"
    case $DISTRO in
        ubuntu|debian|linuxmint|raspbian)
            echo "  sudo apt-get install python3-pyaudio"
            ;;
        arch|manjaro)
            echo "  sudo pacman -S python-pyaudio"
            ;;
    esac
    echo ""
fi

# Make sonarlink.py executable if it exists
if [ -f "sonarlink.py" ]; then
    chmod +x sonarlink.py
    echo "Made sonarlink.py executable"
    echo ""
fi
