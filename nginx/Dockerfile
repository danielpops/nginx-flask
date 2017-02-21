FROM ubuntu:xenial
MAINTAINER Daniel Popescu <danielpops@gmail.com>

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        letsencrypt \
        nginx \
        vim \
    && apt-get clean

RUN mkdir -p /etc/nginx/cert \
    && openssl dhparam 2048 -out /etc/nginx/cert/dhparam.pem

ADD nginx-site-config /etc/nginx/sites-available/default

ENTRYPOINT ["nginx", "-g", "daemon off;"]
