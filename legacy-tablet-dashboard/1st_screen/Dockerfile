FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# Trecem pe Ubuntu, deci folosim apt-get pentru a instala JQ
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

# Setăm mediul
ENV PUID=1000
ENV PGID=1000
ENV TZ=Europe/Bucharest

# Cream scriptul care taie blocajul de HTTPS
RUN mkdir -p /custom-cont-init.d && \
    cat <<'EOF' > /custom-cont-init.d/99-setup-kiosk.sh
#!/bin/bash
echo "--- PREPARING FLUID DASHBOARD ---"

# 1. PATCH KASMVNC: Distrugem blocajul pentru HTTP (Ecranul negru)
sed -i 's/window.isSecureContext === false/1 == 2/g' /usr/share/kasmvnc/www/index.html || true
sed -i 's/window.isSecureContext===false/1==2/g' /usr/share/kasmvnc/www/index.html || true

# 2. CITIM URL-ul setat în Home Assistant
USER_URL=$(jq --raw-output '.url' /data/options.json)
if [ -z "$USER_URL" ] || [ "$USER_URL" == "null" ]; then
    USER_URL="http://homeassistant.local:8123"
fi

# 3. AUTOSTART: Forțăm Chromium să pornească singur pe tot ecranul
mkdir -p /config/.config/autostart
cat <<APP > /config/.config/autostart/kiosk.desktop
[Desktop Entry]
Type=Application
Name=HA Kiosk
Exec=sh -c "chromium-browser --kiosk --no-sandbox --touch-events=enabled '$USER_URL' || chromium --kiosk --no-sandbox --touch-events=enabled '$USER_URL'"
StartupNotify=false
Terminal=false
APP

chown -R abc:abc /config/.config || true

echo "--- READY! ---"
EOF

RUN chmod +x /custom-cont-init.d/99-setup-kiosk.sh