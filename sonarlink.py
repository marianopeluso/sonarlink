#!/usr/bin/env python3
"""
SonarLink v1.0: Send and receive messages and files via ggwave
- Audio frequency 48000 Hz
- Gzip compression
- Optional AES or RSA encryption
- Encrypted files saved locally before transmission
"""

import os, sys, time, base64, gzip
import numpy as np

try:
    import pyaudio
except ImportError:
    print("Error: install pyaudio (pip3 install pyaudio)")
    sys.exit(1)

try:
    import ggwave
except ImportError:
    print("Error: install ggwave (pip3 install ggwave-wheels)")
    sys.exit(1)

try:
    from cryptography.hazmat.primitives import serialization, hashes, hmac
    from cryptography.hazmat.primitives.asymmetric import padding
    from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
    from cryptography.hazmat.backends import default_backend
except ImportError:
    print("Cryptography not available: install cryptography")
    HAS_CRYPTO = False
else:
    HAS_CRYPTO = True

SAMPLE_RATE = 48000
CHUNK_SIZE = 4096
VOLUME = 80
PROTOCOL_ID = 1  # GGWAVE_PROTOCOL_AUDIBLE_FAST
MAX_FILE_SIZE = 10 * 1024 * 1024  # 10 MB limit
GGWAVE_MAX_BYTES = 120  # Maximum bytes per ggwave transmission

# ------------------
# Waveform preparation
# ------------------
def prepare_waveform(message: str):
    if not isinstance(message, str):
        message = message.decode('utf-8', errors='ignore')
    raw = ggwave.encode(message, protocolId=PROTOCOL_ID, volume=VOLUME)
    if isinstance(raw, (bytes, bytearray)):
        return bytes(raw)
    arr = np.asarray(raw, dtype=np.float32).flatten()
    return arr.tobytes()

# ------------------
# Audio transmission
# ------------------
def tx_message(waveform):
    p = pyaudio.PyAudio()
    try:
        stream = p.open(format=pyaudio.paFloat32, channels=1,
                        rate=SAMPLE_RATE, output=True,
                        frames_per_buffer=CHUNK_SIZE)
        bytes_per_frame = 4
        chunk_bytes = CHUNK_SIZE * bytes_per_frame
        for i in range(0, len(waveform), chunk_bytes):
            stream.write(waveform[i:i+chunk_bytes])
            time.sleep(0.05)
        stream.stop_stream()
        stream.close()
    finally:
        p.terminate()

# ------------------
# AES encryption
# ------------------
def aes_encrypt(data: bytes, password: str):
    key = password.encode('utf-8')
    key = (key * 32)[:32]
    iv = os.urandom(16)

    # Encrypt the data
    cipher = Cipher(algorithms.AES(key), modes.CFB(iv), backend=default_backend())
    encryptor = cipher.encryptor()
    ciphertext = encryptor.update(data) + encryptor.finalize()

    # Create HMAC for authentication
    h = hmac.HMAC(key, hashes.SHA256(), backend=default_backend())
    h.update(iv + ciphertext)
    mac = h.finalize()

    # Return: MAC (32 bytes) + IV (16 bytes) + ciphertext
    return mac + iv + ciphertext

def aes_decrypt(data: bytes, password: str):
    if len(data) < 48:  # MAC(32) + IV(16) minimum
        raise ValueError("Invalid encrypted data: too short")

    key = password.encode('utf-8')
    key = (key * 32)[:32]

    # Extract components
    mac = data[:32]
    iv = data[32:48]
    ciphertext = data[48:]

    # Verify HMAC
    h = hmac.HMAC(key, hashes.SHA256(), backend=default_backend())
    h.update(iv + ciphertext)
    try:
        h.verify(mac)
    except Exception:
        raise ValueError("Wrong password or corrupted file")

    # Decrypt
    cipher = Cipher(algorithms.AES(key), modes.CFB(iv), backend=default_backend())
    decryptor = cipher.decryptor()
    return decryptor.update(ciphertext) + decryptor.finalize()

# ------------------
# RSA encryption
# ------------------
def rsa_encrypt(data: bytes, pubkey_pem: str):
    pubkey = serialization.load_pem_public_key(pubkey_pem.encode())
    return pubkey.encrypt(data,
                          padding.OAEP(mgf=padding.MGF1(algorithm=hashes.SHA256()),
                                       algorithm=hashes.SHA256(),
                                       label=None))

def rsa_decrypt(data: bytes, privkey_path: str, password=None):
    with open(privkey_path, "rb") as f:
        privkey = serialization.load_pem_private_key(f.read(), password=password.encode() if password else None)
    return privkey.decrypt(data,
                           padding.OAEP(mgf=padding.MGF1(algorithm=hashes.SHA256()),
                                        algorithm=hashes.SHA256(),
                                        label=None))

# ------------------
# Send text messages
# ------------------
def send_text():
    print("📝 Enter messages (one per line). Double enter to finish, Ctrl+C to cancel.")
    messages = []
    try:
        while True:
            msg = input("Message: ").strip()
            if not msg and messages:
                break
            if msg:
                messages.append(msg)
    except KeyboardInterrupt:
        print("\n⏹️ Input cancelled.")
        return
    if not messages:
        print("❌ No messages entered.")
        return
    try:
        for i, msg in enumerate(messages, 1):
            tx_message(prepare_waveform(msg))
            print(f"✅ Message {i} sent: {msg[:50]}{'...' if len(msg)>50 else ''}")
    except KeyboardInterrupt:
        print("\n⏹️ Transmission interrupted.")

# ------------------
# Send files
# ------------------
def send_file():
    print("📁 Send file")
    print("1. Unencrypted files (multiple files)")
    print("2. AES encryption (1 file)")
    print("3. RSA encryption (1 file)")
    try:
        choice = input("Choice (1-3): ").strip()
    except KeyboardInterrupt:
        print("\n⏹️ Operation cancelled.")
        return

    if choice == "1":
        try:
            files = input("Files separated by comma: ").split(",")
            files = [f.strip() for f in files if f.strip()]
        except KeyboardInterrupt:
            print("\n⏹️ Operation cancelled.")
            return
        for fname in files:
            if not os.path.exists(fname):
                print(f"❌ File not found: {fname}")
                continue
            file_size = os.path.getsize(fname)
            if file_size > MAX_FILE_SIZE:
                print(f"❌ File too large: {fname} ({file_size} bytes, max {MAX_FILE_SIZE})")
                continue
            with open(fname, "rb") as f:
                content = f.read()
            content = gzip.compress(content)
            encoded = base64.b64encode(content).decode("ascii")
            tx_message(prepare_waveform(f"FILE:{os.path.basename(fname)}"))
            time.sleep(3)
            chunk_count = 0
            total_chunks = (len(encoded) + GGWAVE_MAX_BYTES - 1) // GGWAVE_MAX_BYTES
            print(f"   📤 Sending {total_chunks} chunks of max {GGWAVE_MAX_BYTES} chars...")
            for i in range(0, len(encoded), GGWAVE_MAX_BYTES):
                tx_message(prepare_waveform(encoded[i:i+GGWAVE_MAX_BYTES]))
                time.sleep(1.0)
                chunk_count += 1
                print(f"   📊 Sent chunk {chunk_count}/{total_chunks}", end="\r")
            print()
            time.sleep(2)
            tx_message(prepare_waveform("ENDFILE"))
            time.sleep(3)
            print(f"✅ File sent: {fname}")

    elif choice == "2" and HAS_CRYPTO:
        try:
            fname = input("File to encrypt: ").strip()
            password = input("AES password: ").strip()
        except KeyboardInterrupt:
            print("\n⏹️ Operation cancelled.")
            return
        if not os.path.exists(fname):
            print("❌ File not found")
            return
        file_size = os.path.getsize(fname)
        if file_size > MAX_FILE_SIZE:
            print(f"❌ File too large ({file_size} bytes, max {MAX_FILE_SIZE})")
            return
        with open(fname, "rb") as f:
            content = f.read()
        enc_content = aes_encrypt(content, password)
        save_name = fname + ".aes"
        with open(save_name, "wb") as f:
            f.write(enc_content)
        print(f"✅ AES file saved: {save_name}")
        try:
            send_now = input("Send it now? (y/N): ").strip().lower()
        except KeyboardInterrupt:
            print("\n⏹️ Transmission cancelled.")
            return
        if send_now == "y":
            content = gzip.compress(enc_content)
            encoded = base64.b64encode(content).decode("ascii")
            print(f"   🔍 Original file: {len(enc_content)} bytes")
            print(f"   🔍 After gzip: {len(content)} bytes")
            print(f"   🔍 After base64: {len(encoded)} characters")
            total_chunks = (len(encoded) + GGWAVE_MAX_BYTES - 1) // GGWAVE_MAX_BYTES
            print(f"   📤 Sending {total_chunks} chunks of max {GGWAVE_MAX_BYTES} chars...")

            tx_message(prepare_waveform(f"FILE:{os.path.basename(save_name)}"))
            print(f"   ✓ Sent filename")
            time.sleep(3)

            chunk_count = 0
            for i in range(0, len(encoded), GGWAVE_MAX_BYTES):
                chunk = encoded[i:i+GGWAVE_MAX_BYTES]
                print(f"   📊 Preparing chunk {chunk_count+1}/{total_chunks}: {len(chunk)} chars")
                tx_message(prepare_waveform(chunk))
                print(f"   ✓ Sent chunk {chunk_count+1}/{total_chunks}")
                time.sleep(1.0)
                chunk_count += 1

            print(f"   ✓ All {chunk_count} chunks sent")
            time.sleep(2)
            tx_message(prepare_waveform("ENDFILE"))
            print(f"   ✓ Sent ENDFILE")
            time.sleep(3)
            print(f"✅ AES file sent: {save_name}")

    elif choice == "3" and HAS_CRYPTO:
        try:
            fname = input("File to encrypt: ").strip()
            pubkey_path = input("Public key PEM path: ").strip()
        except KeyboardInterrupt:
            print("\n⏹️ Operation cancelled.")
            return
        if not os.path.exists(fname) or not os.path.exists(pubkey_path):
            print("❌ File or key not found")
            return
        file_size = os.path.getsize(fname)
        if file_size > MAX_FILE_SIZE:
            print(f"❌ File too large ({file_size} bytes, max {MAX_FILE_SIZE})")
            return
        with open(fname, "rb") as f:
            content = f.read()
        with open(pubkey_path, "r") as kf:
            pubkey_pem = kf.read()
        enc_content = rsa_encrypt(content, pubkey_pem)
        save_name = fname + ".rsa"
        with open(save_name, "wb") as f:
            f.write(enc_content)
        print(f"✅ RSA file saved: {save_name}")
        try:
            send_now = input("Send it now? (y/N): ").strip().lower()
        except KeyboardInterrupt:
            print("\n⏹️ Transmission cancelled.")
            return
        if send_now == "y":
            content = gzip.compress(enc_content)
            encoded = base64.b64encode(content).decode("ascii")
            tx_message(prepare_waveform(f"FILE:{os.path.basename(save_name)}"))
            time.sleep(3)
            chunk_count = 0
            total_chunks = (len(encoded) + GGWAVE_MAX_BYTES - 1) // GGWAVE_MAX_BYTES
            print(f"   📤 Sending {total_chunks} chunks of max {GGWAVE_MAX_BYTES} chars...")
            for i in range(0, len(encoded), GGWAVE_MAX_BYTES):
                tx_message(prepare_waveform(encoded[i:i+GGWAVE_MAX_BYTES]))
                time.sleep(1.0)
                chunk_count += 1
                print(f"   📊 Sent chunk {chunk_count}/{total_chunks}", end="\r")
            print()
            time.sleep(2)
            tx_message(prepare_waveform("ENDFILE"))
            time.sleep(3)
            print(f"✅ RSA file sent: {save_name}")

    else:
        print("❌ Invalid option or cryptography not available")

# ------------------
# Receive messages/files
# ------------------
def receive():
    p = pyaudio.PyAudio()
    try:
        stream = p.open(format=pyaudio.paFloat32, channels=1,
                        rate=SAMPLE_RATE, input=True,
                        frames_per_buffer=CHUNK_SIZE)
    except Exception as e:
        print("Error opening microphone:", e)
        return

    instance = ggwave.init()
    print(f"🎧 Listening at {SAMPLE_RATE} Hz... Ctrl+C to stop.")

    buffer = ""
    filename = None
    is_file = False
    files_received = 0
    last_message_time = time.time()
    text_messages = []
    chunks_received = 0

    try:
        while True:
            try:
                data = stream.read(CHUNK_SIZE, exception_on_overflow=False)
            except IOError:
                continue

            res = ggwave.decode(instance, data)
            if res:
                try:
                    text = res.decode("utf-8", errors="ignore")
                    last_message_time = time.time()

                    if text.startswith("FILE:"):
                        # Display pending text messages before starting file reception
                        if text_messages:
                            print("\n📨 Text messages received:")
                            for msg in text_messages:
                                print(f"  → {msg}")
                            text_messages = []

                        filename = text[5:].strip()
                        buffer = ""
                        is_file = True
                        chunks_received = 0
                        print(f"📥 Receiving file: {filename}")
                        print(f"   Waiting for data chunks...")
                    elif text == "ENDFILE" and is_file:
                        print(f"\n   ✓ Received ENDFILE signal")
                        print(f"   ✓ Total chunks received: {chunks_received}")
                        print(f"   ✓ Total characters: {len(buffer)}")
                        try:
                            content = base64.b64decode(buffer)
                            print(f"   ✓ Base64 decoded: {len(content)} bytes")
                            content = gzip.decompress(content)
                            print(f"   ✓ Decompressed: {len(content)} bytes")
                            output_filename = filename
                            with open(output_filename, "wb") as f:
                                f.write(content)
                            print(f"✅ File received and saved: {output_filename}")
                        except gzip.BadGzipFile:
                            print(f"❌ File corrupted during transmission (bad gzip)")
                            print(f"   Expected more data chunks")
                            # Save the corrupted file for debugging
                            corrupted_name = filename + ".corrupted"
                            with open(corrupted_name, "wb") as f:
                                f.write(base64.b64decode(buffer))
                            print(f"   Saved corrupted data to: {corrupted_name}")
                        except Exception as e:
                            print(f"❌ Error saving file: {e}")
                        finally:
                            buffer = ""
                            filename = None
                            is_file = False
                            files_received += 1
                            chunks_received = 0
                    elif is_file:
                        # Part of file transmission
                        buffer += text
                        chunks_received += 1
                        # Show progress every chunk
                        print(f"   📦 Chunk {chunks_received}: {len(text)} chars (total: {len(buffer)})", end="\r")
                    else:
                        # Regular text message
                        text_messages.append(text)
                        print(f"💬 Message: {text}")

                except Exception as e:
                    print(f"❌ Decoding error: {e}")

            # Display accumulated text messages after 3 seconds of silence
            if text_messages and (time.time() - last_message_time > 3):
                print(f"\n✅ Received {len(text_messages)} text message(s)")
                text_messages = []

    except KeyboardInterrupt:
        print("\n⏹️ Reception interrupted by user.")
        if text_messages:
            print(f"\n📨 Final text messages received:")
            for msg in text_messages:
                print(f"  → {msg}")
    finally:
        stream.stop_stream()
        stream.close()
        p.terminate()
        ggwave.free(instance)
        print("✅ Cleanup completed.")

# ------------------
# Decrypt files
# ------------------
def decrypt_file():
    print("🔐 Decrypt file (.aes / .rsa)")
    try:
        fname = input("Encrypted file path: ").strip()
        if not os.path.exists(fname):
            print("❌ File not found")
            return

        if fname.endswith(".aes"):
            while True:
                try:
                    password = input("AES password: ").strip()
                    with open(fname, "rb") as f:
                        encrypted_content = f.read()

                    # Try to decrypt - this will raise an exception if it fails
                    decrypted_content = aes_decrypt(encrypted_content, password)

                    # Only save if decryption succeeded
                    output_name = fname.replace(".aes", "_dec.bin")
                    with open(output_name, "wb") as f:
                        f.write(decrypted_content)
                    print(f"✅ AES file decrypted and saved: {output_name}")
                    break

                except (ValueError, Exception) as e:
                    print(f"❌ Decryption failed: Wrong password or corrupted file")
                    retry = input("Retry with different password? (y/N): ").strip().lower()
                    if retry != 'y':
                        print("⏹️ Decryption cancelled")
                        return

        elif fname.endswith(".rsa"):
            while True:
                try:
                    privkey_path = input("Private key PEM path: ").strip()
                    if not os.path.exists(privkey_path):
                        print("❌ Private key file not found")
                        retry = input("Try again? (y/N): ").strip().lower()
                        if retry != 'y':
                            print("⏹️ Decryption cancelled")
                            return
                        continue

                    password = input("Private key password (empty if none): ").strip() or None
                    with open(fname, "rb") as f:
                        encrypted_content = f.read()

                    # Try to decrypt - this will raise an exception if it fails
                    decrypted_content = rsa_decrypt(encrypted_content, privkey_path, password)

                    # Only save if decryption succeeded
                    output_name = fname.replace(".rsa", "_dec.bin")
                    with open(output_name, "wb") as f:
                        f.write(decrypted_content)
                    print(f"✅ RSA file decrypted and saved: {output_name}")
                    break

                except Exception as e:
                    print(f"❌ Decryption failed: Wrong key, wrong password, or corrupted file")
                    print(f"   Error details: {str(e)}")
                    retry = input("Retry with different key/password? (y/N): ").strip().lower()
                    if retry != 'y':
                        print("⏹️ Decryption cancelled")
                        return
        else:
            print("❌ Unsupported format (must be .aes or .rsa)")

    except KeyboardInterrupt:
        print("\n⏹️ Operation cancelled")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")

# ------------------
# Main menu
# ------------------
def main():
    while True:
        print("\n=== SonarLink v1.0 ===")
        print("1. Send text messages")
        print("2. Send files")
        print("3. Receive messages or files")
        print("4. Decrypt received file")
        print("5. Exit")
        try:
            choice = input("Choice (1-5): ").strip()
        except KeyboardInterrupt:
            print("\n⏹️ Exiting menu.")
            break
        if choice == "1":
            send_text()
        elif choice == "2":
            send_file()
        elif choice == "3":
            receive()
        elif choice == "4":
            decrypt_file()
        elif choice == "5":
            print("👋 Goodbye.")
            break
        else:
            print("❌ Invalid option.")

if __name__ == "__main__":
    main()
