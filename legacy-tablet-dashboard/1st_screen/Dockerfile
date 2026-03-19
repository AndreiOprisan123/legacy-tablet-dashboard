FROM kasmweb/chromium:1.14.0

USER root

# Instalăm JQ, Sudo, Wget și Unzip (Pentru Sideloading)
RUN apt-get update && apt-get install -y jq sudo wget unzip && rm -rf /var/lib/apt/lists/*

# 1. Spargem SSL-ul (Rămâne neschimbat, că merge perfect)
RUN sed -i 's/-sslOnly//g' /dockerstartup/vnc_startup.sh || true
RUN sed -i 's/require_ssl: true/require_ssl: false/g' /usr/share/kasmvnc/kasmvnc_defaults.yaml || true

# 2. SIDELOADING: Furăm extensia și o punem local în folderul /opt/scroll_ext
RUN mkdir -p /opt/scroll_ext && \
    wget -qO /tmp/scroll.crx "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=114.0.0.0&acceptformat=crx2,crx3&x=id%3Djehjnkgnpjofeeigbcjnkdlpoclodnhf%26uc" && \
    unzip -q /tmp/scroll.crx -d /opt/scroll_ext || true && \
    rm -rf /opt/scroll_ext/_metadata || true

ENV VNC_PW="0000"
ENV VNC_USER="kasm_user"

# Oprim procesele care mănâncă resurse
ENV KASM_SVC_AUDIO=0
ENV KASM_SVC_AUDIO_MIC=0
ENV KASM_SVC_GAMEPAD=0
ENV KASM_SVC_PRINTER=0

# 3. Injectăm URL-ul și forțăm extensia locală la pornire
RUN echo '#!/bin/bash\n\
USER_URL=$(sudo jq --raw-output ".url" /data/options.json 2>/dev/null)\n\
if [ -n "$USER_URL" ] && [ "$USER_URL" != "null" ]; then\n\
  export LAUNCH_URL="$USER_URL"\n\
else\n\
  export LAUNCH_URL="http://homeassistant.local:8123"\n\
fi\n\
# Aici este magia: forțăm browserul să pornească cu extensia gata încărcată de pe disc\n\
export CHROME_ARGS="--load-extension=/opt/scroll_ext --touch-events=enabled"\n\
' > /dockerstartup/get_url.sh && chmod +x /dockerstartup/get_url.sh

# Îl lipim la începutul startup-ului Kasm
RUN sed -i '2 i source /dockerstartup/get_url.sh' /dockerstartup/vnc_startup.sh

USER 1000