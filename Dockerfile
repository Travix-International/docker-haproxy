FROM travix/base-alpine:3.3

MAINTAINER Travix

# build time environment variables
ENV HAPROXY_VERSION=1.6.2-r0

# install haproxy
RUN apk --update add \
      haproxy=$HAPROXY_VERSION \
    && rm /var/cache/apk/*

ADD haproxy.cfg /etc/haproxy/haproxy.cfg
ADD ssl.pem /etc/ssl/private/ssl.pem

# expose ports
EXPOSE 80 443

# Define working directory
WORKDIR /etc/haproxy

# runtime environment variables
ENV OFFLOAD_TO_PORT=5000 \
    SSL_CERTIFICATE_NAME=ssl.pem

# define default command
CMD sed -i -e "s/localhost:5000/localhost:${OFFLOAD_TO_PORT}/" /etc/haproxy/haproxy.cfg; \
    sed -i -e "s/ssl.pem/${SSL_CERTIFICATE_NAME}/" /etc/haproxy/haproxy.cfg; \    
    exec haproxy -db -f /etc/haproxy/haproxy.cfg;