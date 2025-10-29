# Parola Üretici (Bash Script)

Bu proje, Linux ortamında çalışabilen **Bash ile Parola Üretici** scriptini içerir.  

---

## İçerik

- `sıfre_olusturucu.sh` → Bash script ile güvenli parolalar üretir.  
- `secili_parolalar.txt` → Kullanıcı tarafından seçilen parolalar bu dosyada saklanır.  

---

## Özellikler

- Belirtilen uzunlukta güvenli parolalar üretir  
- Kullanıcı, önerilen parolalardan seçim yapabilir  
- Seçilen parolalar **tarihle birlikte** `secili_parolalar.txt` dosyasına kaydedilir  

---

## Kullanım

Önce scripti çalıştırılabilir yap:
```bash
chmod +x sıfre_olusturucu.sh
---

Sonra çalıştır:

```bash
./sıfre_olusturucu.sh
