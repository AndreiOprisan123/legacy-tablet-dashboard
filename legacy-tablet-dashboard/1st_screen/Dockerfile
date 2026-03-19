FROM lscr.io/linuxserver/webtop:ubuntu-xfce

RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

ENV PUID=1000
ENV PGID=1000
ENV TZ=Europe/Bucharest

RUN mkdir -p /custom-cont-init.d && \
    cat <<'EOF' > /custom-cont-init.d/99-setup-kiosk.sh
#!/bin/bash
echo "--- PREPARING FLUID DASHBOARD ---"

# PATCH SUPREM KASMVNC: Căutăm în toate fișierele și forțăm recunoașterea HTTP-ului
find /usr/share/kasmvnc/www -type f \( -name "*.html" -o -name "*.js" \) -exec sed -i 's/window.isSecureContext/true/g' {} + || true

# Citim URL-ul setat în Home Assistant
USER_URL=$(jq --raw-output '.url' /data/options.json)
if [ -z "$USER_URL" ] || [ "$USER_URL" == "null" ]; then
    USER_URL="http://homeassistant.local:8123"
fi

# Autostart Chromium direct pe URL-ul utilizatorului
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