#!/bin/sh
echo "--- Initializing Legacy Tablet Dashboard ---"

# Creăm folderul dacă nu există
mkdir -p /var/run/s6/container_environment/

# Citim URL-ul și scoatem orice ghilimele sau spații extra
USER_URL=$(jq --raw-output '.url' /data/options.json | tr -d '\r')
TOUCH=$(jq --raw-output '.touch_optimization' /data/options.json | tr -d '\r')

# Scriem URL-ul (folosim -n pentru a nu adăuga newline la finalul fișierului)
echo -n "$USER_URL" > /var/run/s6/container_environment/FF_OPEN_URL
echo "Target URL set to: $USER_URL"

# Setăm touch optimization
if [ "$TOUCH" = "true" ]; then
    echo -n "1" > /var/run/s6/container_environment/MOZ_USE_XINPUT2
    echo -n "1" > /var/run/s6/container_environment/MOZ_TOUCH_WIDGET_DRAG
    echo "Touch Optimization: ENABLED"
else
    echo -n "0" > /var/run/s6/container_environment/MOZ_USE_XINPUT2
    echo -n "0" > /var/run/s6/container_environment/MOZ_TOUCH_WIDGET_DRAG
    echo "Touch Optimization: DISABLED"
fi

echo "--- Initialization Complete ---"