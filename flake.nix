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
    nimble2nix,
    contracts-src,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in rec
    {

    contracts-flake = import ./subflake/contracts/flake.nix;
    contracts-outputs = contracts-flake.outputs {
      inherit self;
      inherit nixpkgs;
      inherit flake-utils;
      inherit nimble2nix;
      inherit contracts-src;
    };
    contracts = contracts-outputs.packages.${system}.default;

      packages = rec {
        sieve = pkgs.nimPackages.buildNimPackage {
          pname = "sieve";
          version = "0.1.0";
          src = ./.;
          propagatedBuildInputs = [ contracts ];
        };
        default = sieve;
      };

      devShells.default = with pkgs; mkShell {
        packages = [
          nim
          python311
          python311Packages.black
          ruff
          contracts
        ];
      };
    });
}