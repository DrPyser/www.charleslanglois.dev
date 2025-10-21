FROM hugomods/hugo:go-git-0.136.5 as buildenv
ARG ENVIRONMENT=development
ARG HUGO_BASEURL=https://www.charleslanglois.dev
ARG HUGO_BUILDOPTS=""

COPY themes /src/themes
COPY content /src/content
COPY config.toml /src/
COPY archetypes /src/archetypes
COPY layouts /src/layouts
COPY static /src/static
COPY assets /src/assets
COPY .git /src/.git

WORKDIR /src
RUN <<EOF
git config --global --add safe.directory /src
echo -e "rev=$(git rev-parse HEAD)\n"\
  "branch=$(git rev-parse --abbrev-ref HEAD)\n"\
  "description=$(git describe --abbrev --all --long --dirty)" \
  > /src/static/git-info.txt
EOF

RUN hugo build $HUGO_BUILDOPTS --logLevel debug --enableGitInfo --environment $ENVIRONMENT -d /public

FROM caddy:2-builder AS caddy-builder

RUN xcaddy build \
    --with github.com/aksdb/caddy-cgi/v2

FROM caddy:2-alpine as final
ARG ENVIRONMENT=development
ENV ENVIRONMENT=${ENVIRONMENT}
ARG CADDYFILE=${ENVIRONMENT}.caddyfile

RUN apk add jq

COPY ${CADDYFILE} /etc/caddy/Caddyfile
COPY --from=buildenv /public /srv/www
COPY --from=caddy-builder /usr/bin/caddy /usr/bin/caddy
