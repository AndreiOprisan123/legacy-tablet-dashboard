FROM kasmweb/chromium:1.14.0

USER root
ENV FORCE_REBUILD="v6.0.0"

# Instalăm dependențele necesare
RUN apt-get update && apt-get install -y jq sudo wget unzip python3 && rm -rf /var/lib/apt/lists/*

# Drepturi pentru a citi din Home Assistant
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Deblocăm HTTPS-ul forțat
RUN sed -i 's/-sslOnly//g' /dockerstartup/vnc_startup.sh || true
RUN sed -i 's/require_ssl: true/require_ssl: false/g' /usr/share/kasmvnc/kasmvnc_defaults.yaml || true

ENV VNC_PW="0000"
ENV VNC_USER="kasm_user"
ENV KASM_SVC_AUDIO=0
ENV KASM_SVC_AUDIO_MIC=0
ENV KASM_SVC_GAMEPAD=0
ENV KASM_SVC_PRINTER=0

# Pregătim extensia (descărcare + curățare) și ne asigurăm că User-ul 1000 are drepturi pe ea
RUN mkdir -p /opt/scroll_ext && \
    wget -qO /tmp/ext.crx "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=114.0.0.0&acceptformat=crx2,crx3&x=id%3Djehjnkgnpjofeeigbcjnkdlpoclodnhf%26uc" && \
    python3 -c "data=open('/tmp/ext.crx','rb').read(); idx=data.find(b'PK\x03\x04'); open('/tmp/ext.zip','wb').write(data[idx:]) if idx != -1 else exit(1)" && \
    unzip -q /tmp/ext.zip -d /opt/scroll_ext || true && \
    chown -R 1000:1000 /opt/scroll_ext && \
    chmod -R 755 /opt/scroll_ext

# Citim URL-ul și injectăm setările pentru Chrome prin variabilele oficiale Kasm
RUN echo '#!/bin/bash\n\
USER_URL=$(sudo jq --raw-output ".url" /data/options.json 2>/dev/null)\n\
if [ -n "$USER_URL" ] && [ "$USER_URL" != "null" ]; then\n\
  export LAUNCH_URL="$USER_URL"\n\
else\n\
  export LAUNCH_URL="http://homeassistant.local:8123"\n\
fi\n\
export CHROME_ARGS="--load-extension=/opt/scroll_ext --touch-events=enabled"\n\
export APP_ARGS="--load-extension=/opt/scroll_ext --touch-events=enabled"\n\
' > /dockerstartup/get_url.sh && chmod +x /dockerstartup/get_url.sh

# Lipim scriptul la inițializare
RUN sed -i '2 i source /dockerstartup/get_url.sh' /dockerstartup/vnc_startup.sh

USER 1000