SHELL:=/usr/bin/env bash
SHELLFLAGS:=-eux -o pipefail
MAKEFLAGS+=--no-builtin-rules --warn-undefined-variables
.PHONY: build staging/build publish ansible/publish clean rebuild nix/flake/update nix/flake/build nix/flake/container fly.io/deploy fly.io/launch fly.io/status git/stamp content/posts develop
.DELETE_ON_ERROR:

CADDYFILE=Caddyfile

OUT:=./public
DIRS=content static layouts themes resources
FILES=$(shell git ls-files -- $(DIRS) config.toml | xargs -I{} printf %b "{}\n")
BUILDOPTS:=--logLevel debug

$(OUT): $(FILES)
	hugo build $(BUILDOPTS) -d ${OUT}

build: $(OUT)

staging/build: BUILDOPTS+=-D
staging/build: build

develop:
	docker build -f dev.Dockerfile -t www-charleslanglois-dev:dev .
	docker run -it --rm -v $$PWD:/src -p 1313:1313 www-charleslanglois-dev:dev

clean:
	rm -r $(OUT)

rebuild: clean build

static/git-info.txt:
	echo "rev=$$(git rev-parse HEAD)" > static/git-info.txt
	echo "branch=$$(git rev-parse --abbrev-ref HEAD)" >> static/git-info.txt
	echo "description=$$(git describe --abbrev --all --long --dirty)" >> static/git-info.txt

content/posts:
	hugo new content/posts/

git/stamp: static/git-info.txt

# nix stuff
PACKAGE?=.#
nix/flake/build:
	nix build $(PACKAGE)

nix/flake/update:
	nix flake update

CONTAINER_NAME?=www-charleslanglois-dev
CONTAINER_DIR?=/var/lib/machines
CONTAINER_PATH=$(CONTAINER_DIR)/$(CONTAINER_NAME)
$(CONTAINER_PATH): nix/flake/build
	nixos-container create --flake=flake.nix $(CONTAINER_NAME)

nix/container: $(CONTAINER_PATH)

# ansible stuff
ansible/publish: build
	ansible-playbook -i ansible/inventory ansible/playbooks/update_server.yml

# fly.io stuff
fly.io/deploy: fly.toml
	flyctl deploy

fly.io/staging/deploy: fly/staging/fly.toml static/git-info.txt
	flyctl deploy -c fly/staging/fly.toml

fly.io/production/deploy: fly/production/fly.toml static/git-info.txt
	flyctl deploy -c fly/production/fly.toml

fly.io/staging/status:
	flyctl status -c fly/staging/fly.toml

fly.io/production/status:
	flyctl status -c fly/production/fly.toml

fly.io/init:
	flyctl launch

