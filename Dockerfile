FROM hugomods/hugo:go-git-0.136.5 as buildenv
ARG ENVIRONMENT=development
ENV ENVIRONMENT=${ENVIRONMENT}
ARG HUGO_BASEURL=https://www.charleslanglois.dev
ENV HUGO_BASEURL=${HUGO_BASEURL}
ARG HUGO_BUILDOPTS="--enableGitInfo --environment $ENVIRONMENT -d /public"

# COPY . /src
COPY themes /src/themes
COPY content /src/content
COPY config.toml /src/
COPY archetypes /src/archetypes
COPY layouts /src/layouts
COPY static /src/static
COPY assets /src/assets
COPY .git /src/.git

RUN echo -e "rev=$(git rev-parse HEAD)\n"\
    "branch=$(git rev-parse --abbrev-ref HEAD)\n"\
    "description=$(git describe --abbrev --all --long --dirty)" \
    > /src/static/git-info.txt

RUN hugo $HUGO_BUILDOPTS

FROM caddy:2.7 as final
ARG ENVIRONMENT=development
ENV ENVIRONMENT=${ENVIRONMENT}
ARG CADDYFILE=${ENVIRONMENT}.caddyfile

COPY ${CADDYFILE} /etc/caddy/Caddyfile
COPY --from=buildenv /public /srv/www
