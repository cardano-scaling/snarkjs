{
  description = "snarkjs — zkSNARKs in JavaScript, with Cardano/Plutus support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        snarkjs = pkgs.buildNpmPackage {
          pname = "snarkjs";
          version = "0.7.6";
          src = ./.;

          npmDepsHash = "sha256-UfaB+aExi0kSjqiCFErvwTlK9hdq7kxtDUIzNxPx2Uc=";

          # The build step (rollup bundling) is not required for CLI usage;
          # pre-built artifacts are committed to the repo.
          dontNpmBuild = true;
        };
      in {
        packages = {
          inherit snarkjs;
          default = snarkjs;
        };

        # Keep defaultPackage for compatibility with older flake consumers
        # (e.g. flake inputs that reference .defaultPackage.${system}).
        defaultPackage = snarkjs;

        devShells.default = pkgs.mkShell {
          packages = [ pkgs.nodejs_22 snarkjs ];
        };
      });
}
