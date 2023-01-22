{
  description = "A flake for the piedmontprairie.us site ";
  nixConfig = {
    bash-prompt = "> ";
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default =  pkgs.mkShell {
        buildInputs = [
          pkgs.bashInteractive 
          # pkgs.openssl
          # pkgs.openssl.dev
          pkgs.rPackages.devtools
          pkgs.R
          pkgs.libpng
        ];
      }; 

    });
}

