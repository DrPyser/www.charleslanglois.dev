.PHONY: build publish clean

OUT=?./public
build:
	hugo -D -d ${OUT}

nix-build: build
	nix build

public: build

publish: build
	bash -x push.rsync.sh

clean:
	rm -r public/

flake-update:
	nix flake update


