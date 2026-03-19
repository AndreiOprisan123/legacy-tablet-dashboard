#!/bin/sh
echo "--- Initializing Legacy Tablet Dashboard ---"

USER_URL=$(jq --raw-output '.url' /data/options.json)
TOUCH=$(jq --raw-output '.touch_optimization' /data/options.json)

echo "$USER_URL" > /var/run/s6/container_environment/FF_OPEN_URL

if [ "$TOUCH" = "true" ]; then
    # Activează suportul de gesturi în Firefox
    echo "1" > /var/run/s6/container_environment/MOZ_USE_XINPUT2
    # Forțează Firefox să ignore mouse-ul și să asculte doar de touch
    echo "1" > /var/run/s6/container_environment/MOZ_TOUCH_WIDGET_DRAG
    # Spunem serverului VNC că avem un ecran tactil
    echo "1" > /var/run/s6/container_environment/VNC_TOUCH_DEVICE
    
    echo "Touch Optimization: ENABLED (Natural Scroll)"
else
    echo "0" > /var/run/s6/container_environment/MOZ_USE_XINPUT2
    echo "0" > /var/run/s6/container_environment/MOZ_TOUCH_WIDGET_DRAG
    echo "0" > /var/run/s6/container_environment/VNC_TOUCH_DEVICE
    echo "Touch Optimization: DISABLED"
fi

echo "--- Initialization Complete ---"