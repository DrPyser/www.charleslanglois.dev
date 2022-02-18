.PHONY: build publish clean

build:
	hugo -D

public: build
	

publish: build
	bash -x push.rsync.sh

clean:
	rm -r public/

flake-update:
	nix flake update


