FROM jlesage/firefox:latest

RUN apk add --no-cache jq

ENV SECURE_CONNECTION=0
ENV KEEP_APP_RUNNING=1
ENV ENABLE_CORS=1

RUN cat <<'EOF' > /etc/cont-init.d/00-set-config.sh
#!/bin/sh
echo "--- FORCING ONE-FINGER SCROLL ENGINE ---"

USER_URL=$(jq --raw-output '.url' /data/options.json)

POLICIES_DIR="/usr/lib/firefox/distribution"
mkdir -p $POLICIES_DIR

cat <<P_EOF > $POLICIES_DIR/policies.json
{
  "policies": {
    "OverrideFirstRunPage": "$USER_URL",
    "Homepage": { "URL": "$USER_URL", "Locked": true },
    "Preferences": {
      "dom.w3c_touch_events.enabled": 1,
      "dom.w3c_touch_events.legacy_apis.enabled": true,
      "apz.drag.touch.enabled": true,
      "apz.touch_start_tolerance": 0,
      "ui.click_hold_context_menus": true,
      "apz.allow_zooming": false,
      "security.mixed_content.block_active_content": false,
      "browser.tabs.warnOnClose": false
    }
  }
}
P_EOF

# Setări la nivel de sistem Docker (pentru noVNC bridge)
mkdir -p /var/run/s6/container_environment/
echo -n "1" > /var/run/s6/container_environment/VNC_TOUCH_DEVICE
echo -n "1" > /var/run/s6/container_environment/MOZ_USE_XINPUT2

echo "Settings applied. URL: $USER_URL"
echo "--- DONE ---"
EOF

RUN chmod +x /etc/cont-init.d/00-set-config.sh