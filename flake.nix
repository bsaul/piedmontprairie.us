{
  description = "A flake for the piedmontprairie.us site";
  nixConfig = {
    bash-prompt = "> ";
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      
      formatter = pkgs.nixpkgs-fmt;
      
      packages.site = pkgs.stdenv.mkDerivation {
        name = "piedmontprairie.us";
        buildInputs = with pkgs; 
          [R
           hugo
           pandoc 
           texliveSmall 
           rPackages.blogdown
           rPackages.bibtex
          ];
        src = ./.;
        buildPhase = ''
          ${pkgs.R}/bin/Rscript -e "blogdown::build_site(build_rmd = TRUE)"
        '';
        installPhase = ''
          mkdir -p $out
          cp -r public/ $out/
        '';

      };

      devShells.default =  pkgs.mkShell {
        buildInputs = [
          pkgs.bashInteractive 
          # pkgs.openssl
          pkgs.openssl.dev
          pkgs.libxml2.dev
          pkgs.util-linux

          pkgs.hugo
          pkgs.updog

          pkgs.rPackages.blogdown
          pkgs.rPackages.bibtex
          pkgs.rPackages.devtools
          pkgs.R

          pkgs.pandoc
          pkgs.libpng
        ];
      }; 

    });
}

