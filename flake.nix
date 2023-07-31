{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      packages = rec {
        sieve = pkgs.nimPackages.buildNimPackage {
          pname = "sieve";
          version = "0.1.0";
          src = ./.;
        };
        default = sieve;
      };

      devShells.default = with pkgs; mkShell {
        packages = [
          nim
          python311
          python311Packages.black
          ruff
        ];
      };
    });
}