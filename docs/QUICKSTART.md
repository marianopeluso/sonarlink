# 🚀 SonarLink - Quick Start Guide

**Sonarlink - Private file transfer, powered by sound**

Get up and running in 5 minutes!

---

## ⚡ Installation

### Windows

#### **Step 1: Install Python 3.13**

1. **Download Python**
   - Go to: **https://www.python.org/downloads/**
   - Click **"Download Python 3.13.x"**

2. **Run the Installer**
   - **FIRST SCREEN:** Check ☑ **"Add python.exe to PATH"** (at the bottom)
   - Click **"Customize installation"** (or "Install Now" if you checked PATH box)
   
3. **Optional Features Screen:** (if you chose Customize)
   - Keep all boxes checked (Documentation, pip, tcl/tk, IDLE, py launcher)
   - Click **"Next"**

4. **Advanced Options Screen:** (if you chose Customize)
   - Verify ☑ **"Add Python to environment variables"** is checked
   - Click **"Install"**

5. **Wait & Complete**
   - Wait 2-3 minutes for installation
   - Click **"Close"** when done
   - **Close all Command Prompt windows**
   - Open a **NEW** Command Prompt

6. **Verify Installation**
   ```cmd
   python --version
   ```
   Should show: `Python 3.13.7`

#### **Step 2: Install SonarLink**

```cmd
# Navigate to SonarLink folder
cd C:\SonarLink

# Run automated installer
install_windows.bat
```

Or install manually:
```cmd
pip install pipwin
pipwin install pyaudio
pip install ggwave-wheels cryptography numpy
```

#### **Step 3: Run SonarLink**

```cmd
python sonarlink.py
```

---

### Linux

```bash
# Run the installer
chmod +x install_linux.sh
./install_linux.sh

# Or manually:
sudo apt-get install portaudio19-dev python3-pyaudio  # Ubuntu/Debian
pip3 install ggwave-wheels cryptography numpy
```

---

## 🎯 First Transfer (No Encryption)

### Computer A (Sender)

```bash
python sonarlink.py

# Menu appears:
# Choose: 2 (Send files)
# Choose: 1 (Unencrypted)
# Enter: test.txt
```

### Computer B (Receiver)

```bash
python sonarlink.py

# Choose: 3 (Receive)
# Place microphone near Computer A's speakers
# File automatically saves!
```

---

## 🔐 Secure Transfer (AES Encryption)

### Both Computers

**IMPORTANT:** Agree on password first!  
Example: `MySecurePass2024!`

### Sender

```bash
python sonarlink.py

# 2 → 2 (Send → AES)
# File: document.pdf
# Password: MySecurePass2024!
# Send: y
```

### Receiver

```bash
python sonarlink.py

# 3 (Receive)
# Receives: document.pdf.aes

# Then decrypt:
# 4 (Decrypt)
# File: document.pdf.aes
# Password: MySecurePass2024!
# Result: document.pdf_dec.bin
```

---

## 📋 Menu Options

```
1. Send text messages       → Send short text via audio
2. Send files              → Send files (encrypted/unencrypted)
3. Receive                 → Listen for incoming data
4. Decrypt file            → Decrypt .aes or .rsa files
5. Exit                    → Close program
```

---

## 💡 Pro Tips

### ✅ DO:
- Start with small files (< 1 MB)
- Use quiet environment
- Keep devices 1-2 meters apart
- Speaker volume: 70-80%
- Test with text messages first

### ❌ DON'T:
- Interrupt during transmission
- Use in noisy places
- Place devices too far apart
- Use very large files initially

---

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| "python is not recognized" | Reinstall Python, CHECK "Add python.exe to PATH" |
| No audio detected | Increase volume, reduce noise |
| PyAudio won't install | Use pipwin: `pip install pipwin && pipwin install pyaudio` |
| Decryption fails | Check password matches exactly |
| Transfer incomplete | Reduce background noise, retry |

---

## ⏱️ Transfer Times

| File Size | Approximate Time |
|-----------|------------------|
| 100 KB    | ~15 minutes     |
| 500 KB    | ~75 minutes     |
| 1 MB      | ~2.5 hours      |
| 5 MB      | ~12.5 hours     |

*Based on 120 bytes/second with 1-second delays*

---

## 🎬 Complete Example

### Scenario: Send encrypted document

**Preparation:**
```bash
# Both computers install SonarLink
# Both agree on password: "Coffee2024Research!"
```

**Sender:**
```bash
python sonarlink.py
# 2 → 2
# File: Q4_report.pdf
# Password: Coffee2024Research!
# Send: y
# *Sound plays from speakers*
```

**Receiver:**
```bash
python sonarlink.py
# 3
# *Microphone listens*
# Receives: Q4_report.pdf.aes

# 4
# File: Q4_report.pdf.aes
# Password: Coffee2024Research!
# Result: Q4_report.pdf_dec.bin
```

**Done!** Rename `Q4_report.pdf_dec.bin` to `Q4_report.pdf`

---

## 📱 Audio Setup

### Sender Device
1. Check speaker output device is correct
2. Set volume to 70-80%
3. Disable audio enhancements
4. Close other audio apps

### Receiver Device
1. Check microphone input device
2. Grant microphone permissions
3. Disable noise cancellation
4. Close other apps using microphone

---

## 🔑 Password Tips

### Good Passwords:
- ✅ `MySecure#Pass2024!`
- ✅ `Coffee_Research_2024`
- ✅ `Tr@nsfer$ecure123`

### Bad Passwords:
- ❌ `password`
- ❌ `12345678`
- ❌ `coffee`

**Length:** 16-32 characters recommended

---

## 🆘 Need Help?

1. **Read full documentation:** `README.md`
2. **Check troubleshooting section**
3. **Test with text messages first**
4. **Verify audio devices work**
5. **Start with unencrypted small files**

---

## 📚 Learn More

- **Full documentation:** See `README.md`
- **Installation help:** See installation scripts
- **Technical details:** See `README.md` Technical Section

---

## ✨ Features Summary

✅ Audio-based file transfer  
✅ No network required  
✅ AES-256 & RSA-2048 encryption  
✅ Automatic GZIP compression  
✅ Text message support  
✅ Multiple file transfers  
✅ Error detection & recovery  

---

---

## ⚠️ Critical Installation Note (Windows)

**The most common mistake:** Forgetting to check the PATH box!

```
Python Installer - FIRST SCREEN:
─────────────────────────────────
         [Install Now]
         [Customize installation]

☐ Use admin privileges...
☑ Add python.exe to PATH  ← CHECK THIS BOX!
   ↑
CRITICAL!
```

**Python 3.13 Alternative:**
If you choose "Customize installation", on the **Advanced Options** screen, verify:
```
☑ Add Python to environment variables  ← Must be checked!
```

---

## 🔍 Python 3.13 Users: Visual Installation Guide

```
STEP 1: First Screen
────────────────────
☑ Add python.exe to PATH  ← Check this!
Click [Install Now] or [Customize installation]

STEP 2a: If you clicked "Customize" - Optional Features
────────────────────────────────────────────────────────
☑ Documentation
☑ pip              ← Keep checked!
☑ tcl/tk and IDLE
☑ Python test suite
☑ py launcher
Click [Next]

STEP 2b: Advanced Options
─────────────────────────
☑ Add Python to environment variables  ← Verify checked!
Click [Install]

STEP 3: Complete
────────────────
Wait for installation → Click [Close]
Close all Command Prompts → Open NEW one
Test: python --version
```

---

**That's it! You're ready to use SonarLink!** 🎉

For detailed information, refer to the full `README.md`

---

*SonarLink v1.0 - Transform files into sound waves!* 🔊📁
