# travix/haproxy

[HAProxy](http://www.haproxy.org/) load balancer

[![Stars](https://img.shields.io/docker/stars/travix/haproxy.svg)](https://hub.docker.com/r/travix/haproxy/)
[![Pulls](https://img.shields.io/docker/pulls/travix/haproxy.svg)](https://hub.docker.com/r/travix/haproxy/)
[![License](https://img.shields.io/github/license/Travix-International/docker-haproxy.svg)](https://github.com/Travix-International/docker-haproxy/blob/master/LICENSE)

# Usage

To run this docker container use the following command

```sh
docker run -d travix/haproxy:latest
```

# Environment variables

In order to configure the haproxy load balancer for providing ssl on port 443 for your gocd server you can use the following environment variables

| Name                   | Description                                                               | Default value   |
| ---------------------- | ------------------------------------------------------------------------- | --------------- |
| BASIC_AUTH             | Space separated list of users for BasicAuth                               |                 |
| OFFLOAD_TO_PORT        | The http port the actual application inside the Kubernetes pod listens to | 5000            |
| SSL_CERTIFICATE_NAME   | The pem filename for the ssl certificate used on port 443                 | ssl.pem         |
| X_FORWARDED_FOR_HEADER | X-Forwarded-For header value to check                                     | X-Forwarded-For |
| X_FRAME_OPTIONS        | X-Frame-Options header value                                              | DENY            |

## Custom port

```sh
docker run -d -e "OFFLOAD_TO_PORT=8153" travix/haproxy:latest
```

## IP Whitelisting

```sh
docker run -d \
    -e "WHITELIST_CIDRS=1.2.3.4/32 192.168.0.1/24" \
    travix/haproxy:latest
```

## Basic authentication

```sh
docker run -d \
    -e "BASIC_AUTH=user1:pass1234 user2:1234pass" \
    travix/haproxy:latest
```

# Mounting volumes

In order to keep your ssl certificate outside of the container on the host machine you can mount the following directory

| Directory         | Description               | Importance                             |
| ----------------- | ------------------------- | -------------------------------------- |
| /etc/ssl/private/ | SSL certificates          | Store the files in a Kubernetes secret |

Start the container like this to mount the directories

```sh
docker run -d \
    -e "OFFLOAD_TO_PORT=8153" \
    -e "SSL_CERTIFICATE_NAME=yourdomain.com.pem" \
    -v /mnt/persistent-disk/gocd-haproxy/ssl-private:/etc/ssl/private
    travix/gocd-haproxy:latest
```
