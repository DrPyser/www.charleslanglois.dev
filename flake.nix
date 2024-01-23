{
  # description = "my personal website";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    # flake-utils.url = "github:numtide/flake-utils/main";
    hugo-theme-terminal = {
      url = "github:panr/hugo-theme-terminal";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, hugo-theme-terminal }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      theme = {
        name = "terminal";
        path = hugo-theme-terminal;
      };
      sourceInfo = (if self ? sourceInfo && self.sourceInfo ? rev
      && self.sourceInfo ? shortRev && self.sourceInfo ? lastModifiedDate then
        self.sourceInfo
      else {
        rev = "dirty";
        shortRev = "dirty";
        lastModifiedDate = "$(date)";
      });
    in {

      devShell.${system} = import ./shell.nix { inherit pkgs theme; };

      nixosConfigurations.container = nixpkgs.lib.nixosSystem {
        system = "${system}";
        modules = [
          ({ pkgs, ... }: {
            boot.isContainer = true;
            environment.systemPackages = [ pkgs.caddy ];
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision =
              nixpkgs.lib.mkIf (self ? rev) self.rev;

            # Network configuration.
            networking.useDHCP = false;
            networking.firewall.allowedTCPPorts = [ 80 443 ];

            # Enable a web server.
            services.caddy = {
              enable = true;
              email = "schok53@gmail.com";
              configFile = "${self.devWebsite.${system}}/Caddyfile";
            };
            environment.variables = {
              SITE_DIR = "${self.devWebsite.${system}}";
            };
            systemd.services.caddy.environment = {
              SITE_DIR = "${self.devWebsite.${system}}";

            };

          })
        ];
      };
    };
}
