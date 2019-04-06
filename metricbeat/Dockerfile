ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_ARCH
ARG BUILD_VERSION

# Set shell
#SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Run as root to have full access to /proc
USER root

# run.sh needs jq for parsing options (only for testeing, hassio has this)
RUN apk add --no-cache jq curl

# Install metricbeat
COPY install_metricbeat.sh /tmp/install_metricbeat.sh
RUN sh /tmp/install_metricbeat.sh ${BUILD_ARCH} ${BUILD_VERSION}

# Add metricbeat configuration for docker
COPY metricbeat.docker.yml /etc/metricbeat/metricbeat.yml

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
