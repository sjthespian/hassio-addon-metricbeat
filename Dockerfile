FROM elastic/metricbeat:6.7.0

# Add metricbeat configuration for docker
ADD metricbeat.docker.yml /usr/share/metricbeat/metricbeat.yml

# Run as root to have full access to /proc
USER root

# We need jq for options parsing in run.sh
RUN /usr/bin/yum install --assumeyes epel-release && \
    /usr/bin/yum install --assumeyes jq

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
