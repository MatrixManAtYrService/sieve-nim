{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nimble2nix.url = "github:bandithedoge/nimble2nix";
    contracts-src = {
      url = "github:Udiknedormin/NimContracts";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    contracts-src,
    nimble2nix
  }:
  flake-utils.lib.eachDefaultSystem  
  ( system: 
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [nimble2nix.overlay];
      };
    in
      {
        packages = rec {

          contracts = pkgs.buildNimblePackage rec {
            pname = "contracts";
            version = "0.2.2";
            src = contracts-src;

            # run 'nix develop' to generate this file
            deps = ./nimble2nix.json;
          };

          default = contracts;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nimble2nix
          ];
          shellHook = ''

          if [ ! -f nimble2nix.json ]
          then
              set -x
              cp ${contracts-src}/*.nimble .
              nimble2nix
              rm -f *.nimble
          fi
          '';
        };
      }
    # /in
  );
}

