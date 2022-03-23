.PHONY: build publish clean flake-update container

CADDYFILE=Caddyfile
OUT:=./public/
$(OUT): content static layout theme resources
	hugo -D -d ${OUT}

PACKAGE?=.#
nix-build: 
	nix build $(PACKAGE)

build: $(OUT)

publish: build
	bash -x push.rsync.sh

clean:
	rm -r $(OUT)

flake-update:
	nix flake update

CONTAINER_NAME?=www-charleslanglois-dev
CONTAINER_DIR?=/var/lib/machines
CONTAINER_PATH=$(CONTAINER_DIR)/$(CONTAINER_NAME)
$(CONTAINER_PATH): nix-build
	nixos-container create --flake=flake.nix $(CONTAINER_NAME)

container: $(CONTAINER_PATH)
