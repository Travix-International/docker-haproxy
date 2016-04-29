FROM ubuntu:trusty

MAINTAINER Travix

# Install haproxy
RUN \
  sed -i 's/^# \(.*-backports\s\)/\1/g' /etc/apt/sources.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y haproxy/trusty-backports \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /data

ADD haproxy.cfg /data/haproxy.cfg

# Define mountable directories
VOLUME ["/data"]

# Define working directory
WORKDIR /data

# Expose ports
EXPOSE 80 443

# Define default command
CMD ["haproxy", "-f", "/data/haproxy.cfg"]