FROM jlesage/firefox:latest

RUN apk add --no-cache jq

ENV SECURE_CONNECTION=0
ENV KEEP_APP_RUNNING=1
ENV ENABLE_CORS=1

RUN cat <<'EOF' > /etc/cont-init.d/00-set-config.sh
#!/bin/sh
echo "--- APPLYING ULTIMATE FORCED POLICIES ---"

USER_URL=$(jq --raw-output '.url' /data/options.json)
TOUCH=$(jq --raw-output '.touch_optimization' /data/options.json)

POLICIES_DIR="/usr/lib/firefox/distribution"
mkdir -p $POLICIES_DIR

# Generăm fișierul de politici care DISTRUGE ecranul de bun venit
cat <<P_EOF > $POLICIES_DIR/policies.json
{
  "policies": {
    "DisableFirefoxAccounts": true,
    "DisablePocket": true,
    "DisableTelemetry": true,
    "OverrideFirstRunPage": "$USER_URL",
    "OverridePostUpdatePage": "$USER_URL",
    "DontCheckDefaultBrowser": true,
    "UserMessaging": {
        "WhatsNew": false,
        "ExtensionRecommendations": false,
        "FeatureRecommendations": false,
        "UrlbarInterventions": false,
        "SkipOnboarding": true,
        "MoreFromMozilla": false
    },
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
      "browser.tabs.warnOnClose": false,
      "browser.aboutwelcome.enabled": false,
      "browser.shell.checkDefaultBrowser": false
    }
  }
}
P_EOF

# Setăm variabila de mediu pentru noVNC și Firefox
mkdir -p /var/run/s6/container_environment/
echo -n "$USER_URL" > /var/run/s6/container_environment/FF_OPEN_URL
echo -n "1" > /var/run/s6/container_environment/MOZ_USE_XINPUT2

echo "Policies applied. Welcome screen disabled. URL: $USER_URL"
echo "--- DONE ---"
EOF

RUN chmod +x /etc/cont-init.d/00-set-config.sh