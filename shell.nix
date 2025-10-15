{ pkgs ? import <nixpkgs-unstable> { }, theme ? import ./nix/theme.nix { inherit pkgs; } }:
let twtxt = import ./nix/twtxt.nix { inherit pkgs; };
in pkgs.mkShell {
  buildInputs = with pkgs; [
    hugo
    ansible
    flyctl
    nixfmt
    twtxt
    python312Packages.vobject
    python312Packages.beautifulsoup4
    python312Packages.mf2py
    python312Packages.python-frontmatter
  ];
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

