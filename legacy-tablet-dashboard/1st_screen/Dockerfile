FROM lscr.io/linuxserver/webtop:alpine-xfce

# Setăm mediul
ENV PUID=1000
ENV PGID=1000
ENV TZ=Europe/Bucharest

# Cream un script care rulează automat la pornirea add-on-ului
# Acest script "operează" codul sursă KasmVNC și șterge blocajul HTTP
RUN mkdir -p /custom-cont-init.d && \
    cat <<'EOF' > /custom-cont-init.d/99-patch-kasmvnc.sh
#!/bin/bash
echo "--- PATCHING KASMVNC TO ALLOW HTTP ---"

# Căutăm fișierul principal și înlocuim condiția care generează ecranul negru
# Practic schimbăm "Dacă nu e securizat" cu "Dacă 1 == 2" (o condiție imposibilă)
sed -i 's/window.isSecureContext === false/1 == 2/g' /usr/share/kasmvnc/www/index.html || true
sed -i 's/window.isSecureContext===false/1==2/g' /usr/share/kasmvnc/www/index.html || true

echo "--- PATCH COMPLETE ---"
EOF

# Îi dăm drepturi de execuție scriptului nostru de bypass
RUN chmod +x /custom-cont-init.d/99-patch-kasmvnc.sh