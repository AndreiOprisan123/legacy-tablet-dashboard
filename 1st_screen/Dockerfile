FROM jlesage/firefox:latest

# Install jq to parse Home Assistant options
RUN apk add --no-cache jq

# Default environment settings for the VNC server
ENV SECURE_CONNECTION=0
ENV KEEP_APP_RUNNING=1
ENV ENABLE_CORS=1

# Copy the initialization script
COPY set_config.sh /etc/cont-init.d/00-set-config.sh
RUN chmod a+x /etc/cont-init.d/00-set-config.sh