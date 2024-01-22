{ pkgs?import <nixpkgs> {}, self ? ./.}:
let
  theme = import ./theme.nix {};
in
pkgs.stdenv.mkDerivation {
  name = "www.charleslanglois.dev";
  src = self;
  buildPhase = ''
  cp -r ${theme.path} themes/${theme.name}
  ${pkgs.hugo}/bin/hugo
  '';
  installPhase = "cp -r public $out";
}

