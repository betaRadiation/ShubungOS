{
  description = "Python steam scraper";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          devShells.default = pkgs.mkShell {
	    nativeBuildInputs = with pkgs; [
	      qemu
	    ];
	  };
        }
      );
}
