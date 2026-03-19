#!/bin/sh
echo "Citim setările din Home Assistant..."

# Citim URL-ul și toggle-ul de touch
USER_URL=$(jq --raw-output '.url' /data/options.json)
TOUCH=$(jq --raw-output '.optimizare_touch' /data/options.json)

# Setăm pagina de start (poate fi HA, YouTube, etc.)
echo "$USER_URL" > /var/run/s6/container_environment/FF_OPEN_URL
echo "URL setat la: $USER_URL"

# Setăm optimizarea pentru touchscreen
if [ "$TOUCH" = "true" ]; then
    echo "1" > /var/run/s6/container_environment/MOZ_USE_XINPUT2
    echo "Optimizare Touch (Gesturi) -> ACTIVATĂ"
else
    echo "0" > /var/run/s6/container_environment/MOZ_USE_XINPUT2
    echo "Optimizare Touch (Gesturi) -> DEZACTIVATĂ (Mod Mouse)"
fi