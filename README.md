# Dosya Şifreleyici 🚀🔒

Bu uygulama, seçtiğin dosyaları AES-256 algoritmasıyla şifrelemeni ve daha sonra tekrar çözmeni sağlar.  
Android, iOS, macOS, Windows ve Linux destekler!

---

## Özellikler 🎯
- 📂 Dosyaları sürükle bırak ile seçme
- 🔑 Parola belirleyerek AES-256 şifreleme
- 🗂️ Tek bir `.crypto` dosyası oluşturma
- 📥 Android/iOS'ta doğrudan **Downloads** klasörüne kayıt
- 🖥️ Windows, macOS ve Linux'ta dosya bulunduğu yere kayıt
- 📤 Şifreli dosyayı kolayca çözme
- ✨ Çapraz platform desteği

---

## Kullanım 👨‍💻

1. Uygulamayı aç.
2. Dosyalarını sürükleyip bırak.
3. Bir parola ve yeni dosya adı yaz.
4. **ŞİFRELE** butonuna bas.
5. Şifreli dosya `.crypto` uzantısıyla dışa aktarılacak.

Şifre çözmek için:
- Şifreli dosyayı seç,
- Parolanı gir,
- Dosyalar orijinal halleriyle çıkarılacak.

---

## Ekran Görüntüleri 🖼️

### Dosya Seçme ve Parola Girme:
![Screenshot1](assets/screenshot1.png)

---

### Şifrelenmiş Dosya Başarı Mesajı:
![Screenshot2](assets/screenshot2.png)

---

## Kurulum 🛠️

```bash
# Flutter SDK'yı kurduktan sonra:
git clone https://github.com/kullaniciadi/dosya-sifreleyici.git
cd dosya-sifreleyici

# Paketleri yükle
flutter pub get

# Çalıştır
flutter run -d windows # veya android/ios/macos/linux
