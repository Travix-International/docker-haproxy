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
EXPOSE 80 81 82 443

# Define working directory
WORKDIR /etc/haproxy

# runtime environment variables
ENV OFFLOAD_TO_PORT="5000" \
    SSL_CERTIFICATE_NAME="ssl.pem" \
    HEALT_CHECK_PATH="/healthz" \
    HEALT_CHECK_VERB="HEAD" \
    WHITELIST_CIDRS=""

# define default command
CMD if [ "${WHITELIST_CIDRS}" != "" ]; then \
      WHITELIST1="acl good_guys_ip hdr_ip(X-Forwarded-For) ${WHITELIST_CIDRS}"; \
      WHITELIST2="http-request deny if !good_guys_ip"; \
    fi; \
    sed -i -e "s/localhost:5000/localhost:${OFFLOAD_TO_PORT}/" /etc/haproxy/haproxy.cfg; \
    sed -i -e "s/ssl.pem/${SSL_CERTIFICATE_NAME}/" /etc/haproxy/haproxy.cfg; \    
    sed -i -e "s/option httpchk HEAD/option httpchk ${HEALT_CHECK_VERB}/" /etc/haproxy/haproxy.cfg; \
    sed -i -e "s:/healthz:${HEALT_CHECK_PATH}:" /etc/haproxy/haproxy.cfg; \    
    sed -i -e "s:WHITELIST1:${WHITELIST1}:" /etc/haproxy/haproxy.cfg; \
    sed -i -e "s:WHITELIST2:${WHITELIST2}:" /etc/haproxy/haproxy.cfg; \
    exec haproxy -db -f /etc/haproxy/haproxy.cfg;