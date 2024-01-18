{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    hugo
    ansible
  ];
  shellHook = ''
  echo "Entering development environment for $PWD"
  echo "hugo=$(realpath $(which hugo))"
  echo "ansible=$(realpath $(which ansible))"
  '';
}


