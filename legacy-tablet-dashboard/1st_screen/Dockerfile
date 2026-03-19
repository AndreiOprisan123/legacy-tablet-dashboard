FROM kasmweb/chromium:1.14.0

# Trecem pe root ca să putem sparge fișierele de sistem Kasm
USER root

RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

# HACK 1: Ștergem flag-ul -sslOnly din scriptul de startup Kasm (cum a zis mmcclaskey)
RUN sed -i 's/-sslOnly//g' /dockerstartup/vnc_startup.sh || true

# HACK 2: Modificăm fișierul de configurare KasmVNC (cum au zis ahkimkoo și fliot)
RUN sed -i 's/require_ssl: true/require_ssl: false/g' /usr/share/kasmvnc/kasmvnc_defaults.yaml || true

# Scriptul nostru normal de autostart pentru Home Assistant
RUN echo '#!/bin/bash\n\
echo "--- PREPARING UNLOCKED KASM DASHBOARD ---"\n\
\n\
# Citim URL-ul\n\
USER_URL=$(jq --raw-output ".url" /data/options.json 2>/dev/null)\n\
if [ -n "$USER_URL" ] && [ "$USER_URL" != "null" ]; then\n\
    export LAUNCH_URL="$USER_URL"\n\
else\n\
    export LAUNCH_URL="http://homeassistant.local:8123"\n\
fi\n\
echo "Kiosk URL is: $LAUNCH_URL"\n\
\n\
# Oprim serviciile care consumă resurse degeaba\n\
export KASM_SVC_AUDIO=0\n\
export KASM_SVC_AUDIO_MIC=0\n\
export KASM_SVC_GAMEPAD=0\n\
export KASM_SVC_PRINTER=0\n\
\n\
# Setăm parola\n\
export VNC_PW="0000"\n\
' > /dockerstartup/custom_startup.sh

RUN chmod +x /dockerstartup/custom_startup.sh

# Kasm ne obligă să ne întoarcem la un user normal pentru a rula corect
USER 1000