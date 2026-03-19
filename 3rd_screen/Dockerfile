FROM jlesage/firefox:latest

RUN apk add --no-cache jq

ENV SECURE_CONNECTION=0
ENV KEEP_APP_RUNNING=1
ENV ENABLE_CORS=1

COPY set_config.sh /etc/cont-init.d/00-set-config.sh
RUN chmod a+x /etc/cont-init.d/00-set-config.sh