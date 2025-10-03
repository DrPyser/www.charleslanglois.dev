# www.charleslanglois.dev
My personal web homepage.

Currently built on the [hugo static site generator](https://gohugo.io).

## icons

Currently using a free fontawesome kit (2693fce77c) for some icon sets, like social media icons.
See [fontawesome website](https://fontawesome.com/kits) to manage the kit.

## Theme

Currently using [hugo theme "terminal"](https://github.com/panr/hugo-theme-terminal).
Thanks to [panr](https://github.com/panr) and other contributors!

## CI/CD

Using github actions workflows for CI & CD.

### CI

Currently, workflow [main.yml](.github/workflows/main.yml) defines basic CI, using nix to run the `make build` command.

### CD

Continuous staging deployments is setup through workflow [staging.yml](./github/workflows/staging.yml).
