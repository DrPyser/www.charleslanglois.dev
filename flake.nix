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
    buildInputs = [ pkgs.hugo ];
    sourceInfo = (if self ? sourceInfo
      && self.sourceInfo ? rev
      && self.sourceInfo ? shortRev
      && self.sourceInfo ? lastModifiedDate
    then self.sourceInfo
    else { rev = "dirty"; shortRev = "dirty"; lastModifiedDate = "$(date)"; });
		drv = { Caddyfile }:
      with (import nixpkgs { system = "x86_64-linux"; });
      stdenv.mkDerivation {
        inherit buildInputs;
        # url = "https://github.com/DrPyser/www.charleslanglois.dev.git";
        name = "www.charleslanglois.dev";
        # path correspond to build dir with git-versionned source files,
        # but do not include the .git subdir
        # so hugo cannot be built with --enable-git-info
        src = self;
        dontConfigure = true;
        dontInstall = true;
        preferLocalBuild = true;
        buildPhase = ''
        mkdir -p themes;
        ln -snf "${hugo-theme-terminal}" themes/terminal
        export HUGO_GIT_REV=${sourceInfo.rev}
        export HUGO_GIT_SHORTREV=${sourceInfo.shortRev}
        export HUGO_GIT_LASTMODIFIED=${sourceInfo.lastModifiedDate}
        
        make build OUT=$out/public;
        cp ${Caddyfile} $out/Caddyfile;
        '';
    };

  in {
    # in practice should only need x86_64-linux system

    website.x86_64-linux =
      # see about using builtins.derivation instead
      drv { Caddyfile = "Caddyfile"; };

		devWebsite.x86_64-linux = 
      # see about using builtins.derivation instead
      drv { Caddyfile = "Caddyfile.dev"; };

    defaultPackage.x86_64-linux = self.website.x86_64-linux;

    devShell.x86_64-linux = pkgs.mkShell {
      inherit buildInputs;
      shellHook = ''
      mkdir -p themes
      ln -snf "${hugo-theme-terminal}" themes/terminal
      '';
    };

    nixosConfigurations.container = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ ({ pkgs, ... }: {
            boot.isContainer = true;
            environment.systemPackages = [ pkgs.caddy ];
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            # Network configuration.
            networking.useDHCP = false;
            networking.firewall.allowedTCPPorts = [ 80 443 ];

            # Enable a web server.
            services.caddy = {
              enable = true;
              email = "schok53@gmail.com";
              configFile = "${self.devWebsite.x86_64-linux}/Caddyfile";
            };
            environment.variables = {
							SITE_DIR = "${self.devWebsite.x86_64-linux}";
            };
            systemd.services.caddy.environment = {
              SITE_DIR = "${self.devWebsite.x86_64-linux}";

            };

          })
        ];
    };
  };
}
