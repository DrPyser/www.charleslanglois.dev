FROM caddy:2.7

COPY fly-io-staging.caddyfile /etc/caddy/Caddyfile
COPY public /srv/www
