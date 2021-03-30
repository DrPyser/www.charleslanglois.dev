{ pkgs ? import <nixpkgs> {}, unstable ? import <nixos-unstable> {} }:

pkgs.mkShell {

  buildInputs = [
    unstable.hugo
  ];

}


