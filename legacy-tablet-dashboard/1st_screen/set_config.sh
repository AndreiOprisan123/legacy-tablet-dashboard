#!/usr/bin/with-contenv sh
echo "--- Initializing Legacy Tablet Dashboard ---"

# Ne asigurăm că folderul pentru variabilele de mediu există
mkdir -p /var/run/s6/container_environment/

# Citim setările (verifică dacă numele câmpurilor coincid cu config.yaml)
USER_URL=$(jq --raw-output '.url' /data/options.json)
TOUCH=$(jq --raw-output '.touch_optimization' /data/options.json)

# Scriem variabilele în sistemul s6
echo -n "$USER_URL" > /var/run/s6/container_environment/FF_OPEN_URL
echo "Target URL set to: $USER_URL"

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