# 🔧 SonarLink - Troubleshooting Guide

**Sonarlink - Private file transfer, powered by sound**

Complete solutions for common issues on Windows and Linux.

---

## 📑 Table of Contents

- [Windows Issues](#-windows-issues)
- [Linux Issues](#-linux-issues)
- [Audio Problems](#-audio-problems)
- [Transfer Issues](#-transfer-issues)
- [Encryption Issues](#-encryption-issues)
- [General Problems](#-general-problems)

---

## 🪟 Windows Issues

### "python is not recognized as an internal or external command"

**Cause:** Python not in system PATH

**Solution 1 - Reinstall Python (Easiest):**
1. Download Python from https://www.python.org/downloads/
2. Run installer
3. ✅ **CHECK "Add Python to PATH"**
4. Click "Install Now"
5. Restart Command Prompt

**Solution 2 - Add to PATH Manually:**
1. Find Python location (usually `C:\Python311` or `C:\Users\YourName\AppData\Local\Programs\Python\Python311`)
2. Press `Win + R`
3. Type: `rundll32.exe sysdm.cpl,EditEnvironmentVariables`
4. Under "System variables", select "Path"
5. Click "Edit" → "New"
6. Add both paths:
   ```
   C:\Python311
   C:\Python311\Scripts
   ```
7. Click OK on all windows
8. **Restart Command Prompt**

**Verify:**
```cmd
python --version
```

---

### "pip is not recognized"

**Solution:**
```cmd
# Use Python module syntax
python -m pip --version

# Install packages with:
python -m pip install package_name

# Or reinstall pip:
python -m ensurepip --upgrade
python -m pip install --upgrade pip
```

---

### PyAudio Installation Fails

**Error:** `Microsoft Visual C++ 14.0 or greater is required`

**Solution 1 - Use pipwin (Recommended):**
```cmd
pip install pipwin
pipwin install pyaudio
```

**Solution 2 - Download Pre-built Wheel:**
1. Visit: https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyaudio
2. Download correct version:
   - Python 3.11 64-bit: `PyAudio‑0.2.13‑cp311‑cp311‑win_amd64.whl`
   - Python 3.11 32-bit: `PyAudio‑0.2.13‑cp311‑cp311‑win32.whl`
   - Python 3.10 64-bit: `PyAudio‑0.2.13‑cp310‑cp310‑win_amd64.whl`
3. Open Command Prompt in Downloads folder
4. Install:
   ```cmd
   pip install PyAudio-0.2.13-cp311-cp311-win_amd64.whl
   ```

**Solution 3 - Install Build Tools:**
1. Download "Build Tools for Visual Studio" from Microsoft
2. Install "Desktop development with C++"
3. Retry: `pip install pyaudio`

---

### "Access is denied" During Installation

**Solution 1 - User Install:**
```cmd
pip install --user package_name
```

**Solution 2 - Administrator:**
1. Search "cmd" in Start Menu
2. Right-click "Command Prompt"
3. Select "Run as administrator"
4. Run install command

---

### Microphone Permission Issues

**Windows 10/11:**

1. **Settings Method:**
   - Settings → Privacy → Microphone
   - Enable "Allow apps to access your microphone"
   - Scroll down and ensure Python is allowed

2. **Control Panel Method:**
   - Control Panel → Sound
   - Recording tab
   - Right-click microphone → Properties
   - Levels: Set to 80-100%
   - Advanced: Check "Allow applications to take exclusive control"

3. **Grant Permission to Python:**
   - Run sonarlink.py
   - Windows will ask for microphone permission
   - Click "Allow"

---

### Windows Defender Blocks Script

**Solution:**
1. Windows Security → Virus & threat protection
2. Manage settings
3. Add an exclusion
4. Choose folder
5. Select your SonarLink folder
6. Or click "Allow" when warning appears

---

## 🐧 Linux Issues

### "No module named 'pyaudio'"

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install portaudio19-dev python3-pyaudio
pip3 install pyaudio
```

**Arch Linux:**
```bash
sudo pacman -S portaudio python-pyaudio
```

**Fedora/RHEL:**
```bash
sudo dnf install portaudio-devel
pip3 install pyaudio
```

---

### "Permission denied" Errors

**Solution 1 - User Install:**
```bash
pip3 install --user package_name
```

**Solution 2 - Fix pip Permissions:**
```bash
# Check pip installation location
pip3 show pip

# If system-wide, use --user flag
# Or create virtual environment:
python3 -m venv sonarlink_env
source sonarlink_env/bin/activate
pip install pyaudio ggwave-wheels cryptography numpy
```

---

### "gcc: command not found" or Build Errors

**Ubuntu/Debian:**
```bash
sudo apt-get install build-essential python3-dev
```

**Arch Linux:**
```bash
sudo pacman -S base-devel
```

**Fedora:**
```bash
sudo dnf groupinstall "Development Tools"
sudo dnf install python3-devel
```

---

### Audio Device Not Found

**Check Available Devices:**
```bash
# List recording devices
arecord -l

# List playback devices
aplay -l

# Test recording
arecord -d 5 test.wav
aplay test.wav
```

**Install ALSA Utils:**
```bash
sudo apt-get install alsa-utils

# Configure ALSA
alsamixer
```

**Check PulseAudio:**
```bash
# Restart PulseAudio
pulseaudio --kill
pulseaudio --start

# Check status
pactl info
```

---

### Microphone Permission (Linux)

**PulseAudio:**
```bash
# Check microphone is not muted
pactl list sources | grep -i mute

# Unmute if needed
pactl set-source-mute @DEFAULT_SOURCE@ 0

# Set volume
pactl set-source-volume @DEFAULT_SOURCE@ 80%
```

**PipeWire:**
```bash
# Check devices
wpctl status

# Set default microphone
wpctl set-default <device-id>
```

---

### "ImportError: libportaudio.so.2"

**Ubuntu/Debian:**
```bash
sudo apt-get install portaudio19-dev libportaudio2
sudo ldconfig
```

**Arch:**
```bash
sudo pacman -S portaudio
```

---

## 🔊 Audio Problems

### No Audio Detected During Reception

**Checklist:**
- [ ] Microphone is plugged in
- [ ] Microphone permissions granted
- [ ] Microphone not muted in system settings
- [ ] Correct input device selected
- [ ] Speaker volume on sender is 70-80%
- [ ] Devices are 1-2 meters apart
- [ ] Minimal background noise

**Test Microphone:**

**Windows:**
```cmd
# In Sound settings:
# Settings → Sound → Input → Test your microphone
# Speak and verify the bar moves
```

**Linux:**
```bash
# Record test
arecord -d 5 -f cd test.wav
aplay test.wav
```

**In SonarLink:**
1. Start reception mode
2. On sender, choose "Send text messages"
3. Send simple message: "test"
4. If text appears, audio works!

---

### Audio Quality Issues

**Solutions:**

1. **Reduce Background Noise:**
   - Close windows
   - Turn off fans, AC
   - Silence phones
   - Move to quiet room

2. **Optimize Speaker Settings:**
   - Disable audio enhancements
   - Set to "Full Range Speakers"
   - Volume: 70-80% (not max!)
   - Close other audio apps

3. **Optimize Microphone:**
   - Disable noise cancellation
   - Disable echo cancellation
   - Set gain to 80-90%
   - Use external mic if possible

4. **Positioning:**
   - Place devices 1-2 meters apart
   - Point speaker toward microphone
   - Avoid obstacles between devices
   - Same height if possible

---

### Choppy or Distorted Audio

**Cause:** System too slow or audio buffer issues

**Solutions:**

1. **Close Other Programs:**
   ```bash
   # Close web browsers, video players, etc.
   ```

2. **Increase Buffer Size (Advanced):**
   Edit `sonarlink.py`, line 37:
   ```python
   CHUNK_SIZE = 8192  # Was 4096
   ```

3. **Reduce CPU Load:**
   - Close background apps
   - Disable antivirus temporarily
   - Check task manager for high CPU processes

---

## 📁 Transfer Issues

### File Transfer Incomplete

**Symptoms:**
- Transfer stops mid-way
- "bad gzip" error
- Corrupted file saved

**Solutions:**

1. **Increase Timing Delays:**
   Edit `sonarlink.py`:
   ```python
   # Line 204: Between chunks
   time.sleep(1.5)  # Was 1.0
   
   # Line 208: After chunks
   time.sleep(3)    # Was 2
   
   # Line 210: After ENDFILE
   time.sleep(4)    # Was 3
   ```

2. **Improve Environment:**
   - Eliminate all background noise
   - Move devices closer (0.5-1 meter)
   - Use better speakers/microphone
   - Close doors/windows

3. **Reduce File Size:**
   - Compress file before sending
   - Split large files
   - Send in smaller chunks

4. **Use Text Messages First:**
   - Test with "Send text messages"
   - Verify basic audio works
   - Then try small files

---

### "File too large" Error

**Cause:** File exceeds 10 MB limit

**Solutions:**

1. **Compress File:**
   ```bash
   # Create zip
   zip compressed.zip largefile.pdf
   
   # Send compressed.zip instead
   ```

2. **Split File:**
   **Windows:**
   ```cmd
   # Use 7-Zip or WinRAR to split
   ```
   
   **Linux:**
   ```bash
   split -b 9M largefile.bin chunk_
   # Send each chunk_ file separately
   
   # Receiver combines:
   cat chunk_* > largefile.bin
   ```

3. **Increase Limit (Advanced):**
   Edit `sonarlink.py`, line 40:
   ```python
   MAX_FILE_SIZE = 50 * 1024 * 1024  # 50 MB
   ```
   
   **Warning:** Larger files take much longer!

---

### Transfer Takes Too Long

**Expected Times:**
- 100 KB: ~15 minutes
- 1 MB: ~2.5 hours
- 5 MB: ~12.5 hours

**This is normal!** Audio bandwidth is limited.

**To Speed Up:**

1. **Compress Files:**
   ```bash
   zip -9 compressed.zip myfile.pdf
   ```

2. **Reduce Delays (Risky):**
   Edit `sonarlink.py`:
   ```python
   time.sleep(0.7)  # Line 204, was 1.0
   time.sleep(1.5)  # Line 208, was 2
   ```
   
   **Warning:** May cause data loss!

3. **Use Unencrypted Mode:**
   - Slightly faster than encrypted
   - Only if security not required

---

## 🔐 Encryption Issues

### "Wrong password or corrupted file"

**Causes:**
1. Password mismatch
2. File actually corrupted
3. Incomplete transmission

**Solutions:**

1. **Verify Password:**
   - Check exact spelling
   - Check uppercase/lowercase
   - Check special characters
   - No extra spaces
   - Try typing slowly

2. **Check File Size:**
   ```bash
   # Compare sender and receiver file sizes
   ls -lh file.aes
   ```
   
   If different sizes, file didn't transmit completely.

3. **Retry Transmission:**
   - Delete received file
   - Resend from beginning
   - Ensure no interruptions

4. **Check for Corruption:**
   ```bash
   # Look for .corrupted file
   ls *.corrupted
   ```
   
   If exists, original transmission failed.

---

### RSA Decryption Fails

**Errors:**
- "Wrong key"
- "Decryption failed"
- "Invalid key"

**Solutions:**

1. **Verify Key Pair:**
   ```bash
   # Check public key was used for encryption
   openssl rsa -in public_key.pem -pubin -text -noout
   
   # Check private key matches
   openssl rsa -in private_key.pem -text -noout
   ```

2. **Check Key Format:**
   - Must be PEM format
   - Should start with `-----BEGIN`
   - Should end with `-----END`

3. **Private Key Password:**
   ```bash
   # If key is password-protected, provide password
   # Try empty password if you're sure it's not protected
   ```

4. **Regenerate Keys:**
   ```bash
   # Create new key pair
   openssl genrsa -out new_private.pem 2048
   openssl rsa -in new_private.pem -pubout -out new_public.pem
   
   # Use new_public.pem for encryption
   # Use new_private.pem for decryption
   ```

---

### File Won't Decrypt at All

**Check:**

1. **Correct Extension:**
   - `.aes` files need AES password
   - `.rsa` files need RSA private key
   - Don't mix them up!

2. **File Not Corrupted:**
   ```bash
   # Check file size > 0
   ls -lh file.aes
   ```

3. **Complete Transmission:**
   - Ensure ENDFILE was received
   - Check receiver logs for completion message

4. **Try Manual Decrypt (Advanced):**
   ```python
   # Python script to test decryption
   from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
   # ... (see full code in README)
   ```

---

## ⚙️ General Problems

### "ModuleNotFoundError: No module named 'X'"

**Solution:**
```bash
# Install missing module
pip install module_name

# Common modules:
pip install pyaudio          # Audio
pip install ggwave-wheels    # Audio encoding
pip install cryptography     # Encryption
pip install numpy            # Numerical operations
```

---

### Script Crashes Without Error

**Solutions:**

1. **Run in Verbose Mode:**
   ```bash
   python -v sonarlink.py
   ```

2. **Check Python Version:**
   ```bash
   python --version
   # Must be 3.8 or higher
   ```

3. **Update Dependencies:**
   ```bash
   pip install --upgrade pyaudio ggwave-wheels cryptography numpy
   ```

4. **Check System Resources:**
   - Free RAM > 500 MB
   - CPU usage < 80%
   - Disk space available

---

### Can't Cancel Operation

**Solution:**
```
Press Ctrl+C

If doesn't work:
- Press Ctrl+C multiple times
- Wait a few seconds
- Force close terminal if needed
```

---

### Program Freezes

**Causes:**
- Audio device locked
- System overloaded
- Infinite loop

**Solutions:**

1. **Force Quit:**
   **Windows:**
   ```
   Ctrl+C in Command Prompt
   Or: Ctrl+Alt+Del → Task Manager → End Python
   ```
   
   **Linux:**
   ```bash
   Ctrl+C
   # Or:
   ps aux | grep python
   kill <process_id>
   ```

2. **Restart Audio:**
   **Windows:**
   - Restart "Windows Audio" service
   
   **Linux:**
   ```bash
   pulseaudio --kill
   pulseaudio --start
   ```

3. **Reboot:**
   - Last resort: restart computer

---

## 🧪 Testing & Verification

### Test Installation

```bash
# Test Python
python --version

# Test packages
python -c "import pyaudio; print('PyAudio OK')"
python -c "import ggwave; print('ggwave OK')"
python -c "import cryptography; print('Crypto OK')"
python -c "import numpy; print('NumPy OK')"
```

### Test Audio System

**Test 1 - Text Message:**
```bash
# Sender
python sonarlink.py
# 1 → Send text
# Message: hello

# Receiver (same computer, different terminal)
python sonarlink.py
# 3 → Receive
# Should see: "Message: hello"
```

**Test 2 - Small File:**
```bash
# Create test file
echo "This is a test" > test.txt

# Send
# 2 → 1 → test.txt

# Receive
# Should get test.txt
```

---

## 📞 Getting More Help

### Before Asking for Help

1. ✅ Check this troubleshooting guide
2. ✅ Read full README.md
3. ✅ Test with text messages first
4. ✅ Verify all dependencies installed
5. ✅ Check Python version ≥ 3.8
6. ✅ Test audio devices separately

### Information to Provide

When seeking help, include:
- Operating system & version
- Python version (`python --version`)
- Error message (full text)
- Steps to reproduce
- What you've tried
- Output of: `pip list | grep -E "pyaudio|ggwave|crypt"`

---

## 🔄 Reset & Clean Install

### Windows

```cmd
# Uninstall packages
pip uninstall pyaudio ggwave-wheels cryptography numpy -y

# Clear pip cache
pip cache purge

# Reinstall
pip install pipwin
pipwin install pyaudio
pip install ggwave-wheels cryptography numpy
```

### Linux

```bash
# Remove packages
pip3 uninstall pyaudio ggwave-wheels cryptography numpy -y

# Remove system packages (Ubuntu)
sudo apt-get remove --purge python3-pyaudio portaudio19-dev

# Reinstall
sudo apt-get install portaudio19-dev python3-pyaudio
pip3 install ggwave-wheels cryptography numpy
```

---

## ✅ Checklist

Before reporting an issue, verify:

- [ ] Python 3.8+ installed
- [ ] All dependencies installed
- [ ] Audio devices working
- [ ] Microphone permissions granted
- [ ] No background noise
- [ ] Devices 1-2 meters apart
- [ ] Text messages work
- [ ] Tried with small file first
- [ ] Read this guide completely
- [ ] Read README.md

---

**Still Having Issues?**

Check README.md for:
- Detailed installation instructions
- Usage examples
- Technical specifications
- FAQ section

---

*SonarLink v1.0 - Troubleshooting Guide*
