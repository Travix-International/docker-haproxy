# Usage

To run this docker container use the following command

```sh
docker run -d travix/haproxy:latest
```

# Environment variables

In order to configure the haproxy load balancer for providing ssl on port 443 for your gocd server you can use the following environment variables

| Name                 | Description                                                               | Default value |
| -------------------- | ------------------------------------------------------------------------- | ------------- |
| OFFLOAD_TO_PORT      | The http port the actual application inside the Kubernetes pod listens to | 5000          |
| SSL_CERTIFICATE_NAME | The pem filename for the ssl certificate used on port 443                 | ssl.pem       |

```sh
docker run -d \
    -e "OFFLOAD_TO_PORT=8153" \
    -e "SSL_CERTIFICATE_NAME=yourdomain.com.pem" \
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