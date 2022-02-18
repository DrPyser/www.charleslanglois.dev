{
  description = "my personal website";

	inputs = {
  	nixpkgs.url = "github:nixos/nixpkgs";
  	hugo-theme-terminal = {
    	url = "github:panr/hugo-theme-terminal";
    	flake = false;
  	};
	};

  outputs = { self, nixpkgs, hugo-theme-terminal }: let
		pkgs = nixpkgs.legacyPackages.x86_64-linux;
	in {
    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        # url = "https://github.com/DrPyser/www.charleslanglois.dev.git";
        name = "www.charleslanglois.dev";
        src = self;
        buildInputs = [ pkgs.hugo ];
    #     builder = builtins.toFile "builder.sh" ''
				# source $stdenv/setup;
				# export PATH=$hugo/bin:$PATH
				# '';
        # installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
    };
    devShell.x86_64-linux = pkgs.mkShell {
      buildInputs = [ pkgs.hugo pkgs.caddy ];
			shellHook = ''
      mkdir -p themes
      ln -snf "${hugo-theme-terminal}" themes/terminal
      '';
    };
  };
}
