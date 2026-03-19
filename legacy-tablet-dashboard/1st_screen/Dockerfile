FROM kasmweb/chromium:1.14.0

USER root
# Această linie forțează Docker să construiască totul de la zero!
ENV FORCE_REBUILD="v4.0.0"

# Instalăm JQ, Sudo, Wget și Unzip
RUN apt-get update && apt-get install -y jq sudo wget unzip && rm -rf /var/lib/apt/lists/*

# Spargem SSL-ul Kasm
RUN sed -i 's/-sslOnly//g' /dockerstartup/vnc_startup.sh || true
RUN sed -i 's/require_ssl: true/require_ssl: false/g' /usr/share/kasmvnc/kasmvnc_defaults.yaml || true

# SIDELOADING CURAT: Descărcăm și extragem extensia local
RUN mkdir -p /opt/scroll_ext && \
    wget -qO /tmp/scroll.zip "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=114.0.0.0&acceptformat=crx2,crx3&x=id%3Djehjnkgnpjofeeigbcjnkdlpoclodnhf%26uc" && \
    unzip -q /tmp/scroll.zip -d /opt/scroll_ext || true && \
    rm -rf /opt/scroll_ext/_metadata || true

ENV VNC_PW="0000"
ENV VNC_USER="kasm_user"
ENV KASM_SVC_AUDIO=0
ENV KASM_SVC_AUDIO_MIC=0
ENV KASM_SVC_GAMEPAD=0
ENV KASM_SVC_PRINTER=0

# Scriptul magic de start
RUN echo '#!/bin/bash\n\
USER_URL=$(sudo jq --raw-output ".url" /data/options.json 2>/dev/null)\n\
if [ -n "$USER_URL" ] && [ "$USER_URL" != "null" ]; then\n\
  export LAUNCH_URL="$USER_URL"\n\
else\n\
  export LAUNCH_URL="http://homeassistant.local:8123"\n\
fi\n\
# Forțăm extensia de pe disc\n\
export CHROME_ARGS="--load-extension=/opt/scroll_ext --touch-events=enabled"\n\
' > /dockerstartup/get_url.sh && chmod +x /dockerstartup/get_url.sh

RUN sed -i '2 i source /dockerstartup/get_url.sh' /dockerstartup/vnc_startup.sh

USER 1000