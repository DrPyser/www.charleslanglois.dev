{pkgs ? import <nixpkgs> {}}:
  {
    path = builtins.fetchGit {
      url = "https://github.com/panr/hugo-theme-terminal.git";
      ref = "refs/tags/v3.1.2";
    };
    name = "terminal";
  }
