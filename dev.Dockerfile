FROM hugomods/hugo:go-git-0.136.5

ARG ENVIRONMENT=development
ARG HUGO_BASEURL=https://www.charleslanglois.dev

VOLUME /src

WORKDIR /src

CMD ["hugo", "serve", "--environment", "$ENVIRONMENT", "-D", "--enableGitInfo", "--bind", "0.0.0.0"]
