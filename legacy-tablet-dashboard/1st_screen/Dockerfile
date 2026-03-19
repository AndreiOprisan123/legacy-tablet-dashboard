FROM kasmweb/chromium:1.14.0

USER root
# Pilula care forțează reconstrucția completă
ENV FORCE_REBUILD="v5.0.0"

# Instalăm tot ce ne trebuie, inclusiv Python3
RUN apt-get update && apt-get install -y jq sudo wget unzip python3 && rm -rf /var/lib/apt/lists/*

# 1. Drepturi absolute pentru a citi din Home Assistant (fără parolă)
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# 2. Spargem blocajul SSL și ecranul negru
RUN sed -i 's/-sslOnly//g' /dockerstartup/vnc_startup.sh || true
RUN sed -i 's/require_ssl: true/require_ssl: false/g' /usr/share/kasmvnc/kasmvnc_defaults.yaml || true

ENV VNC_PW="0000"
ENV VNC_USER="kasm_user"
ENV KASM_SVC_AUDIO=0
ENV KASM_SVC_AUDIO_MIC=0
ENV KASM_SVC_GAMEPAD=0
ENV KASM_SVC_PRINTER=0

# 3. CHIRURGIE PE EXTENSIE: Descărcăm CRX, tăiem header-ul cu Python, extragem ZIP-ul
RUN mkdir -p /opt/scroll_ext && \
    wget -qO /tmp/ext.crx "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=114.0.0.0&acceptformat=crx2,crx3&x=id%3Djehjnkgnpjofeeigbcjnkdlpoclodnhf%26uc" && \
    python3 -c "data=open('/tmp/ext.crx','rb').read(); idx=data.find(b'PK\x03\x04'); open('/tmp/ext.zip','wb').write(data[idx:]) if idx != -1 else exit(1)" && \
    unzip -q /tmp/ext.zip -d /opt/scroll_ext && \
    rm -rf /opt/scroll_ext/_metadata || true

# 4. DETURNAREA EXECUTABILULUI: Garantăm 100% că Chromium pornește cu extensia
RUN for bin in chromium chromium-browser google-chrome; do \
      if [ -f "/usr/bin/$bin" ]; then \
        mv "/usr/bin/$bin" "/usr/bin/${bin}-orig"; \
        echo '#!/bin/bash' > "/usr/bin/$bin"; \
        echo "exec /usr/bin/${bin}-orig --load-extension=/opt/scroll_ext --touch-events=enabled \"\$@\"" >> "/usr/bin/$bin"; \
        chmod +x "/usr/bin/$bin"; \
      fi; \
    done

# 5. Citim URL-ul tău real și îl lansăm
RUN echo '#!/bin/bash\n\
USER_URL=$(sudo jq --raw-output ".url" /data/options.json 2>/dev/null)\n\
if [ -n "$USER_URL" ] && [ "$USER_URL" != "null" ]; then\n\
  export LAUNCH_URL="$USER_URL"\n\
else\n\
  export LAUNCH_URL="http://homeassistant.local:8123"\n\
fi\n\
' > /dockerstartup/get_url.sh && chmod +x /dockerstartup/get_url.sh

RUN sed -i '2 i source /dockerstartup/get_url.sh' /dockerstartup/vnc_startup.sh

USER 1000