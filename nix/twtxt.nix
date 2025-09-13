{ pkgs ? import <nixpkgs> { } }:
let
  twtxt = with pkgs.python3Packages;
    buildPythonApplication rec {
      pname = "twtxt";
      version = "1.3.1";
      src = pkgs.fetchPypi {
        inherit pname version;
        sha256 = "8V5YD4AWBxRIskBIQCuTm56N7Afqus2EsfKHjXUbcf8=";
      };
      build-system = [ setuptools ];
      pyproject = true;
      propagatedBuildInputs =
        [ aiohttp python-dateutil humanize click ];
    };
in twtxt

