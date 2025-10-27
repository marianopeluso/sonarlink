# 🔊 SonarLink v1.0

**Sonarlink - Private file transfer, powered by sound**

Transfer files and messages between computers using sound waves. No network required!

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey)](https://github.com/marianopeluso/sonarlink)

---

## 📋 Table of Contents

- [What Makes SonarLink Unique](#-what-makes-sonarlink-unique)
- [Features](#-features)
- [Quick Start](#-quick-start)
- [Installation](#-installation)
- [Usage Guide](#-usage-guide)
- [Use Cases](#-use-cases)
- [Technical Details](#-technical-details)
- [Documentation](#-documentation)
- [Security](#-security)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 What Makes SonarLink Unique

**SonarLink is the first production-ready system to transfer encrypted files up to 10MB purely through sound waves, with no network connection required.**

### The Problem We Solved

In June 2021, a user opened [Issue #41](https://github.com/ggerganov/ggwave/issues/41) on the ggwave repository requesting:

> "The possibility of sending files purely over sound, without any additional type of connection. This could be beneficial in environment without any internet connection and for secure transfer of private data."

**Three years later, SonarLink is the answer to this request.**

### How SonarLink Differs

| Feature | SonarLink | wave-share | Waver | Other Projects |
|---------|-----------|------------|-------|----------------|
| **Pure Audio Transfer** | ✅ Yes | ❌ WebRTC | ❌ TCP | ❌ Various |
| **No Network Required** | ✅ Air-gapped | ❌ Needs LAN | ❌ Network | Varies |
| **File Size Support** | ✅ Up to 10MB | ✅ Large* | ✅ Large* | Limited |
| **AES-256 Encryption** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **RSA-2048 Encryption** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **GZIP Compression** | ✅ Automatic | ❌ No | ❌ No | ❌ No |
| **Cross-platform CLI** | ✅ Win/Lin/Mac | ⚠️ Web | ⚠️ GUI | Varies |

*Other projects transfer large files via network (TCP/WebRTC), not pure audio

---

## ✨ Features

### Core Capabilities
- **🎵 Audio-Based Transfer**: Transmit files through sound at 48kHz
- **🔐 Multiple Encryption Options**:
  - No encryption (fast mode)
  - AES-256-CFB with HMAC authentication
  - RSA-2048-OAEP encryption
- **📦 Automatic GZIP Compression**: Reduces transfer time
- **💬 Text Messages**: Send short text messages via audio
- **📁 Multiple File Support**: Send multiple files in unencrypted mode
- **✅ Error Detection**: HMAC verification for encrypted files
- **🔄 File Recovery**: Save corrupted files for debugging
- **📊 Maximum File Size**: 10 MB per file (configurable)

### Technical Innovation
- **Chunking Protocol**: Intelligent data splitting into 120-byte chunks
- **Multi-Layer Encoding**: Base64 → GZIP → Encryption → Audio
- **Error Recovery**: Corrupted file saving and integrity verification
- **Adaptive Delays**: Configurable timing between chunks
- **Crypto Integration**: Seamless encryption layer
- **Format Preservation**: Original file format maintained

---

## 🚀 Quick Start

### Prerequisites
- Python 3.8 or higher
- Working microphone and speakers
- 100 MB free disk space

### Installation (Choose Your Platform)

**Windows:**
```cmd
# Download and run the installer
installers\install_windows.bat
```

**Linux:**
```bash
# Make installer executable and run
chmod +x installers/install_linux.sh
./installers/install_linux.sh
```

**macOS:**
```bash
# Make installer executable and run
chmod +x installers/install_macos.sh
./installers/install_macos.sh
```

### First Transfer

```bash
# 1. Run SonarLink
python sonarlink.py

# 2. Choose an option:
#    1. Send text messages
#    2. Send files
#    3. Receive messages or files
#    4. Decrypt received file
#    5. Exit

# 3. Follow the prompts!
```

**Pro Tip**: Start with option 1 (text messages) to verify your audio setup works correctly.

---

## 💻 Installation

### System Requirements

**Minimum:**
- Python 3.8+
- 512 MB RAM
- 100 MB disk space
- Working microphone and speakers

**Recommended:**
- Python 3.10+
- 2 GB RAM
- Modern OS (Windows 10+, Ubuntu 20.04+, macOS 10.15+)
- Quality audio devices
- Quiet environment

### Supported Platforms

- ✅ Windows 10/11 (64-bit, 32-bit)
- ✅ Linux x86_64 (Ubuntu, Debian, Arch, Fedora, Mint)
- ✅ Linux ARM64 (Raspberry Pi 4+)
- ✅ Linux ARM32 (Raspberry Pi 3/Zero)
- ✅ macOS Intel
- ✅ macOS Apple Silicon (M1/M2/M3)

### Platform-Specific Guides

For detailed installation instructions for your platform, see:
- **[docs/INSTALLATION.md](docs/INSTALLATION.md)** - Complete installation guide for all platforms
- **[docs/QUICKSTART.md](docs/QUICKSTART.md)** - Get running in 5 minutes
- **[docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Solve installation issues

### Manual Installation

If the automated installers don't work:

```bash
# Install dependencies
pip install pyaudio ggwave-wheels cryptography numpy

# Run SonarLink
python sonarlink.py
```

**Note**: PyAudio installation on Windows with Python 3.13+ requires special handling. See our [Installation Guide](docs/INSTALLATION.md) for details.

---

## 📖 Usage Guide

### Command Reference

#### 1. Send Text Messages
```bash
python sonarlink.py
# Select: 1
# Type your message (press Enter twice to send)
```

#### 2. Send Files

**Unencrypted (Fast):**
```bash
python sonarlink.py
# Select: 2 → 1
# Enter filename: photo.jpg
```

**AES Encrypted:**
```bash
python sonarlink.py
# Select: 2 → 2
# Enter filename: document.pdf
# Enter password: YourSecurePassword123!
```

**RSA Encrypted:**
```bash
python sonarlink.py
# Select: 2 → 3
# Enter filename: secret.txt
# Enter public key path: recipient_public.pem
```

#### 3. Receive Files
```bash
python sonarlink.py
# Select: 3
# Position microphone near sender's speaker
# Files are saved automatically
```

#### 4. Decrypt Received File
```bash
python sonarlink.py
# Select: 4
# Enter encrypted filename: document.pdf.aes
# Enter password: YourSecurePassword123!
```

### Best Practices

**For Optimal Results:**
- Keep devices 1-2 meters apart
- Use quiet environment (< 40 dB background noise)
- Set speaker volume to 70-80%
- Set microphone gain to 80-90%
- Disable audio enhancements
- Test with text messages first

**Performance Tips:**
- Start with small files (< 100 KB)
- Use unencrypted mode for speed
- Compress files before sending
- Avoid interruptions during transfer

---

## 🎯 Use Cases

### 1. Air-Gapped Systems
Transfer files between isolated computers with no network access - perfect for high-security environments.

### 2. Network-Restricted Areas
Hospitals, secure facilities, or areas with no WiFi/Bluetooth where traditional file sharing is impossible.

### 3. Emergency Situations
Backup transfer method when network infrastructure is down but devices still have power.

### 4. Privacy-Conscious Users
No data passes through any network or cloud service - complete offline operation.

### 5. Business Intelligence
Secure exchange of confidential market research data at conferences without network traces.

### 6. IoT & Embedded Systems
Simple speaker/microphone setup, no complex network stack needed.

### 7. Educational & Research
Demonstrate data transmission principles and encryption using sound waves.

### 8. Offline File Sharing
Share files in remote locations without WiFi, cellular data, or physical media.

---

## 🔧 Technical Details

### Audio Specifications

| Parameter | Value |
|-----------|-------|
| Sample Rate | 48000 Hz |
| Chunk Size | 4096 samples |
| Volume | 80 (0-100 scale) |
| Protocol | GGWAVE_AUDIBLE_FAST |
| Max Bytes/Chunk | 120 bytes |

### Performance

| File Size | Chunks | Approx Time |
|-----------|--------|-------------|
| 100 KB | ~900 | 15 minutes |
| 500 KB | ~4500 | 75 minutes |
| 1 MB | ~9000 | 2.5 hours |
| 5 MB | ~45000 | 12.5 hours |

### Encryption Specifications

**AES-256-CFB:**
- Key: 32 bytes (derived from password via PBKDF2)
- IV: 16 bytes (random)
- HMAC: SHA-256 for authentication
- Format: MAC(32) + IV(16) + Ciphertext

**RSA-2048-OAEP:**
- Key size: 2048 bits
- Padding: OAEP with MGF1-SHA256
- Direct encryption (no hybrid mode for simplicity)

### Data Processing Pipeline

```
Original File
    ↓
GZIP Compression (automatic)
    ↓
Encryption (optional: AES/RSA/None)
    ↓
Base64 Encoding
    ↓
120-byte Chunks
    ↓
Audio Transmission (ggwave)
    ↓
Base64 Decoding
    ↓
Reassembly
    ↓
Decryption (if encrypted)
    ↓
GZIP Decompression
    ↓
Original File Restored
```

---

## 📚 Documentation

### Included Documentation

- **[README.md](README.md)** (this file) - Overview and quick reference
- **[docs/INSTALLATION.md](docs/INSTALLATION.md)** - Detailed installation for all platforms
- **[docs/QUICKSTART.md](docs/QUICKSTART.md)** - 5-minute getting started guide
- **[docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Common problems and solutions
- **[docs/SECURITY.md](docs/SECURITY.md)** - Security considerations
- **[docs/ATTRIBUTIONS.md](docs/ATTRIBUTIONS.md)** - Credits and licenses

### Installation Scripts

- **[installers/install_windows.bat](installers/install_windows.bat)** - Windows 64-bit installer
- **[installers/install_windows_32bit.bat](installers/install_windows_32bit.bat)** - Windows 32-bit installer
- **[installers/install_windows_manual.bat](installers/install_windows_manual.bat)** - Windows manual installer
- **[installers/install_linux.sh](installers/install_linux.sh)** - Linux installer (all architectures)
- **[installers/install_macos.sh](installers/install_macos.sh)** - macOS installer (Intel & Apple Silicon)

---

## 🔒 Security

### Security Features

- **AES-256**: Military-grade symmetric encryption
- **RSA-2048**: Strong asymmetric encryption
- **HMAC-SHA256**: Authenticated encryption prevents tampering
- **Random IV**: Prevents pattern analysis
- **No Network**: No network traces or cloud storage

### Best Practices

1. **Use strong passwords** (20+ characters, mix of letters, numbers, symbols)
2. **Never reuse passwords** between different files or recipients
3. **Share passwords through secure channels** (never via audio or unencrypted means)
4. **Protect RSA private keys** like you would protect passwords
5. **Generate new keys regularly** for sensitive operations
6. **Use encryption for sensitive data** even in private spaces
7. **Be aware**: Audio transmissions can be physically recorded

### Privacy Considerations

- ✅ No network traces (major advantage)
- ✅ No logs kept (unless you enable logging)
- ⚠️ Audio transmissions can be recorded in the physical space
- ⚠️ Use in private spaces for sensitive transfers
- ⚠️ Consider physical security of the environment

For detailed security information, see [docs/SECURITY.md](docs/SECURITY.md)

---

## 🤝 Contributing

SonarLink is inspired by community needs and welcomes contributions!

### How to Contribute

1. **Report Issues**: Found a bug? Open an issue on GitHub
2. **Suggest Features**: Have an idea? We'd love to hear it
3. **Submit Pull Requests**: Code contributions welcome
4. **Improve Documentation**: Help make our docs better
5. **Share Use Cases**: Tell us how you're using SonarLink

### Future Development

Inspired by community feedback, we're exploring:
- Larger file support (chunked transfer resume)
- Additional encryption algorithms
- Mobile applications (iOS/Android)
- GUI interface option
- Ultrasound mode for higher speeds
- Bidirectional transfer protocol

---

## 🙏 Credits

### Built With

- **[ggwave](https://github.com/ggerganov/ggwave)** by Georgi Gerganov - The amazing data-over-sound library
- **[PyAudio](https://people.csail.mit.edu/hubert/pyaudio/)** - Python audio bindings
- **[cryptography](https://cryptography.io/)** by PyCA - Modern cryptography library
- **[NumPy](https://numpy.org/)** - Numerical computing library

### Inspiration

- ggwave Issue #41 and community discussions
- Air-gapped system file transfer needs
- Privacy-conscious users seeking offline solutions
- Business intelligence professionals needing secure data exchange

**Standing on the shoulders of giants** - SonarLink takes ggwave's raw capability and builds a complete, production-ready file transfer solution on top of it.

---

## 📄 License

SonarLink is released under the MIT License. See [LICENSE](LICENSE) file for details.

### Dependencies Licenses

- ggwave: MIT License
- PyAudio: MIT License
- cryptography: Apache 2.0 / BSD License
- numpy: BSD License

---

## 📞 Support

### Getting Help

1. **Documentation**: Start with [docs/QUICKSTART.md](docs/QUICKSTART.md)
2. **Troubleshooting**: Check [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
3. **Installation Issues**: See [docs/INSTALLATION.md](docs/INSTALLATION.md)
4. **Security Questions**: Read [docs/SECURITY.md](docs/SECURITY.md)

### Self-Help Checklist

- [ ] Read the relevant documentation
- [ ] Verify Python version (3.8+)
- [ ] Check audio devices are working
- [ ] Test with text messages first
- [ ] Try in a quiet environment
- [ ] Review error messages carefully

---

## ⚠️ Known Limitations

1. **Speed**: Very slow compared to network transfer (this is physics, not a bug!)
2. **Distance**: Limited to ~3 meters maximum
3. **Environment**: Requires quiet space for reliable transmission
4. **File Size**: 10 MB maximum (configurable but slow)
5. **Reliability**: Affected by background noise and audio quality
6. **Hardware**: Depends on microphone/speaker quality
7. **Single Transfer**: One file at a time in encrypted mode

---

## 🎯 Quick Command Reference

| Task | Command Flow |
|------|--------------|
| **Text Message** | `python sonarlink.py` → 1 → type message → Enter twice |
| **Send File** | `python sonarlink.py` → 2 → 1 → filename |
| **Send Encrypted** | `python sonarlink.py` → 2 → 2 → filename → password |
| **Receive** | `python sonarlink.py` → 3 |
| **Decrypt** | `python sonarlink.py` → 4 → encrypted file → password |

---

## 🌟 Key Advantages

1. ✅ **No Network Required** - Works completely offline
2. ✅ **Air-Gap Compatible** - Transfer to isolated systems
3. ✅ **Encrypted Options** - Secure sensitive data
4. ✅ **Cross-Platform** - Windows, Linux, macOS support
5. ✅ **Well-Documented** - Comprehensive guides included
6. ✅ **Easy Installation** - Automated scripts for all platforms
7. ✅ **Open Source** - Based on trusted open-source libraries
8. ✅ **Privacy-Focused** - No cloud, no network traces

---

## 📊 Version History

### v1.0 (October 2025)
- Initial release
- AES-256-CFB encryption with HMAC
- RSA-2048-OAEP encryption
- Text message support
- Multiple file transfer (unencrypted mode)
- Error recovery system
- Comprehensive documentation
- Cross-platform installers (Windows, Linux, macOS)
- Support for 7 platform architectures

---

## 🚀 Getting Started

Ready to transfer files through sound?

1. **Choose your platform** and run the appropriate installer
2. **Read** [docs/QUICKSTART.md](docs/QUICKSTART.md) (5 minutes)
3. **Test** with a text message
4. **Try** a small file transfer
5. **Explore** encryption options

---

**SonarLink v1.0 - Transform Files into Sound Waves!** 🔊📁→🎵

*Built with ❤️ using [ggwave](https://github.com/ggerganov/ggwave) - Solving real problems with sound waves since 2025*

---

For detailed information, see our comprehensive documentation in the `docs/` folder.
