#!/bin/bash
# CYBER FLAY TOOLS v5
# Author: CYBER FLAY (white-hat)
# NOTE: Gunakan hanya untuk tujuan legal & edukasi pada target milik sendiri / izin tertulis.

# ====== Warna ======
red='\033[1;31m'; green='\033[1;32m'; yellow='\033[1;33m'; blue='\033[1;34m'; mag='\033[1;35m'; cyan='\033[1;36m'; nc='\033[0m'

# ====== Util: urlencode / urldecode (pure bash) ======
urlencode() {
  local LANG=C
  local length="${#1}"
  for (( i = 0; i < length; i++ )); do
    local c="${1:i:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf "$c" ;;
      ' ') printf '%%20' ;;
      *) printf '%%%02X' "'$c" ;;
    esac
  done
}
urldecode() {
  local data=${1//+/ }
  printf '%b' "${data//%/\\x}"
}

# ====== ASCII ======
banner() {
  clear
  echo -e "${yellow}==============================================${nc}"
  echo -e "             ${red}CYBER FLAY TOOLS v5${nc}"
  echo -e "${yellow}==============================================${nc}"
  echo -e "     ${green}TOOLS INI DIBUAT OLEH CYBER FLAY${nc}"
  echo ""
  echo -e "${blue}      .----."
  echo -e "     /      \\\\"
  echo -e "    |  () () |"
  echo -e "     \\\\  /\\\\  /"
  echo -e "      '----'${nc}"
  echo ""
}

hacker_ascii() {
  echo -e "${mag}      .------."
  echo -e "     /  ~ ~   \\\\"
  echo -e "    |  ^   ^   |"
  echo -e "    |  (o) (o) |"
  echo -e "     \\\\   ∆   /"
  echo -e "      '------'${nc}"
}

pause() { read -p "Enter untuk lanjut..." ; }

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo -e "${yellow}[INFO] Perintah '${1}' belum terinstall.${nc}"
    echo -e "Install di Termux: ${green}pkg install $2${nc}"
    return 1
  fi
  return 0
}

# ====== OSINT Functions (classic 1-14) ======
osint_whois() { read -p "Domain: " domain; if need_cmd whois whois; then whois "$domain" | head -n 80; fi; echo -e "${cyan}RDAP:${nc}"; curl -s "https://rdap.org/domain/$domain" | jq . 2>/dev/null || true; pause; }
osint_geoip() { read -p "IP / domain: " target; curl -s "http://ip-api.com/json/$target" | jq . 2>/dev/null || curl -s "http://ip-api.com/json/$target"; pause; }
osint_dns_lookup() { read -p "Domain: " d; if need_cmd dig dnsutils; then dig +short A "$d"; dig +short MX "$d"; dig +short NS "$d"; fi; pause; }
osint_reverse_dns() { read -p "IP: " ip; if need_cmd dig dnsutils; then dig -x "$ip" +short; fi; pause; }
osint_subdomain_crt() { read -p "Domain: " d; curl -s "https://crt.sh/?q=%25.$d&output=json" | jq -r '.[].name_value' 2>/dev/null | sort -u | sed 's/\*\.//g' | sed 's/\r//g'; pause; }
osint_http_headers() { read -p "URL (https://example.com): " url; curl -sI "$url"; pause; }
osint_http_status() { read -p "URL (https://example.com): " url; code=$(curl -o /dev/null -s -w "%{http_code}" "$url"); echo "HTTP Status: $code"; pause; }
osint_traceroute() { read -p "Domain/IP: " t; if need_cmd traceroute traceroute; then traceroute "$t"; fi; pause; }
osint_ping() { read -p "Domain/IP: " t; ping -c 4 "$t"; pause; }
osint_portscan() { read -p "Target (domain/IP): " t; read -p "Port list (cth: 21,22,80,443,8080): " plist; IFS=',' read -ra ports <<< "$plist"; if need_cmd nc netcat-openbsd; then for p in "${ports[@]}"; do echo -ne "Port $p: "; (nc -zv -w 2 "$t" "$p" >/dev/null 2>&1 && echo "OPEN") || echo "CLOSED"; done; fi; pause; }
osint_ssl_info() { read -p "Domain (tanpa https): " d; if need_cmd openssl openssl; then echo | openssl s_client -showcerts -servername "$d" -connect "$d:443" 2>/dev/null | openssl x509 -noout -issuer -subject -dates -fingerprint -sha256; fi; pause; }
osint_reverse_ip_domains() { read -p "IP: " ip; echo "[Hackertarget] (rate limit)"; curl -s "https://api.hackertarget.com/reverseiplookup/?q=$ip"; pause; }
osint_email_breach() { echo "[INFO] HIBP butuh API key. Set: export HIBP_KEY=YOUR_KEY"; read -p "Email: " email; if [ -n "$HIBP_KEY" ]; then curl -s -H "hibp-api-key: $HIBP_KEY" -H "user-agent: CYBER-FLAY" "https://haveibeenpwned.com/api/v3/breachedaccount/$email?truncateResponse=false" | jq . 2>/dev/null || echo "Tidak ada/terblokir."; else echo "HIBP_KEY belum di-set."; fi; pause; }
osint_github_user() { read -p "Github username: " u; curl -s "https://api.github.com/users/$u" | jq . 2>/dev/null || curl -s "https://api.github.com/users/$u"; pause; }

# ====== OSINT v5: Username/Name OSINT ======
osint_username_platforms() {
  hacker_ascii
  read -p "Masukkan NAMA / USERNAME (boleh panjang, contoh: CYBER FLAY): " name
  enc=$(urlencode "$name")
  echo -e "${yellow}== Platform Checker ==${nc}"
  declare -A P
  P["GitHub"]="https://github.com/$enc"
  P["GitLab"]="https://gitlab.com/$enc"
  P["Reddit"]="https://www.reddit.com/user/$enc"
  P["Instagram"]="https://www.instagram.com/$enc"
  P["TikTok"]="https://www.tiktok.com/@$enc"
  P["Twitter/X"]="https://twitter.com/$enc"
  P["Facebook"]="https://www.facebook.com/$enc"
  P["YouTube"]="https://www.youtube.com/@$enc"
  P["LinkedIn"]="https://www.linkedin.com/in/$enc"
  P["Medium"]="https://medium.com/@$enc"
  P["Pinterest"]="https://www.pinterest.com/$enc"
  P["SoundCloud"]="https://soundcloud.com/$enc"
  P["Telegram"]="https://t.me/$enc"
  P["Discord"]="https://discord.com/users/$enc"
  P["Tumblr"]="https://$enc.tumblr.com"
  for site in "${!P[@]}"; do
    url="${P[$site]}"
    code=$(curl -o /dev/null -s -w "%{http_code}" -L "$url")
    if [ "$code" = "200" ] || [ "$code" = "301" ] || [ "$code" = "302" ]; then
      echo "[ + ] $(printf '%-10s' "$site") : $url"
    else
      echo "[ - ] $(printf '%-10s' "$site") : $url"
    fi }
  done
  pause
}

osint_search_duck() {
  hacker_ascii
  read -p "Masukkan NAMA / KATA KUNCI untuk pencarian web: " query
  q=$(urlencode "$query")
  echo -e "${yellow}== DuckDuckGo Search (Top 20) ==${nc}"
  html=$(curl -s "https://duckduckgo.com/html/?q=$q&ia=web")
  echo "$html" | grep -o 'uddg=[^"&]*' | sed 's/^uddg=//' | head -n 50 | while read -r enc; do
    link=$(urldecode "$enc")
    if [[ "$link" == http* ]]; then
      echo "[ + ] $link"
    fi
  done | awk '!seen[$0]++' | head -n 20
  pause
}

osint_username_osint() {
  while true; do
    clear; hacker_ascii
    echo -e "${yellow}==== USERNAME / NAME OSINT ====${nc}"
    echo "1) Platform Checker (15 platform)"
    echo "2) Search Engine Mode (DuckDuckGo)"
    echo "0) Kembali"
    read -p "Pilih: " c
    case "$c" in
      1) osint_username_platforms ;;
      2) osint_search_duck ;;
      0) break ;;
      *) echo "Pilihan salah"; sleep 1 ;;
    esac
  done
}

# ====== Deface (Generator) ======
deface_gen() {
  hacker_ascii
  echo -e "${yellow}=== Deface Page Generator (HTML + JS) ===${nc}"
  read -p "Nama (signature): " nama
  read -p "Pesan deface: " pesan
  read -p "Kode JavaScript (contoh: alert('Hacked by '$nama);): " js
  cat > deface.html <<EOF
<html>
<head><title>Hacked by $nama</title></head>
<body style="background:black;color:lime;text-align:center;font-family:monospace">
<h1>Hacked by $nama</h1>
<p>$pesan</p>
<canvas id="m"></canvas>
<script>
$js
// efek matrix sederhana
const c=document.getElementById('m');const ctx=c.getContext('2d');c.height=window.innerHeight;c.width=window.innerWidth;
const chars='01FLAYCYBER';const font=14;const cols=c.width/font;const drops=Array(parseInt(cols)).fill(1);
function draw(){ctx.fillStyle='rgba(0,0,0,0.05)';ctx.fillRect(0,0,c.width,c.height);ctx.fillStyle='#0f0';ctx.font=font+'px monospace';
for(let i=0;i<drops.length;i++){const t=chars[Math.floor(Math.random()*chars.length)];ctx.fillText(t,i*font,drops[i]*font);
if(drops[i]*font>c.height&&Math.random()>0.975)drops[i]=0;drops[i]++;}}setInterval(draw,35);
</script>
</body>
</html>
EOF
  echo -e "${green}deface.html dibuat. Buka dengan: termux-open deface.html${nc}"
  pause
}

# ====== Menu Lain (12) ======
lain_ip() { echo "IP Publik:"; curl -s ifconfig.me; echo; pause; }
lain_cuaca() { read -p "Kota: " k; curl -s "wttr.in/$k?format=3"; echo; pause; }
lain_kalk() { read -p "Ekspresi (cth: 5+10*2): " e; need_cmd bc bc && echo "Hasil: $(echo "$e" | bc -l)"; pause; }
lain_waktu() { date; pause; }
lain_speed() { echo "Speedtest sederhana (wget 10MB)..."; need_cmd wget wget && (TMP=$(mktemp) && wget -qO "$TMP" http://speedtest.tele2.net/10MB.zip && ls -lh "$TMP" && rm -f "$TMP"); pause; }
lain_b64_enc() { read -p "Teks: " t; echo -n "$t" | base64; echo; pause; }
lain_b64_dec() { read -p "Base64: " t; echo "$t" | base64 -d 2>/dev/null || echo "Base64 tidak valid"; echo; pause; }
lain_hash() { read -p "Teks: " t; echo "MD5   : $(echo -n "$t" | md5sum | awk '{print $1}')"; echo "SHA1  : $(echo -n "$t" | sha1sum | awk '{print $1}')"; echo "SHA256: $(echo -n "$t" | sha256sum | awk '{print $1}')"; pause; }
lain_short() { read -p "URL asli: " u; echo -n "Short: "; curl -s "https://tinyurl.com/api-create.php?url=${u}"; echo; pause; }
lain_qr() { read -p "Teks/URL: " t; out="qrcode.png"; curl -s "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${t}" -o "$out" && echo "Saved -> $out"; pause; }

lain_ai_chat() {
  hacker_ascii
  echo -e "${yellow}=== Chat AI (dummy, tanpa API) ===${nc}"
  read -p "Tanya apa saja: " q
  quotes=(
    "Setiap sistem punya celah, yang penting etika saat menguji."
    "Data tanpa izin bukan target kita. Fokus pada responsible disclosure."
    "Enumeration dulu, exploitation belakangan."
    "Backup rencana: recon, threat modeling, PoC, report."
    "Kunci OSINT: sabar, teliti, dan catat jejak."
  )
  idx=$((RANDOM % ${#quotes[@]}))
  echo -e "${green}AI:${nc} ${quotes[$idx]}"
  pause
}

lain_name_gen() {
  hacker_ascii
  echo -e "${yellow}=== Hacker Name Generator ===${nc}"
  names=(ShadowX ZeroByte GhostRoot CyberSpectre NightRaven ByteViper NullTrace DarkCipher NeonWarden PhantomFlux)
  echo "Nama random:"
  for i in {1..8}; do
    idx=$((RANDOM % ${#names[@]}))
    echo "- ${names[$idx]}"
  done
  pause
}

menu_lain() {
  while true; do
    clear; hacker_ascii
    echo -e "${yellow}=========== MENU LAIN (12 Fitur) =======${nc}"
    echo " 1) Cek IP Publik"
    echo " 2) Cek Cuaca (wttr.in)"
    echo " 3) Kalkulator (bc)"
    echo " 4) Tanggal & Jam"
    echo " 5) Speedtest sederhana"
    echo " 6) Base64 Encode"
    echo " 7) Base64 Decode"
    echo " 8) Hash Generator (MD5/SHA1/SHA256)"
    echo " 9) URL Shortener (tinyurl)"
    echo "10) QR Code Generator"
    echo "11) Chat dengan AI (dummy)"
    echo "12) Name Generator ala hacker"
    echo " 0) Kembali"
    echo "========================================"
    read -p "Pilih: " c
    case "$c" in
      1) lain_ip ;;
      2) lain_cuaca ;;
      3) lain_kalk ;;
      4) lain_waktu ;;
      5) lain_speed ;;
      6) lain_b64_enc ;;
      7) lain_b64_dec ;;
      8) lain_hash ;;
      9) lain_short ;;
      10) lain_qr ;;
      11) lain_ai_chat ;;
      12) lain_name_gen ;;
      0) break ;;
      *) echo -e "${red}Pilihan salah!${nc}"; sleep 1 ;;
    esac
  done
}

# ====== Menu OSINT (15 total, termasuk submenu username/search) ======
menu_osint() {
  while true; do
    clear; hacker_ascii
    echo -e "${yellow}=========== OSINT (15 Fitur) ===========${nc}"
    echo " 1) WHOIS Lookup"
    echo " 2) GeoIP Lookup"
    echo " 3) DNS Lookup (A/MX/NS)"
    echo " 4) Reverse DNS (PTR)"
    echo " 5) Subdomain Finder (crt.sh)"
    echo " 6) HTTP Headers"
    echo " 7) HTTP Status Code"
    echo " 8) Traceroute"
    echo " 9) Ping"
    echo "10) Port Scan (nc)"
    echo "11) SSL Certificate Info"
    echo "12) Reverse IP -> Domains"
    echo "13) Email Breach Check (HIBP, key)"
    echo "14) GitHub User OSINT"
    echo "15) Username/Name OSINT (Platform + Duck)"
    echo " 0) Kembali"
    echo "========================================"
    read -p "Pilih: " c
    case "$c" in
      1) osint_whois ;;
      2) osint_geoip ;;
      3) osint_dns_lookup ;;
      4) osint_reverse_dns ;;
      5) osint_subdomain_crt ;;
      6) osint_http_headers ;;
      7) osint_http_status ;;
      8) osint_traceroute ;;
      9) osint_ping ;;
      10) osint_portscan ;;
      11) osint_ssl_info ;;
      12) osint_reverse_ip_domains ;;
      13) osint_email_breach ;;
      14) osint_github_user ;;
      15) osint_username_osint ;;
      0) break ;;
      *) echo -e "${red}Pilihan salah!${nc}"; sleep 1 ;;
    esac
  done
}

# ====== Main ======
while true; do
  banner
  echo -e "${yellow}1.${nc} OSINT (15 fitur)"
  echo -e "${yellow}2.${nc} Deface (HTML + JS)"
  echo -e "${yellow}3.${nc} Menu Lain (12 fitur)"
  echo -e "${yellow}0.${nc} Keluar"
  echo ""
  read -p "Pilih menu: " menu
  case "$menu" in
    1) menu_osint ;;
    2) deface_gen ;;
    3) menu_lain ;;
    0) echo "Keluar..."; exit 0 ;;
    *) echo -e "${red}Pilihan tidak valid!${nc}" ; sleep 1 ;;
  esac
done
