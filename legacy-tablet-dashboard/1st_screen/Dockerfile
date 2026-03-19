FROM jlesage/firefox:latest

# Instalăm jq și dos2unix pentru curățarea fișierelor
RUN apk add --no-cache jq dos2unix

ENV SECURE_CONNECTION=0
ENV KEEP_APP_RUNNING=1
ENV ENABLE_CORS=1

COPY set_config.sh /etc/cont-init.d/00-set-config.sh

# Forțăm formatul Linux și permisiunile
RUN dos2unix /etc/cont-init.d/00-set-config.sh && \
    chmod +x /etc/cont-init.d/00-set-config.sh