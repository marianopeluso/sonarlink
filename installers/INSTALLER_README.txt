===========================================
   SonarLink v1.0 - Installer Selection
===========================================

Sonarlink - Private file transfer, powered by sound

Choose the correct installer for your system:

┌────────────────────────────────────────────┐
│  WINDOWS USERS                             │
├────────────────────────────────────────────┤
│                                            │
│  Most Common (64-bit):                     │
│  → install_windows.bat                     │
│     ✓ Windows 10/11 64-bit                 │
│     ✓ Python 3.8-3.13                      │
│     ✓ Automatic PyAudio download           │
│                                            │
│  Older Systems (32-bit):                   │
│  → install_windows_32bit.bat               │
│     ✓ Windows 7/8/10 32-bit                │
│     ✓ Python 3.8-3.13                      │
│     ✓ Automatic PyAudio download           │
│                                            │
│  Manual Installation:                      │
│  → install_windows_manual.bat              │
│     ✓ Use if automatic fails               │
│     ✓ Guided step-by-step process          │
│     ✓ All Windows versions                 │
│                                            │
└────────────────────────────────────────────┘

┌────────────────────────────────────────────┐
│  LINUX USERS                               │
├────────────────────────────────────────────┤
│                                            │
│  All Linux Distributions:                  │
│  → install_linux.sh                        │
│     ✓ Auto-detects architecture            │
│     ✓ Ubuntu, Debian, Arch, Fedora, Mint   │
│     ✓ x86_64, ARM64, ARM32 (Pi)            │
│     ✓ Installs system dependencies         │
│                                            │
│  Usage:                                    │
│     chmod +x install_linux.sh              │
│     ./install_linux.sh                     │
│                                            │
└────────────────────────────────────────────┘

┌────────────────────────────────────────────┐
│  MACOS USERS                               │
├────────────────────────────────────────────┤
│                                            │
│  All macOS Versions:                       │
│  → install_macos.sh                        │
│     ✓ Auto-detects Intel vs Apple Silicon │
│     ✓ macOS 10.15+ (Catalina and newer)    │
│     ✓ M1/M2/M3 Apple Silicon               │
│     ✓ Installs via Homebrew                │
│                                            │
│  Usage:                                    │
│     chmod +x install_macos.sh              │
│     ./install_macos.sh                     │
│                                            │
└────────────────────────────────────────────┘

===========================================
   HOW TO CHECK YOUR SYSTEM
===========================================

Windows - Check if 32-bit or 64-bit:
  1. Open Command Prompt
  2. Type: python -c "import platform; print(platform.machine())"
  3. Result:
     - AMD64 or x86_64 → Use install_windows.bat
     - x86 or i386 → Use install_windows_32bit.bat

Linux - Check architecture:
  1. Open Terminal
  2. Type: uname -m
  3. Result:
     - x86_64 → Standard PC/Laptop
     - aarch64 → ARM 64-bit (Raspberry Pi 4+)
     - armv7l → ARM 32-bit (Raspberry Pi 3/Zero)

macOS - Check processor:
  1. Click Apple menu → About This Mac
  2. Look for:
     - "Chip: Apple M1/M2/M3" → Apple Silicon
     - "Processor: Intel" → Intel Mac

===========================================
   PYTHON 3.13+ USERS (IMPORTANT!)
===========================================

If you have Python 3.13 or newer:

Windows:
  - Use install_windows.bat (automatic)
  - OR install_windows_manual.bat (guided)
  
  PyAudio requires pre-built wheels for Python 3.13
  The installers handle this automatically!

Linux/macOS:
  - Use normal installer
  - PyAudio compiles from source (may take time)

===========================================
   TROUBLESHOOTING
===========================================

Installer Fails:
  1. Check Python is installed: python --version
  2. Check Python is in PATH
  3. Try manual installer (Windows)
  4. See: ../docs/TROUBLESHOOTING.md

PyAudio Installation Error:
  Windows: Use install_windows_manual.bat
  Linux: Install system packages first
  macOS: Install Homebrew first

Permission Denied (Linux/macOS):
  chmod +x install_linux.sh
  chmod +x install_macos.sh

===========================================
   AFTER INSTALLATION
===========================================

1. Verify Installation:
   python -c "import pyaudio; print('OK')"
   python -c "import ggwave; print('OK')"

2. Run SonarLink:
   python sonarlink.py

3. Test with Text Message:
   Choose option 1
   Send a test message

4. Read Documentation:
   - ../docs/QUICKSTART.md (5 minutes)
   - ../docs/INSTALLATION.md (detailed)
   - ../README.md (complete guide)

===========================================
   NEED HELP?
===========================================

1. Read: ../docs/TROUBLESHOOTING.md
2. Check: ../docs/INSTALLATION.md
3. Review: README.md

===========================================

Version: 1.0
Last Updated: October 2025

===========================================
