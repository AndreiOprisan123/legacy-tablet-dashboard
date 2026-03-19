FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# Instalam JQ
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

# Setăm mediul
ENV PUID=1000
ENV PGID=1000
ENV TZ=Europe/Bucharest

# FORȚĂM containerul să folosească KasmVNC în loc de interfața nativă (Selkies/WebRTC)
ENV WEBTOP_CUSTOM_START="true"
ENV CUSTOM_PORT="3000"
# Setari specifice KasmVNC care permit HTTP
ENV KASMVNC_ALLOW_HTTP="true"
ENV VNCOPTIONS="-AllowHttp=true"

RUN mkdir -p /custom-cont-init.d && \
    cat <<'EOF' > /custom-cont-init.d/99-setup-kiosk.sh
#!/bin/bash
echo "--- PREPARING FLUID DASHBOARD ---"

# PATCH KASMVNC (În caz că totuși încarcă interfața Kasm)
find /usr/share/kasmvnc/www -type f \( -name "*.html" -o -name "*.js" \) -exec sed -i 's/window.isSecureContext/true/g' {} + || true

# Alternativă: Daca foloseste interfața nouă, incercăm să eliminăm blocajul din fișierele JS din /app/www
if [ -d "/app/www" ]; then
    echo "Paching Selkies UI..."
    find /app/www -type f -name "*.js" -exec sed -i 's/isSecureContext/true/g' {} + || true
fi

# Citim URL-ul
USER_URL=$(jq --raw-output '.url' /data/options.json)
if [ -z "$USER_URL" ] || [ "$USER_URL" == "null" ]; then
    USER_URL="http://homeassistant.local:8123"
fi

# Autostart Chromium
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