# syntax=docker/dockerfile:1
FROM nginx:1.23.1

ARG UID=1000

RUN mkdir -p /etc/nginx/ssl/ \
    && openssl req \
            -x509 \
            -subj "/C=US/ST=Denial/L=Nowhere/O=Dis" \
            -nodes \
            -days 365 \
            -newkey rsa:2048 \
            -keyout /etc/nginx/ssl/nginx.key \
            -out /etc/nginx/ssl/nginx.cert \
    && usermod -u ${UID} nginx \
    && true
