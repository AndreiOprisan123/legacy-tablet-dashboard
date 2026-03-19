FROM kasmweb/chromium:1.14.0

USER root

# Instalăm JQ pentru a citi din HA
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

# 1. Spargem SSL-ul și blocajul HTTPS
RUN sed -i 's/-sslOnly//g' /dockerstartup/vnc_startup.sh || true
RUN sed -i 's/require_ssl: true/require_ssl: false/g' /usr/share/kasmvnc/kasmvnc_defaults.yaml || true

# 2. Setăm parola CORECT (o citește serverul la boot)
ENV VNC_PW="0000"
ENV VNC_USER="kasm_user"

# 3. Injectăm codul care citește URL-ul tău din HA direct în inima Kasm-ului
RUN echo '#!/bin/bash\n\
USER_URL=$(jq --raw-output ".url" /data/options.json 2>/dev/null)\n\
if [ -n "$USER_URL" ] && [ "$USER_URL" != "null" ]; then\n\
  export LAUNCH_URL="$USER_URL"\n\
else\n\
  export LAUNCH_URL="http://homeassistant.local:8123"\n\
fi' > /dockerstartup/get_url.sh && chmod +x /dockerstartup/get_url.sh

# Îl facem să ruleze înainte de orice altceva
RUN sed -i '2 i source /dockerstartup/get_url.sh' /dockerstartup/vnc_startup.sh

# Ne întoarcem la utilizatorul normal
USER 1000