FROM jlesage/firefox:latest

RUN apk add --no-cache jq

ENV SECURE_CONNECTION=0
ENV KEEP_APP_RUNNING=1
ENV ENABLE_CORS=1

# Creăm scriptul de start folosind metoda Heredoc (sigură pe Mac)
RUN cat <<'EOF' > /etc/cont-init.d/00-set-config.sh
#!/bin/sh
echo "--- CONFIGURING FIREFOX FOR TABLET ---"

# 1. Citim setările din Home Assistant
USER_URL=$(jq --raw-output '.url' /data/options.json)
TOUCH=$(jq --raw-output '.touch_optimization' /data/options.json)

# 2. Setăm URL-ul prin variabila oficială a imaginii jlesage
mkdir -p /var/run/s6/container_environment/
echo -n "$USER_URL" > /var/run/s6/container_environment/FF_OPEN_URL

# 3. Dacă Touch e activat, injectăm setările direct în motorul de preferințe Firefox
if [ "$TOUCH" = "true" ]; then
    echo -n "1" > /var/run/s6/container_environment/MOZ_USE_XINPUT2
    # Acestea sunt variabile speciale citite de scriptul intern al imaginii (56-firefox-set-prefs)
    echo -n "1" > /var/run/s6/container_environment/FF_PREF_DOM_W3C_TOUCH_EVENTS_ENABLED
    echo -n "true" > /var/run/s6/container_environment/FF_PREF_UI_CLICK_HOLD_CONTEXT_MENUS
    echo "Touch Optimization: ENABLED"
else
    echo "Touch Optimization: DISABLED"
fi

echo "Target URL: $USER_URL"
echo "--- CONFIGURATION DONE ---"
EOF

RUN chmod +x /etc/cont-init.d/00-set-config.sh