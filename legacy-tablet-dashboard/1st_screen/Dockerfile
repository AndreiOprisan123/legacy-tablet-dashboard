FROM kasmweb/chromium:1.14.0

USER root
# Creștem versiunea ca să forțăm o instalare complet curată
ENV FORCE_REBUILD="v7.0.0"

# Instalăm 7zip - Extractorul suprem
RUN apt-get update && apt-get install -y jq sudo wget p7zip-full && rm -rf /var/lib/apt/lists/*

# Drepturi absolute pentru a citi din Home Assistant
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Deblocăm HTTPS-ul (Ecranul negru)
RUN sed -i 's/-sslOnly//g' /dockerstartup/vnc_startup.sh || true
RUN sed -i 's/require_ssl: true/require_ssl: false/g' /usr/share/kasmvnc/kasmvnc_defaults.yaml || true

ENV VNC_PW="0000"
ENV VNC_USER="kasm_user"
ENV KASM_SVC_AUDIO=0
ENV KASM_SVC_AUDIO_MIC=0
ENV KASM_SVC_GAMEPAD=0
ENV KASM_SVC_PRINTER=0

# EXTRAGEREA INFAILIBILĂ: Folosim 7z pentru a forța deschiderea extensiei Chrome
RUN mkdir -p /opt/scroll_ext && \
    wget -qO /tmp/ext.crx "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=114.0.0.0&acceptformat=crx2,crx3&x=id%3Djehjnkgnpjofeeigbcjnkdlpoclodnhf%26uc" && \
    7z x /tmp/ext.crx -o/opt/scroll_ext -y || true && \
    chown -R 1000:1000 /opt/scroll_ext && \
    chmod -R 755 /opt/scroll_ext

# Injectăm URL-ul și parametrii blindati pentru Chrome (Kiosk Mode + No Sandbox)
RUN echo '#!/bin/bash\n\
USER_URL=$(sudo jq --raw-output ".url" /data/options.json 2>/dev/null)\n\
if [ -n "$USER_URL" ] && [ "$USER_URL" != "null" ]; then\n\
  export LAUNCH_URL="$USER_URL"\n\
else\n\
  export LAUNCH_URL="http://homeassistant.local:8123"\n\
fi\n\
export CHROME_ARGS="--kiosk --no-sandbox --load-extension=/opt/scroll_ext --touch-events=enabled"\n\
export APP_ARGS="$CHROME_ARGS"\n\
' > /dockerstartup/get_url.sh && chmod +x /dockerstartup/get_url.sh

RUN sed -i '2 i source /dockerstartup/get_url.sh' /dockerstartup/vnc_startup.sh

USER 1000