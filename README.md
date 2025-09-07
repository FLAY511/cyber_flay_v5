# CYBER FLAY TOOLS v5

**OSINT v5 (15 fitur)** + **Deface (HTML+JS)** + **Menu Lain (12 fitur)** — dibuat untuk Termux (Bash).  
Gunakan hanya pada aset milik sendiri atau dengan izin tertulis (responsible disclosure).

## 📥 Install di Termux
```bash
pkg update && pkg upgrade -y
pkg install curl jq bc openssl wget -y
pkg install dnsutils traceroute whois netcat-openbsd -y
# (opsional) python tidak diperlukan
```

## ▶️ Jalankan
```bash
chmod +x flay_hacker_v5.sh
./flay_hacker_v5.sh
```

## 🕵️ OSINT (15)
1. WHOIS Lookup (cli + RDAP)
2. GeoIP Lookup (ip-api)
3. DNS Lookup (A/MX/NS)
4. Reverse DNS (PTR)
5. Subdomain Finder (crt.sh)
6. HTTP Headers
7. HTTP Status Code
8. Traceroute
9. Ping
10. Port Scan (nc)
11. SSL Certificate Info (openssl)
12. Reverse IP → Domains (hackertarget)
13. Email Breach Check (HIBP, butuh API key: env `HIBP_KEY`)
14. GitHub User OSINT (api.github.com)
15. **Username/Name OSINT**
   - **Platform Checker (15 platform)**: GitHub, GitLab, Reddit, Instagram, TikTok, Twitter/X, Facebook, YouTube, LinkedIn, Medium, Pinterest, SoundCloud, Telegram, Discord, Tumblr.
   - **Search Engine Mode (DuckDuckGo)**: ambil hingga 20 hasil teratas yang mengandung nama yang dicari.

## 💻 Deface
- Generator `deface.html` dengan efek Matrix dan JS custom.

## 🛠️ Menu Lain (12)
1. Cek IP Publik
2. Cek Cuaca (wttr.in)
3. Kalkulator (bc)
4. Tanggal & Jam
5. Speedtest sederhana (wget 10MB)
6. Base64 Encode
7. Base64 Decode
8. Hash Generator (MD5/SHA1/SHA256)
9. URL Shortener (tinyurl)
10. QR Code Generator (api.qrserver.com)
11. Chat dengan AI (dummy, tanpa API)
12. Name Generator ala hacker (random)

## ⚠️ Catatan
- Beberapa endpoint gratis memiliki rate-limit; bila gagal, coba lagi nanti.
- Untuk HIBP, siapkan API key lalu export:
  ```bash
  export HIBP_KEY=KEY_KAMU
  ```
- DuckDuckGo parsing dilakukan dari halaman HTML `/html?` sehingga tidak butuh API key.

## 👤 Author
Dibuat oleh **CYBER FLAY** (white-hat).
