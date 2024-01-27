SHELL=/usr/bin/env bash
SHELLFLAGS=-eux -o pipefail
MAKEFLAGS+=--no-builtin-rules --warn-undefined-variables
.PHONY: build publish ansible/publish clean rebuild nix/flake/update nix/flake/build nix/flake/container fly.io/deploy fly.io/launch fly.io/status git/stamp
.DELETE_ON_ERROR:

CADDYFILE=Caddyfile

OUT:=./public
DIRS=content static layouts themes resources
FILES=$(shell fd . $(DIRS)) config.toml
BUILDOPTS:=-D -d 

$(OUT): $(FILES)
	hugo $(BUILDOPTS) ${OUT}

build: $(OUT)

clean:
	rm -r $(OUT)

rebuild: clean build

static/git-info.txt:
	echo "rev=$$(git rev-parse HEAD)" > static/git-info.txt
	echo "branch=$$(git rev-parse --abbrev-ref HEAD)" >> static/git-info.txt
	echo "description=$$(git describe --abbrev --all --long --dirty)" >> static/git-info.txt


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

fly.io/init: fly.toml
	flyctl launch

fly.io/status: fly.toml
	flyctl status

