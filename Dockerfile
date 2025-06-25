FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl gnupg2 software-properties-common apt-transport-https supervisor wget nodejs npm \
    && apt-get clean

# ----------------------------
# Install InfluxDB (v1.8)
# ----------------------------
RUN curl -sL https://repos.influxdata.com/influxdb.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/influxdb.gpg \
    && echo "deb https://repos.influxdata.com/ubuntu jammy stable" | tee /etc/apt/sources.list.d/influxdb.list \
    && apt-get update && apt-get install -y influxdb

# ----------------------------
# Install Grafana
# ----------------------------
RUN wget -q -O - https://packages.grafana.com/gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/grafana.gpg \
    && echo "deb https://packages.grafana.com/oss/deb stable main" > /etc/apt/sources.list.d/grafana.list \
    && apt-get update && apt-get install -y grafana

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
