FROM kasmweb/chromium:1.14.0

# Devenim Root pentru instalare
USER root

# Instalăm JQ și Sudo
RUN apt-get update && apt-get install -y jq sudo && rm -rf /var/lib/apt/lists/*

# 1. Spargem SSL-ul
RUN sed -i 's/-sslOnly//g' /dockerstartup/vnc_startup.sh || true
RUN sed -i 's/require_ssl: true/require_ssl: false/g' /usr/share/kasmvnc/kasmvnc_defaults.yaml || true

# 2. Forțăm Extensia "Scroll Anywhere" multiplicând regula în toate folderele cunoscute
RUN mkdir -p /etc/chromium/policies/managed/ /etc/chromium-browser/policies/managed/ && \
    echo '{ "ExtensionInstallForcelist": ["jehjnkgnpjofeeigbcjnkdlpoclodnhf;https://clients2.google.com/service/update2/crx"] }' > /etc/chromium/policies/managed/extensions.json && \
    cp /etc/chromium/policies/managed/extensions.json /etc/chromium-browser/policies/managed/extensions.json

ENV VNC_PW="0000"
ENV VNC_USER="kasm_user"

# Oprim procesele care mănâncă resurse
ENV KASM_SVC_AUDIO=0
ENV KASM_SVC_AUDIO_MIC=0
ENV KASM_SVC_GAMEPAD=0
ENV KASM_SVC_PRINTER=0

# 3. Noul Script de citire URL (Folosim SUDO ca să trecem de securitatea Home Assistant)
RUN echo '#!/bin/bash\n\
USER_URL=$(sudo jq --raw-output ".url" /data/options.json 2>/dev/null)\n\
if [ -n "$USER_URL" ] && [ "$USER_URL" != "null" ]; then\n\
  export LAUNCH_URL="$USER_URL"\n\
else\n\
  export LAUNCH_URL="http://homeassistant.local:8123"\n\
fi\n\
' > /dockerstartup/get_url.sh && chmod +x /dockerstartup/get_url.sh

# Îl lipim la începutul startup-ului Kasm
RUN sed -i '2 i source /dockerstartup/get_url.sh' /dockerstartup/vnc_startup.sh

# Kasm ne cere să ne întoarcem la Utilizatorul 1000 pentru siguranță
USER 1000