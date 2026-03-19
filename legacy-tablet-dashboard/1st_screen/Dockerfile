FROM jlesage/firefox:latest

# Instalăm jq pentru a citi setările din HA
RUN apk add --no-cache jq

# Setări de bază pentru interfață
ENV SECURE_CONNECTION=0
ENV KEEP_APP_RUNNING=1
ENV ENABLE_CORS=1

# Generăm scriptul direct în container (Asta ocolește orice eroare de Mac/Windows)
RUN printf '#!/bin/sh\n\
echo "--- Initializing Legacy Tablet Dashboard ---"\n\
mkdir -p /var/run/s6/container_environment/\n\
USER_URL=$(jq --raw-output ".url" /data/options.json)\n\
TOUCH=$(jq --raw-output ".touch_optimization" /data/options.json)\n\
echo -n "$USER_URL" > /var/run/s6/container_environment/FF_OPEN_URL\n\
echo "Target URL set to: $USER_URL"\n\
if [ "$TOUCH" = "true" ]; then\n\
    echo -n "1" > /var/run/s6/container_environment/MOZ_USE_XINPUT2\n\
    echo -n "1" > /var/run/s6/container_environment/MOZ_TOUCH_WIDGET_DRAG\n\
    echo "Touch Optimization: ENABLED"\n\
else\n\
    echo -n "0" > /var/run/s6/container_environment/MOZ_USE_XINPUT2\n\
    echo -n "0" > /var/run/s6/container_environment/MOZ_TOUCH_WIDGET_DRAG\n\
    echo "Touch Optimization: DISABLED"\n\
fi\n\
echo "--- Initialization Complete ---"\n' > /etc/cont-init.d/00-set-config.sh

# Îi dăm drepturi de execuție
RUN chmod +x /etc/cont-init.d/00-set-config.sh