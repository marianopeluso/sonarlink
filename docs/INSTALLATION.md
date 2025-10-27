# 🔧 SonarLink - Installation Guide

**Sonarlink - Private file transfer, powered by sound**

Comprehensive installation instructions for all platforms and architectures.

---

## 📋 Table of Contents

- [Windows 64-bit](#-windows-64-bit-x86_64amd64)
- [Windows 32-bit](#-windows-32-bit-x86)
- [Linux x86_64](#-linux-x86_64)
- [Linux ARM64](#-linux-arm64-raspberry-pi-4-arm-servers)
- [Linux ARM32](#-linux-arm32-raspberry-pi-3zero)
- [macOS Intel](#-macos-intel-x86_64)
- [macOS Apple Silicon](#-macos-apple-silicon-m1m2m3)

---

## 🪟 Windows 64-bit (x86_64/AMD64)

**Most common Windows systems**

### Automatic Installation

```cmd
# Download and run
install_windows.bat
```

### What It Does

1. ✅ Detects Python 3.13+
2. ✅ Automatically downloads PyAudio wheel for 64-bit
3. ✅ Installs ggwave-wheels, cryptography, numpy
4. ✅ Verifies all packages

### Manual Installation

If automatic install fails:

```cmd
# 1. Download PyAudio wheel
# Visit: https://github.com/intxcc/pyaudio_portaudio/releases
# Download: PyAudio-0.2.14-cp313-cp313-win_amd64.whl

# 2. Install PyAudio
pip install PyAudio-0.2.14-cp313-cp313-win_amd64.whl

# 3. Install other packages
pip install ggwave-wheels cryptography numpy

# 4. Test
python -c "import pyaudio; print('OK')"
```

### Requirements

- Python 3.8+ (3.13 recommended)
- Windows 10 or 11
- 64-bit system
- Internet connection for downloads

---

## 🪟 Windows 32-bit (x86)

**Older Windows systems or 32-bit installations**

### Automatic Installation

```cmd
# Download and run
install_windows_32bit.bat
```

### Manual Installation

```cmd
# 1. Download PyAudio wheel for 32-bit
# Visit: https://github.com/intxcc/pyaudio_portaudio/releases
# Download: PyAudio-0.2.14-cp313-cp313-win32.whl

# 2. Install PyAudio
pip install PyAudio-0.2.14-cp313-cp313-win32.whl

# 3. Install other packages
pip install ggwave-wheels cryptography numpy
```

### How to Check if You Have 32-bit Windows

```cmd
python -c "import platform; print(platform.machine())"
```

If it shows `x86` or `i386` → You have 32-bit  
If it shows `AMD64` or `x86_64` → You have 64-bit

---

## 🐧 Linux x86_64

**Standard Desktop Linux (Ubuntu, Debian, Fedora, Arch, etc.)**

### Automatic Installation

```bash
# Download and run
chmod +x install_linux.sh
./install_linux.sh
```

### What It Does

1. ✅ Detects your Linux distribution
2. ✅ Installs system packages (portaudio, build tools)
3. ✅ Installs Python packages
4. ✅ Verifies installation

### Manual Installation

#### Ubuntu/Debian/Mint

```bash
# 1. Install system dependencies
sudo apt-get update
sudo apt-get install -y portaudio19-dev python3-pyaudio python3-dev build-essential

# 2. Install Python packages
pip3 install --user ggwave-wheels cryptography numpy

# 3. Run SonarLink
python3 sonarlink.py
```

#### Arch/Manjaro

```bash
# 1. Install system dependencies
sudo pacman -S portaudio python-pyaudio base-devel

# 2. Install Python packages
pip install --user ggwave-wheels cryptography numpy
```

#### Fedora/RHEL/CentOS

```bash
# 1. Install system dependencies
sudo dnf install -y portaudio-devel python3-devel gcc gcc-c++

# 2. Install Python packages
pip3 install --user pyaudio ggwave-wheels cryptography numpy
```

---

## 🐧 Linux ARM64 (Raspberry Pi 4+, ARM Servers)

**64-bit ARM systems**

### Automatic Installation

```bash
chmod +x install_linux.sh
./install_linux.sh
```

The installer automatically detects ARM64 architecture.

### Manual Installation (Raspberry Pi OS / Debian)

```bash
# 1. Update system
sudo apt-get update
sudo apt-get upgrade

# 2. Install dependencies
sudo apt-get install -y \
    portaudio19-dev \
    python3-pyaudio \
    python3-dev \
    build-essential \
    libatlas-base-dev

# 3. Install Python packages
pip3 install --user ggwave-wheels cryptography numpy

# 4. Test
python3 -c "import pyaudio; print('OK')"
```

### Performance Notes

- ✅ Works well on Raspberry Pi 4/5
- ✅ Native ARM64 compilation
- ⚠️ May be slower than x86_64
- ⚠️ Keep files under 1 MB for best results

---

## 🐧 Linux ARM32 (Raspberry Pi 3/Zero)

**32-bit ARM systems (older Raspberry Pi)**

### Automatic Installation

```bash
chmod +x install_linux.sh
./install_linux.sh
```

### Manual Installation (Raspberry Pi OS)

```bash
# 1. Update system (this may take a while)
sudo apt-get update
sudo apt-get upgrade

# 2. Install dependencies
sudo apt-get install -y \
    portaudio19-dev \
    python3-pyaudio \
    python3-dev \
    build-essential \
    libatlas-base-dev

# 3. Install Python packages (may compile slowly)
pip3 install --user --no-cache-dir ggwave-wheels
pip3 install --user cryptography
pip3 install --user numpy

# 4. Test
python3 -c "import pyaudio; print('OK')"
```

### Important Notes for ARM32

- ⚠️ **Compilation is VERY slow** (30-60 minutes for all packages)
- ⚠️ Use smaller files (< 500 KB recommended)
- ⚠️ Audio processing is slower
- ✅ Everything works, just be patient!

### Optimization Tips

```bash
# Increase swap if needed
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
# Set CONF_SWAPSIZE=1024
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

---

## 🍎 macOS Intel (x86_64)

**Intel-based Macs (pre-2020)**

### Automatic Installation

```bash
chmod +x install_macos.sh
./install_macos.sh
```

### Manual Installation

#### Step 1: Install Homebrew (if not installed)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Step 2: Install Dependencies

```bash
# Install Python and PortAudio
brew install python3 portaudio

# Install Python packages
pip3 install --user pyaudio ggwave-wheels cryptography numpy
```

#### Step 3: Grant Microphone Permission

1. Open **System Settings** → **Privacy & Security**
2. Click **Microphone**
3. Enable access for **Terminal** or **iTerm**

### Troubleshooting macOS Intel

If PyAudio fails to install:

```bash
# Get portaudio path
PORTAUDIO_PATH=$(brew --prefix portaudio)

# Install with flags
CFLAGS="-I$PORTAUDIO_PATH/include" \
LDFLAGS="-L$PORTAUDIO_PATH/lib" \
pip3 install --user --no-cache-dir pyaudio
```

---

## 🍎 macOS Apple Silicon (M1/M2/M3)

**Apple Silicon Macs (2020+)**

### Automatic Installation

```bash
chmod +x install_macos.sh
./install_macos.sh
```

### Manual Installation

#### Step 1: Install Homebrew (ARM version)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Important:** Make sure you're using ARM Homebrew (installed to `/opt/homebrew`)

```bash
# Check Homebrew location
which brew
# Should show: /opt/homebrew/bin/brew
```

#### Step 2: Install Dependencies

```bash
# Install Python and PortAudio
brew install python3 portaudio

# Install Python packages
pip3 install --user pyaudio ggwave-wheels cryptography numpy
```

#### Step 3: Grant Microphone Permission

Same as Intel Macs (see above)

### Apple Silicon Notes

- ✅ **Excellent performance** - faster than Intel Macs
- ✅ Native ARM64 compilation
- ✅ All packages work perfectly
- ✅ Great battery life while using SonarLink

### Rosetta 2 (if needed)

If you encounter issues, you can run with Rosetta 2:

```bash
# Install Rosetta 2 (if not installed)
softwareupdate --install-rosetta

# Run with Rosetta
arch -x86_64 python3 sonarlink.py
```

---

## 🎯 Platform Comparison

| Platform | Difficulty | Speed | Notes |
|----------|-----------|-------|-------|
| **Windows 64-bit** | ⭐ Easy | ⚡⚡⚡ Fast | Recommended |
| **Windows 32-bit** | ⭐⭐ Moderate | ⚡⚡⚡ Fast | Older systems |
| **Linux x86_64** | ⭐ Easy | ⚡⚡⚡ Fast | Recommended |
| **Linux ARM64** | ⭐⭐ Moderate | ⚡⚡ Good | Pi 4+ works well |
| **Linux ARM32** | ⭐⭐⭐ Hard | ⚡ Slow | Pi 3/Zero, be patient |
| **macOS Intel** | ⭐⭐ Moderate | ⚡⚡⚡ Fast | Works great |
| **macOS Apple Silicon** | ⭐ Easy | ⚡⚡⚡⚡ Very Fast | Best performance |

---

## 🔍 How to Detect Your System

### Windows

```cmd
# Check architecture
python -c "import platform; print(platform.machine())"

# Output:
# AMD64 or x86_64 → 64-bit Windows
# x86 or i386 → 32-bit Windows
```

### Linux/macOS

```bash
# Check architecture
uname -m

# Output:
# x86_64 → Intel/AMD 64-bit
# aarch64 or arm64 → ARM 64-bit
# armv7l or armv6l → ARM 32-bit
```

---

## 📦 Package Versions

All platforms install:

| Package | Version | Purpose |
|---------|---------|---------|
| pyaudio | 0.2.14+ | Audio I/O |
| ggwave-wheels | 0.4.2+ | Audio encoding |
| cryptography | 41.0.0+ | Encryption |
| numpy | 1.24.0+ | Numerical ops |

---

## 🐛 Common Installation Issues

### Issue: "pip not found"

```bash
# Fix:
python3 -m ensurepip --upgrade
python3 -m pip install --upgrade pip
```

### Issue: "No module named 'pyaudio'"

**Windows:**
- Download wheel manually from https://github.com/intxcc/pyaudio_portaudio/releases

**Linux:**
```bash
sudo apt-get install python3-pyaudio  # Ubuntu/Debian
sudo pacman -S python-pyaudio          # Arch
```

**macOS:**
```bash
brew install portaudio
pip3 install --user pyaudio
```

### Issue: "Microsoft Visual C++ required" (Windows)

Use the automatic installer - it downloads pre-built wheels that don't need compilation.

### Issue: Compilation fails on ARM32

This is normal! Compilation takes 30-60 minutes on ARM32. Be patient.

```bash
# Check progress
top
# Look for "cc1" or "gcc" processes
```

---

## ✅ Verify Installation

After installation, verify everything works:

```bash
# Test all packages
python3 -c "import pyaudio; print('PyAudio OK')"
python3 -c "import ggwave; print('ggwave OK')"
python3 -c "import cryptography; print('cryptography OK')"
python3 -c "import numpy; print('numpy OK')"

# If all print "OK", you're ready!
python3 sonarlink.py
```

---

## 🎓 Installation Summary

### Choose Your Installer

| Your System | Use This |
|-------------|----------|
| Windows 64-bit (common) | `install_windows.bat` |
| Windows 32-bit (older) | `install_windows_32bit.bat` |
| Linux any architecture | `install_linux.sh` |
| macOS (Intel or M1/M2/M3) | `install_macos.sh` |

### Quick Start

```bash
# 1. Download SonarLink files
# 2. Open terminal in SonarLink folder
# 3. Run installer for your system
# 4. Wait for completion
# 5. Run: python sonarlink.py (or python3 sonarlink.py)
```

---

## 📞 Need Help?

1. Check **TROUBLESHOOTING.md**
2. Verify Python version: `python --version` (should be 3.8+)
3. Verify pip works: `pip --version`
4. Check architecture matches your installer
5. Read error messages carefully

---

## 🎉 Success!

Once installation completes successfully:

```bash
python3 sonarlink.py
```

You should see:

```
=== SonarLink v1.0 ===
1. Send text messages
2. Send files
3. Receive messages or files
4. Decrypt received file
5. Exit
Choice (1-5):
```

**You're ready to use SonarLink!** 🚀

---

*For detailed usage instructions, see README.md and QUICKSTART.md*
