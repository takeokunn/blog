{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    typst-packages = {
      url = "github:typst/packages";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      typst-packages
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        typstPackagesSrc = pkgs.symlinkJoin {
          name = "typst-packages-src";
          paths = [ "${typst-packages}/packages" ];
        };
        typstPackagesCache = pkgs.stdenvNoCC.mkDerivation {
          name = "typst-packages-cache";
          src = typstPackagesSrc;
          dontBuild = true;
          installPhase = ''
            mkdir -p $out/typst/packages
            cp -LR --reflink=auto --no-preserve=mode -t $out/typst/packages $src/*
          '';
        };
      in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ typst ];
          };

          packages = {
            phperkaigi-2025-pamphlet = pkgs.stdenv.mkDerivation {
              name = "phperkaigi-2025-pamphlet";
              src = ./phperkaigi-2025-pamphlet;
              nativeBuildInputs = with pkgs; [
                typst
                migu
                (emacs.pkgs.withPackages (epkgs: with epkgs; [ org ox-typst ]))
              ];
              buildPhase = ''
                emacs --batch \
                      --eval "(progn
                                (setq org-export-with-toc nil)
                                (require 'ox-typst)
                                (find-file \"article.org\")
                                (org-typst-export-to-typst))"

                export TYPST_FONT_PATHS="${pkgs.migu}/share/fonts/truetype/migu"
                export TYPST_PACKAGE_PATH="${typstPackagesCache}/typst/packages"
                typst compile article.typ
              '';
              installPhase = ''
                mkdir -p $out
                cp article.pdf $out/phperkaigi-2025-pamphlet.pdf
              '';
            };
          };
        }
    );
}
