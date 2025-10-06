FROM hugomods/hugo:go-git-0.136.5
ARG ENVIRONMENT=development
ENV ENVIRONMENT=${ENVIRONMENT}
ARG HUGO_BASEURL=https://www.charleslanglois.dev
ENV HUGO_BASEURL=${HUGO_BASEURL}
ARG HUGO_BUILDOPTS="--enableGitInfo --environment $ENVIRONMENT -d /public"

VOLUME /src
CMD ["hugo", "serve", "--bind", "0.0.0.0"]

