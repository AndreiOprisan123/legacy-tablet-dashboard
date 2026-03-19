FROM jlesage/firefox:latest

RUN apk add --no-cache jq

ENV SECURE_CONNECTION=0
ENV KEEP_APP_RUNNING=1
ENV ENABLE_CORS=1

# Creăm scriptul care generează POLITICA Firefox
RUN cat <<'EOF' > /etc/cont-init.d/00-set-config.sh
#!/bin/sh
echo "--- APPLYING MASTER POLICIES ---"

USER_URL=$(jq --raw-output '.url' /data/options.json)
TOUCH=$(jq --raw-output '.touch_optimization' /data/options.json)

# Creăm folderul de politici
POLICIES_DIR="/usr/lib/firefox/distribution"
mkdir -p $POLICIES_DIR

# Generăm fișierul de politici care forțează URL-ul și setările de Touch
cat <<P_EOF > $POLICIES_DIR/policies.json
{
  "policies": {
    "Homepage": {
      "URL": "$USER_URL",
      "Locked": true,
      "StartPage": "homepage"
    },
    "Preferences": {
      "dom.w3c_touch_events.enabled": 1,
      "apz.drag.touch.enabled": true,
      "apz.allow_zooming": false,
      "ui.click_hold_context_menus": true,
      "security.mixed_content.block_active_content": false,
      "browser.tabs.warnOnClose": false
    }
  }
}
P_EOF

# Setăm și variabila de sistem pentru orice eventualitate
mkdir -p /var/run/s6/container_environment/
echo -n "1" > /var/run/s6/container_environment/MOZ_USE_XINPUT2

echo "Master Policy applied: URL set to $USER_URL"
echo "--- DONE ---"
EOF

RUN chmod +x /etc/cont-init.d/00-set-config.sh