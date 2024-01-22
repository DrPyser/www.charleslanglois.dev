{ pkgs ? import <nixpkgs> {}, theme ? "terminal", themePath ? ./themes/${theme} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    hugo
    ansible
  ];
  shellHook = ''
  # set -x
  echo "Entering development environment for $PWD"
  echo "hugo=$(realpath $(which hugo))"
  echo "ansible=$(realpath $(which ansible))"
  echo "theme=${theme}@${themePath}"
  export THEME=${theme}

  if ! test -d ./themes/$THEME; then
    ln -sf ${themePath} themes/$THEME;
  fi
  echo "Theme $THEME available at $(ls -d ./themes/$THEME)";
  export PS1="[$(nix-shell-info)] $PS1"
  '';
}


