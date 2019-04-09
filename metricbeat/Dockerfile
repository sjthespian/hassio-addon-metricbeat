ARG BUILD_FROM=hassioaddons/ubuntu-base:3.0.0
FROM ${BUILD_FROM}

# Args for arch and version that we can pass to the metricbeat installer
ARG BUILD_ARCH
ARG BUILD_VERSION
ARG BUILD_DATE
ARG BUILD_REF

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Run as root to have full access to /proc
USER root

## The installer needs xz to extract ArchLinux package
RUN apt-get update && apt-get -y install xz-utils

# Install metricbeat
COPY install_metricbeat.sh /tmp/install_metricbeat.sh
RUN sh /tmp/install_metricbeat.sh ${BUILD_ARCH} ${BUILD_VERSION} &&\
    rm /tmp/install_metricbeat.sh

# Add metricbeat configuration for docker and start script
COPY metricbeat.docker.yml /etc/metricbeat/metricbeat.yml
COPY metricbeat.bin /usr/bin/metricbeat

# Copy start script
COPY run.sh /
RUN chmod a+x /run.sh /usr/bin/metricbeat

CMD [ "/run.sh" ]

# Labels
LABEL \
    io.hass.name="Metricbeat" \
    io.hass.description="Metricbeat metrics for your Home Assistant" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Daniel Rich <drich@employees.org>" \
    org.label-schema.description="Metricbeat metrics for your Home Assistant" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Metricbeat" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/sjthespian/hassio-addon-metricbeat" \
    org.label-schema.vendor="Community Hass.io Add-ons"
