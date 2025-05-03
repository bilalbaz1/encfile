### Languages: &nbsp; [Türkçe](https://github.com/bilalbaz1/encfile/blob/main/README/README-tr.md) &nbsp; &nbsp; [Chinese](https://github.com/bilalbaz1/encfile/blob/main/README/README-zh.md) &nbsp; &nbsp; [Japanese](https://github.com/bilalbaz1/encfile/blob/main/README/README-jp.md) &nbsp; &nbsp; [Russian](https://github.com/bilalbaz1/encfile/blob/main/README/README-ru.md) &nbsp;&nbsp; [Arabic](https://github.com/bilalbaz1/encfile/blob/main/README/README-ar.md)

&nbsp;

# File Encryptor 🚀🔒

This application allows users to securely encrypt and share their files. Users can select their files and encrypt them using a password with the AES algorithm in CBC mode. The encrypted file is saved with a ".crypto" extension and works on all platforms (macOS, Windows, Linux, Android, iOS, web). It provides a secure file sharing and storage option for platforms that do not offer end-to-end encryption.

---

# Platforms 💻 📱 🖥️ 🌐
## [🌐 Web Site (online)](https://bilalbaz1.github.io/encfile-web/)
## [💻 MacOS (.dmg)](https://github.com/bilalbaz1/encfile/releases/latest/download/macos.dmg)
## [🖥️ Windows (.exe)](https://github.com/bilalbaz1/encfile/releases/latest/download/windows.exe)
## [📱 Android (.apk)](https://github.com/bilalbaz1/encfile/releases/latest/download/android.apk)
## [📱 Linux (.deb)](https://github.com/bilalbaz1/encfile/releases/latest/download/linux.deb)

---

## Purpose:
To enable users to securely encrypt and share their files. It is developed for secure file sharing on platforms that do not offer end-to-end encryption. 🌐

## Platform Support:
The application works on all major platforms:
- macOS 🍏
- Windows 💻
- Linux 🐧
- Android 📱
- iOS 🍎
- Web browsers 🌍

## File Encryption Process:
1. The user selects the files they want to encrypt. 📂
2. The selected files are first converted to ZIP format. 📦
3. The ZIP file is converted to a byte array. 🔄
4. It is encrypted using the AES algorithm in CBC mode with a password specified by the user. 🔑

## Encrypted File Transfer:
- The encrypted file is exported with a ".crypto" extension. 📤
- The user can load this encrypted file back into the application to perform the decryption process. 🔓

## Secure Storage:
The application ensures that files are stored securely and in an encrypted format. 🛡️

## Ease of Use:
With a user-friendly interface, everyone can easily encrypt and decrypt files. 👩‍💻👨‍💻

## Privacy and Security:
The application prioritizes user privacy by ensuring that files are encrypted securely. 🔒✨

This application helps users protect and share their files securely while providing a simple and effective experience.


---

## Usage 👨‍💻

1. Open the application.
2. Drag and drop your files.
3. Enter a password and a new file name.
4. Press the **ENCRYPT** button.
5. The encrypted file will be exported with a `.crypto` extension.

To decrypt:
- Select the encrypted file,
- Enter your password,
- Files will be extracted in their original form.

---

## How It Works? 🖼️

### Select files. Enter password and file name.
![](assets/screenshot/1.png)
### Encrypt.
![](assets/screenshot/2.png)
### Export the encrypted file.
![](assets/screenshot/3.png)

---

## Decrypt a file:

### Select the encrypted file. Enter the password.
![](assets/screenshot/4.png)
### Files will be extracted after decryption.
![](assets/screenshot/5.png)

---

## Installation 🛠️

```bash
# After installing Flutter SDK:
git clone https://github.com/bilalbaz1/encfile.git
cd file-encryptor

# Install packages
flutter pub get

# Run
flutter run -d windows # or android/ios/macos/linux
