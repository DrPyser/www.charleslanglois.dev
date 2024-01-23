SHELL=/usr/bin/env bash
SHELLFLAGS=-eux -o pipefail
MAKEFLAGS+=--no-builtin-rules --warn-undefined-variables
.PHONY: build publish clean rebuild nix/flake/update nix/flake/build nix/flake/container fly.io/deploy fly.io/launch fly.io/status
.DELETE_ON_ERROR:

CADDYFILE=Caddyfile
OUT:=./public/
DIRS=content static layouts themes resources
FILES=$(shell fd . $(DIRS)) config.toml
$(OUT): $(FILES)
	hugo -D -d ${OUT}

PACKAGE?=.#
nix/flake/build:
	nix build $(PACKAGE)

build: $(OUT)

publish: build
	ansible-playbook -i ansible/inventory ansible/playbooks/update_server.yml

clean:
	rm -r $(OUT)

rebuild: clean build

nix/flake/update:
	nix flake update

CONTAINER_NAME?=www-charleslanglois-dev
CONTAINER_DIR?=/var/lib/machines
CONTAINER_PATH=$(CONTAINER_DIR)/$(CONTAINER_NAME)
$(CONTAINER_PATH): nix/flake/build
	nixos-container create --flake=flake.nix $(CONTAINER_NAME)

nix/container: $(CONTAINER_PATH)


fly.io/deploy: fly.toml
	flyctl deploy

fly.io/init: fly.toml
	flyctl launch

fly.io/status: fly.toml
	flyctl status
