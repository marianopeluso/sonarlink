# 🔐 SonarLink - Security Policy

**Sonarlink - Private file transfer, powered by sound**

## Release Verification

All SonarLink releases are cryptographically signed with GPG to ensure authenticity and integrity.

### How to Verify a Release

#### Step 1: Import the Public Key (First Time Only)

```bash
# Download the public key
curl -O https://github.com/marianopeluso/sonarlink/raw/main/sonarlink-public-key.asc

# Import it into GPG
gpg --import sonarlink-public-key.asc
```

#### Step 2: Download the Release Files

```bash
# Download from GitHub Releases
VERSION="1.0.0"
BASE_URL="https://github.com/marianopeluso/sonarlink/releases/download/v${VERSION}"

# Download archive and signature
curl -LO "${BASE_URL}/sonarlink-v${VERSION}.zip"
curl -LO "${BASE_URL}/sonarlink-v${VERSION}.zip.asc"
curl -LO "${BASE_URL}/sonarlink-v${VERSION}.zip.sha256"
```

#### Step 3: Verify the GPG Signature

```bash
gpg --verify sonarlink-v1.0.0.zip.asc sonarlink-v1.0.0.zip
```

**Expected output:**
```
gpg: Signature made [DATE]
gpg:                using RSA key [KEY_ID]
gpg: Good signature from "Mariano Peluso <mariano@peluso.me>" [unknown]
```

✅ **"Good signature"** means the file is authentic and hasn't been tampered with.

⚠️ The warning `[unknown]` is normal and means you haven't personally verified the key owner's identity. This is acceptable for open-source projects.

#### Step 4: Verify the Checksum

```bash
# Verify SHA-256
sha256sum -c sonarlink-v1.0.0.zip.sha256

# Or manually compare
sha256sum sonarlink-v1.0.0.zip
cat sonarlink-v1.0.0.zip.sha256
```

**Expected output:**
```
sonarlink-v1.0.0.zip: OK
```

### Windows Users

**Install GPG:**
1. Download Gpg4win: https://www.gpg4win.org/download.html
2. Install with default options

**Verify signature:**
```cmd
gpg --verify sonarlink-v1.0.0.zip.asc sonarlink-v1.0.0.zip
```

**Verify checksum (without GPG):**
```cmd
certutil -hashfile sonarlink-v1.0.0.zip SHA256
```
Compare the output with the hash in `sonarlink-v1.0.0.zip.sha256`

---

## Public Key Fingerprint

**Key ID:** `F20494B9FAB53C10`
**Fingerprint:** `0FD97EB855F7C5BB1048D424F20494B9FAB53C10`

The public key is available:
- In this repository: [`sonarlink-public-key.asc`](./sonarlink-public-key.asc)
- On keyservers: `keys.openpgp.org`
- In GitHub Releases

To view the fingerprint:
```bash
gpg --fingerprint mariano@peluso.me
```

---

## Security Best Practices

When using SonarLink:

1. **Verify every release** before installation
2. **Use strong passwords** for encrypted transfers
3. **Keep audio devices secure** during sensitive transfers
4. **Verify recipients** before sending encrypted files
5. **Update regularly** to get security patches

---

## Reporting Security Vulnerabilities

We take security seriously. If you discover a security vulnerability in SonarLink:

### Please DO:
- ✅ Email us privately at: **mariano@peluso.me**
- ✅ Provide detailed steps to reproduce
- ✅ Allow us 90 days to fix before public disclosure
- ✅ Include proof-of-concept code if possible

### Please DO NOT:
- ❌ Open a public GitHub issue
- ❌ Disclose the vulnerability publicly before we've patched it
- ❌ Exploit the vulnerability maliciously

### Response Timeline

- **Initial Response:** Within 48 hours
- **Status Update:** Within 7 days
- **Fix Target:** Within 30-90 days (depending on severity)

### Hall of Fame

We'll acknowledge security researchers who responsibly disclose vulnerabilities:

*No reports yet - be the first!*

---

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | ✅ Active support  |
| < 1.0   | ❌ No longer supported |

---

## Known Security Considerations

### Audio Transmission Security

1. **Physical Security**: Audio transfers can be intercepted by anyone who can hear the transmission. Use encryption for sensitive data.

2. **Encryption Recommendations**:
   - Use **AES-256** for general file encryption
   - Use **RSA-2048** for maximum security
   - Always use unique passwords/passphrases

3. **Room Acoustics**: Be aware of your environment when transmitting sensitive data via audio.

### Dependencies

SonarLink relies on several third-party libraries. We monitor them for vulnerabilities:
- `pyaudio` - Audio I/O
- `ggwave-wheels` - Audio modulation/demodulation
- `cryptography` - Encryption implementation
- `numpy` - Data processing

Run `pip install --upgrade -r requirements.txt` regularly to get security updates.

---

## Cryptographic Details

### Encryption Algorithms

**AES-256-CFB Mode:**
- Key size: 256 bits
- IV: 16 bytes (randomly generated)
- Authentication: HMAC-SHA256

**RSA-OAEP:**
- Key size: 2048 bits
- Padding: OAEP with SHA-256
- Compatible with OpenSSL

### Random Number Generation

SonarLink uses `os.urandom()` for cryptographic random number generation, which is:
- Suitable for cryptographic use
- Platform-specific (e.g., `/dev/urandom` on Linux)
- Non-blocking

---

## Compliance

### Open Source License

SonarLink is released under the MIT License. See [LICENSE](./LICENSE) file for details.

### Export Compliance

This software uses cryptographic functions. Some countries may have restrictions on the import, possession, use, and/or re-export of encryption software. Please check your local laws before using or distributing this software.

---

## Additional Resources

- [Installation Guide](./INSTALLATION_GUIDE.md)
- [Troubleshooting](./TROUBLESHOOTING.md)
- [GPG Documentation](https://www.gnupg.org/documentation/)
- [Python Cryptography Library](https://cryptography.io/)

---

## Updates and Announcements

Security updates will be announced via:
- GitHub Releases
- Repository Security Advisories
- Commit messages with `[SECURITY]` tag

Subscribe to repository notifications to stay informed.

---

**Last Updated:** 2025-10-24

**Questions?** Open an issue or contact us at: mariano@peluso.me
