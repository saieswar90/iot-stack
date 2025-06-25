FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl gnupg2 software-properties-common \
    supervisor wget nodejs npm apt-transport-https \
    influxdb grafana \
    && apt-get clean

# Install Node-RED
RUN npm install -g --unsafe-perm node-red

# Create volumes
RUN mkdir -p /data/nodered /data/influxdb /data/grafana /var/log/supervisor

# Add supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports
EXPOSE 1880 8086 3000

# Start all services
CMD ["/usr/bin/supervisord"]
