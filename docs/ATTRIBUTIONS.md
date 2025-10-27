# 📜 SonarLink - Attributions and Licenses

**Sonarlink - Private file transfer, powered by sound**

## Core Technology

### ggwave
**SonarLink is built upon ggwave - Audio Data Transmission Library**

- **Author:** Georgi Gerganov ([@ggerganov](https://github.com/ggerganov))
- **Repository:** https://github.com/ggerganov/ggwave
- **License:** MIT License
- **Copyright:** Copyright (c) 2020-2024 Georgi Gerganov

**Description:**
ggwave is a C++ library that allows data transmission over sound waves. It encodes and decodes binary data into/from audio waveforms, enabling applications to transfer information through speakers and microphones.

**Reference Implementation:**
This project was inspired by the ggwave-js example:
https://github.com/ggerganov/ggwave/tree/master/examples/ggwave-js

**Community Request:**
SonarLink implements the feature requested in ggwave Issue #41 (June 2021):
"Sending files purely via sound" - https://github.com/ggerganov/ggwave/issues/41

**ggwave MIT License:**
```
MIT License

Copyright (c) 2020-2024 Georgi Gerganov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Relationship to Other ggwave Projects

SonarLink implements a long-requested feature from the ggwave community: **pure audio-based file transfer without network connections**. While other projects in the ggwave ecosystem use sound for different purposes, SonarLink is unique in transferring files entirely through audio.

### Related Projects (For Reference)

**Official ggwave Projects:**

1. **wave-share** - WebRTC File Sharing with Audio Signaling
   - Repository: https://github.com/ggerganov/wave-share
   - Author: Georgi Gerganov
   - Purpose: Uses sound **only for signaling** to establish WebRTC connection
   - File Transfer: Via WebRTC/TCP over network
   - Difference: SonarLink transfers files **entirely through sound**, no network needed

2. **Waver** - Official GUI Application
   - Website: https://waver.ggerganov.com
   - Author: Georgi Gerganov
   - Purpose: Send/receive short messages via sound
   - Limitation: 140-character messages, uses TCP for file transfers
   - Difference: SonarLink supports up to 10MB files via pure audio with encryption

**Community Projects:**

3. **data_over_sound** - Python Text Messaging GUI
   - Repository: https://github.com/denizsincar29/data_over_sound
   - Author: denizsincar29
   - Purpose: GUI for text messages via sound
   - Status: File transfer feature was removed and not reimplemented
   - Difference: SonarLink has complete file transfer functionality

4. **ggwave-fm** - Radio Transmission
   - Repository: https://github.com/rgerganov/ggwave-fm
   - Author: rgerganov
   - Purpose: Transmit ggwave messages via SDR/radio frequencies
   - Difference: Extended range transmission vs local audio

5. **ggwave-python** - Python Wrapper
   - Repository: https://github.com/Abzac/ggwave-python
   - Author: Abzac
   - Purpose: Alternative Python bindings for ggwave
   - Difference: Low-level library vs complete application

### What SonarLink Adds

SonarLink is the **first complete implementation** that addresses the community request for pure audio file transfer:

- ✅ **Pure Audio Transfer**: No network, no TCP, no WebRTC - just sound
- ✅ **Large File Support**: Up to 10MB with chunking protocol
- ✅ **Encryption**: AES-256 and RSA-2048 encryption options
- ✅ **Compression**: Automatic GZIP compression
- ✅ **Error Detection**: HMAC verification and corrupt file recovery
- ✅ **Multiple Files**: Batch transfer support
- ✅ **Production Ready**: Cross-platform installers, comprehensive docs
- ✅ **User Friendly**: Interactive CLI with clear prompts

**Key Quote from Issue #41:**
> "This project is exactly what I was looking for except the limitation for message length and the transfer of files. I suggest the possibility of sending files purely over sound, without any additional type of connection."

**SonarLink is the answer to this 3-year-old request.**

---

## Python Dependencies

### PyAudio
- **Purpose:** Cross-platform audio I/O
- **Repository:** https://people.csail.mit.edu/hubert/pyaudio/
- **License:** MIT License
- **Usage:** Provides Python bindings for PortAudio, enabling microphone input and speaker output

### cryptography
- **Purpose:** Cryptographic recipes and primitives
- **Repository:** https://github.com/pyca/cryptography
- **License:** Apache License 2.0 or BSD License (dual-licensed)
- **Usage:** Implements AES-256 and RSA-2048 encryption for secure file transfers

### numpy
- **Purpose:** Fundamental package for scientific computing
- **Repository:** https://github.com/numpy/numpy
- **License:** BSD License
- **Usage:** Array operations and numerical computations for audio data processing

### ggwave-wheels
- **Purpose:** Python bindings for ggwave
- **Repository:** https://pypi.org/project/ggwave-wheels/
- **License:** MIT License
- **Usage:** Provides the Python interface to the ggwave C++ library

---

## Acknowledgments

### Primary Attribution
**This project would not exist without ggwave.** The core functionality of encoding binary data into audio waveforms and decoding audio back into data is entirely provided by the ggwave library created by Georgi Gerganov.

### Community Inspiration
Special thanks to the ggwave community for:
- **Issue #41** - Identifying the need for pure audio file transfer
- **Discussions** - Providing feedback on protocols and use cases
- **Testing** - Community members testing ggwave in various scenarios

### What SonarLink Contributes
SonarLink builds upon ggwave by providing:
- User-friendly command-line interface
- File compression (gzip)
- Multiple encryption methods (AES-256, RSA-2048)
- HMAC authentication for data integrity
- Chunked file transfer protocol with optimal timing
- Cross-platform installation scripts
- Comprehensive error handling and recovery
- Production-ready file transfer system

### Standing on the Shoulders of Giants
- **Georgi Gerganov** for creating ggwave and making it open source
- The **Python Cryptographic Authority (PyCA)** for the cryptography library
- The **PyAudio** and **PortAudio** communities
- All open-source contributors who make projects like this possible
- The **ggwave community** for identifying the need this project fulfills

---

## How to Credit

### If you use SonarLink in your project:

**Minimum attribution:**
```
SonarLink - Pure audio-based file transfer system
Based on ggwave by Georgi Gerganov (https://github.com/ggerganov/ggwave)
```

**Full attribution (preferred):**
```
SonarLink - Secure Audio-Based File Transfer System
Copyright (c) 2025 [Your Name]
https://github.com/[your-username]/sonarlink

Built with ggwave - Audio Data Transmission Library
Copyright (c) 2020-2024 Georgi Gerganov
https://github.com/ggerganov/ggwave

Implements the feature requested in ggwave Issue #41
Licensed under the MIT License
```

### If you modify or extend SonarLink:

Please maintain this ATTRIBUTIONS.md file and ensure that:
1. ggwave attribution remains prominent
2. The MIT License is preserved
3. Original copyright notices are not removed
4. Changes are documented
5. Reference to Issue #41 is maintained

---

## License Compliance

SonarLink is distributed under the **MIT License**, which is compatible with all the dependencies listed above.

**What this means:**
- ✅ You can use SonarLink commercially
- ✅ You can modify and distribute SonarLink
- ✅ You must include the copyright notice
- ✅ You must include the license text
- ✅ You must credit ggwave when using SonarLink
- ✅ Acknowledge the community request that inspired this project

**Important:** While the code is freely available, please respect the work of the original authors by providing proper attribution.

---

## Additional Resources

### ggwave Ecosystem
- **ggwave C++ Library:** https://github.com/ggerganov/ggwave
- **ggwave.js (JavaScript):** https://github.com/ggerganov/ggwave/tree/master/examples/ggwave-js
- **ggwave-wasm (WebAssembly):** https://github.com/ggerganov/ggwave/tree/master/examples/ggwave-wasm
- **ggwave-cli (Command Line):** https://github.com/ggerganov/ggwave/tree/master/examples/ggwave-cli
- **wave-share (WebRTC):** https://github.com/ggerganov/wave-share
- **Waver (Official App):** https://waver.ggerganov.com

### Community & Discussion
- **ggwave Discussions:** https://github.com/ggerganov/ggwave/discussions
- **Issue #41 (File Transfer Request):** https://github.com/ggerganov/ggwave/issues/41
- **SonarLink Issues:** https://github.com/[your-username]/sonarlink/issues

### Related Technologies
- **Chirp:** https://chirp.io/ (Commercial data-over-sound platform)
- **Quiet.js:** https://github.com/quiet/quiet-js (Alternative library)
- **DTMF:** https://en.wikipedia.org/wiki/Dual-tone_multi-frequency_signaling (Traditional audio signaling)

---

## Contact

For questions about licensing or attributions:
- **SonarLink Issues:** https://github.com/[your-username]/sonarlink/issues
- **ggwave Issues:** https://github.com/ggerganov/ggwave/issues

---

**Last Updated:** October 2025

**Note:** This file should be included with all distributions of SonarLink to ensure proper attribution of third-party components and acknowledge the community inspiration behind this project.
