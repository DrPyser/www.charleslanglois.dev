{
  # description = "my personal website";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils/master";
    hugo-theme-terminal = {
      url = "github:panr/hugo-theme-terminal";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, hugo-theme-terminal, flake-utils }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    buildInputs = [ pkgs.hugo pkgs.caddy ];
  in {
    website.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        inherit buildInputs;
        # url = "https://github.com/DrPyser/www.charleslanglois.dev.git";
        name = "www.charleslanglois.dev";
        src = builtins.trace "source path is ${self.sourceInfo}" self;
        dontConfigure = true;
        dontInstall = true;
        preferLocalBuild = true;
        buildPhase = let sourceInfo = (if self ? sourceInfo && self.sourceInfo ? rev && self.sourceInfo && shortRev && self.sourceInfo ? lastModifiedDate then self.sourceInfo else { rev = "dirty"; shortRev = "dirty"; lastModifiedDate = "$(date)"; });
        in
        ''
        mkdir -p themes;
        ln -snf "${hugo-theme-terminal}" themes/terminal
        export HUGO_GIT_REV=${sourceInfo.rev}
        export HUGO_GIT_SHORTREV=${sourceInfo.shortRev}
        export HUGO_GIT_LASTMODIFIED=${sourceInfo.lastModifiedDate}
        
        make build OUT=$out/public;
        '';
        installPhase = "";
    };
    defaultPackage.x86_64-linux = self.website;
    devShell.x86_64-linux = pkgs.mkShell {
      inherit buildInputs;
      shellHook = ''
      mkdir -p themes
      ln -snf "${hugo-theme-terminal}" themes/terminal
      '';
    };
  };
}
