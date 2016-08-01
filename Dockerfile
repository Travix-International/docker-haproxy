FROM travix/base-alpine:3.4

MAINTAINER Travix

# build time environment variables
ENV HAPROXY_VERSION=1.6.6-r1

# install haproxy
RUN apk --update --no-cache add \
      haproxy=$HAPROXY_VERSION \
    && rm /var/cache/apk/*

ADD haproxy.cfg /etc/haproxy/haproxy.cfg
ADD ssl.pem /etc/ssl/private/ssl.pem

# expose ports
EXPOSE 80 81 82 443

# Define working directory
WORKDIR /etc/haproxy

# runtime environment variables
ENV OFFLOAD_TO_HOST="localhost" \
    OFFLOAD_TO_PORT="5000" \
    DIRECT_HOST_NAME="directhostname" \
    SSL_CERTIFICATE_NAME="ssl.pem" \
    HEALT_CHECK_PATH="/healthz" \
    HEALT_CHECK_VERB="HEAD" \
    WHITELIST_CIDRS="0.0.0.0/0" \
    TLS_SETTINGS="no-sslv3 no-tls-tickets force-tlsv12" \
    ENABLE_STATS="disable" \
    STATS_PASSWORD=""

# define default command
CMD sed -i -e "s/localhost:5000/${OFFLOAD_TO_HOST}:${OFFLOAD_TO_PORT}/" /etc/haproxy/haproxy.cfg; \
    sed -i -e "s/directhostname/${DIRECT_HOST_NAME}/" /etc/haproxy/haproxy.cfg; \
    sed -i -e "s/ssl.pem/${SSL_CERTIFICATE_NAME}/" /etc/haproxy/haproxy.cfg; \    
    sed -i -e "s/option httpchk HEAD/option httpchk ${HEALT_CHECK_VERB}/" /etc/haproxy/haproxy.cfg; \
    sed -i -e "s:/healthz:${HEALT_CHECK_PATH}:" /etc/haproxy/haproxy.cfg; \    
    sed -i -e "s:WHITELIST_CIDRS:${WHITELIST_CIDRS}:" /etc/haproxy/haproxy.cfg; \
    sed -i -e "s:TLS_SETTINGS:${TLS_SETTINGS}:" /etc/haproxy/haproxy.cfg; \
    sed -i -e "s:stats disable:stats ${ENABLE_STATS}:" /etc/haproxy/haproxy.cfg; \
    sed -i -e "s:statspassword:${STATS_PASSWORD}:" /etc/haproxy/haproxy.cfg; \
    exec haproxy -db -f /etc/haproxy/haproxy.cfg;