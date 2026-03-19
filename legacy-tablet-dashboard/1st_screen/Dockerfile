FROM kasmweb/chromium:1.14.0

USER root
ENV FORCE_REBUILD="v10.0.0"

RUN apt-get update && apt-get install -y jq sudo && rm -rf /var/lib/apt/lists/*
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Deblocăm HTTPS-ul Kasm (Trecem pe HTTP curat)
RUN sed -i 's/-sslOnly//g' /dockerstartup/vnc_startup.sh || true
RUN sed -i 's/require_ssl: true/require_ssl: false/g' /usr/share/kasmvnc/kasmvnc_defaults.yaml || true

# Creăm Extensia Auto-Scroll (Fără descărcări)
RUN mkdir -p /opt/scroll_ext && \
    echo '{"manifest_version": 3, "name": "HA Touch Scroll Auto", "version": "1.0", "content_scripts": [{"matches": ["<all_urls>"], "js": ["content.js"], "all_frames": true}]}' > /opt/scroll_ext/manifest.json && \
    echo 'let isDown=false,startY,startX;window.addEventListener("mousedown",e=>{isDown=true;startY=e.clientY;startX=e.clientX},{passive:true});window.addEventListener("mouseup",()=>isDown=false);window.addEventListener("mouseleave",()=>isDown=false);window.addEventListener("mousemove",e=>{if(!isDown)return;const dy=e.clientY-startY,dx=e.clientX-startX;let el=e.target;while(el&&el!==document){if(el.scrollHeight>el.clientHeight||el.scrollWidth>el.clientWidth){const style=window.getComputedStyle(el);if(style.overflowY==="auto"||style.overflowY==="scroll"||style.overflowY==="overlay"){el.scrollBy(-dx,-dy);startY=e.clientY;startX=e.clientX;return;}}el=el.parentNode;}window.scrollBy(-dx,-dy);startY=e.clientY;startX=e.clientX;});' > /opt/scroll_ext/content.js && \
    chown -R 1000:1000 /opt/scroll_ext && \
    chmod -R 755 /opt/scroll_ext

# RESCRIEM STARTUP-UL OFICIAL KASM PENTRU A PĂSTRA CONTROLUL ABSOLUT
RUN echo '#!/bin/bash\n\
USER_URL=$(sudo jq --raw-output ".url" /data/options.json 2>/dev/null)\n\
if [ -n "$USER_URL" ] && [ "$USER_URL" != "null" ]; then\n\
  export LAUNCH_URL="$USER_URL"\n\
else\n\
  export LAUNCH_URL="http://homeassistant.local:8123"\n\
fi\n\
# Pornim Chromium curat într-o buclă sigură\n\
while true; do\n\
  chromium-browser --no-sandbox --disable-dev-shm-usage --start-maximized --kiosk --touch-events=enabled --load-extension=/opt/scroll_ext "$LAUNCH_URL"\n\
  sleep 2\n\
done\n\
' > /dockerstartup/custom_startup.sh && chmod +x /dockerstartup/custom_startup.sh

ENV VNC_PW="0000"
ENV VNC_USER="kasm_user"
ENV KASM_SVC_AUDIO=0
ENV KASM_SVC_AUDIO_MIC=0
ENV KASM_SVC_GAMEPAD=0
ENV KASM_SVC_PRINTER=0

USER 1000