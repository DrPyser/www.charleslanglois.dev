{ pkgs ? import <nixpkgs> { }, theme ? import ./nix/theme.nix { inherit pkgs; } }:
pkgs.mkShell {
  buildInputs = with pkgs; [ hugo ansible flyctl nixfmt ];
  shellHook = ''
    # set -x
    echo "Entering development environment for $PWD"
    echo "hugo=$(realpath $(which hugo))"
    echo "ansible=$(realpath $(which ansible))"
    echo "theme=${theme.name}@${theme.path}"
    export THEME=${theme.name}

    if ! test -d ./themes/$THEME; then
      ln -sf ${theme.path} themes/$THEME;
    fi
    echo "Theme $THEME available at $(ls -d ./themes/$THEME)";
    export PS1="[$(nix-shell-info)] $PS1"
  '';
}

