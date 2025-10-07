{ pkgs?import <nixpkgs> {}, self ? ./.}:
pkgs.stdenv.mkDerivation {
  name = "www.charleslanglois.dev";
  src = self;
  buildInputs = with pkgs; [
    hugo
    bash
    git
  ];
  buildPhase = ''
  substituteInPlace Makefile --replace-fail "/usr/bin/env bash" "${pkgs.bash}/bin/bash"
  make -B build
  '';

  installPhase = "cp -r public $out";
}

