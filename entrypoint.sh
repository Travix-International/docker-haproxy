#!/bin/sh

set -e

sed -i -e "s#X-Frame-Options: DENY#X-Frame-Options: ${X_FRAME_OPTIONS}#" /etc/haproxy/haproxy.cfg
sed -i -e "s/directhostname/${DIRECT_HOST_NAME}/" /etc/haproxy/haproxy.cfg
sed -i -e "s/localhost:5000/${OFFLOAD_TO_HOST}:${OFFLOAD_TO_PORT}/" /etc/haproxy/haproxy.cfg
sed -i -e "s/option httpchk HEAD/option httpchk ${HEALT_CHECK_VERB}/" /etc/haproxy/haproxy.cfg
sed -i -e "s/ssl.pem/${SSL_CERTIFICATE_NAME}/" /etc/haproxy/haproxy.cfg
sed -i -e "s:(X-Forwarded-For):(${X_FORWARDED_FOR_HEADER}):" /etc/haproxy/haproxy.cfg
sed -i -e "s:/healthz:${HEALT_CHECK_PATH}:" /etc/haproxy/haproxy.cfg
sed -i -e "s:TLS_SETTINGS:${TLS_SETTINGS}:" /etc/haproxy/haproxy.cfg
sed -i -e "s:WHITELIST_CIDRS:${WHITELIST_CIDRS}:" /etc/haproxy/haproxy.cfg
sed -i -e "s:stats refresh 5s:stats refresh ${STATS_REFRESH_INTERVAL}:" /etc/haproxy/haproxy.cfg
sed -i -e "s:statspassword:${STATS_PASSWORD}:" /etc/haproxy/haproxy.cfg
sed -i -e "s/timeout client  50000/timeout client  ${CLIENT_TIMEOUT}/" /etc/haproxy/haproxy.cfg
sed -i -e "s/timeout server  50000/timeout server  ${SERVER_TIMEOUT}/" /etc/haproxy/haproxy.cfg

exec "$@"