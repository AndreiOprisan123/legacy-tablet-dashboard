FROM kasmweb/chromium:1.14.0

USER root
ENV FORCE_REBUILD="v9.0.0"

RUN apt-get update && apt-get install -y jq sudo && rm -rf /var/lib/apt/lists/*

# Drepturi pentru a citi din Home Assistant
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Deblocăm HTTPS-ul Kasm
RUN sed -i 's/-sslOnly//g' /dockerstartup/vnc_startup.sh || true
RUN sed -i 's/require_ssl: true/require_ssl: false/g' /usr/share/kasmvnc/kasmvnc_defaults.yaml || true

ENV VNC_PW="0000"
ENV VNC_USER="kasm_user"
ENV KASM_SVC_AUDIO=0
ENV KASM_SVC_AUDIO_MIC=0
ENV KASM_SVC_GAMEPAD=0
ENV KASM_SVC_PRINTER=0

# 1. Creăm Extensia noastră Auto-Scroll (Fără erori de VS Code)
RUN mkdir -p /opt/scroll_ext && \
    echo '{"manifest_version": 3, "name": "HA Touch Scroll Auto", "version": "1.0", "content_scripts": [{"matches": ["<all_urls>"], "js": ["content.js"], "all_frames": true}]}' > /opt/scroll_ext/manifest.json && \
    echo 'let isDown=false,startY,startX;window.addEventListener("mousedown",e=>{isDown=true;startY=e.clientY;startX=e.clientX},{passive:true});window.addEventListener("mouseup",()=>isDown=false);window.addEventListener("mouseleave",()=>isDown=false);window.addEventListener("mousemove",e=>{if(!isDown)return;const dy=e.clientY-startY,dx=e.clientX-startX;let el=e.target;while(el&&el!==document){if(el.scrollHeight>el.clientHeight||el.scrollWidth>el.clientWidth){const style=window.getComputedStyle(el);if(style.overflowY==="auto"||style.overflowY==="scroll"||style.overflowY==="overlay"){el.scrollBy(-dx,-dy);startY=e.clientY;startX=e.clientX;return;}}el=el.parentNode;}window.scrollBy(-dx,-dy);startY=e.clientY;startX=e.clientX;});' > /opt/scroll_ext/content.js && \
    chown -R 1000:1000 /opt/scroll_ext && \
    chmod -R 755 /opt/scroll_ext

# 2. BODYGUARD-UL: Deturnăm executabilul oficial Chromium
RUN mv /usr/bin/chromium-browser /usr/bin/chromium-browser-orig && \
    printf '#!/bin/bash\nexec /usr/bin/chromium-browser-orig --load-extension=/opt/scroll_ext --touch-events=enabled --start-maximized "$@"\n' > /usr/bin/chromium-browser && \
    chmod +x /usr/bin/chromium-browser

# (Extra siguranță în caz că sistemul folosește comanda scurtă "chromium")
RUN if [ -f /usr/bin/chromium ]; then \
        mv /usr/bin/chromium /usr/bin/chromium-orig && \
        printf '#!/bin/bash\nexec /usr/bin/chromium-orig --load-extension=/opt/scroll_ext --touch-events=enabled --start-maximized "$@"\n' > /usr/bin/chromium && \
        chmod +x /usr/bin/chromium; \
    fi

# 3. Injectăm URL-ul din HA
RUN printf '#!/bin/bash\nUSER_URL=$(sudo jq --raw-output ".url" /data/options.json 2>/dev/null)\nif [ -n "$USER_URL" ] && [ "$USER_URL" != "null" ]; then\n  export LAUNCH_URL="$USER_URL"\nelse\n  export LAUNCH_URL="http://homeassistant.local:8123"\nfi\n' > /dockerstartup/get_url.sh && chmod +x /dockerstartup/get_url.sh

RUN sed -i '2 i source /dockerstartup/get_url.sh' /dockerstartup/vnc_startup.sh

USER 1000