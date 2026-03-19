#!/bin/sh
echo "--- Initializing Legacy Tablet Dashboard ---"

# Read user options from Home Assistant
USER_URL=$(jq --raw-output '.url' /data/options.json)
TOUCH=$(jq --raw-output '.touch_optimization' /data/options.json)

# Apply the URL to Firefox
echo "$USER_URL" > /var/run/s6/container_environment/FF_OPEN_URL
echo "Target URL set to: $USER_URL"

# Apply Touch Optimization (Smooth scrolling for fingers)
if [ "$TOUCH" = "true" ]; then
    echo "1" > /var/run/s6/container_environment/MOZ_USE_XINPUT2
    echo "Touch Optimization: ENABLED (Gesture mode)"
else
    echo "0" > /var/run/s6/container_environment/MOZ_USE_XINPUT2
    echo "Touch Optimization: DISABLED (Mouse mode)"
fi

echo "--- Initialization Complete ---"