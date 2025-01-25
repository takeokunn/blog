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
        typstPackagesCache = pkgs.stdenvNoCC.mkDerivation {
          name = "typst-packages-cache";
          src = pkgs.symlinkJoin {
            name = "typst-packages-src";
            paths = [ "${typst-packages}/packages" ];
          };
          dontBuild = true;
          installPhase = ''
            mkdir -p $out/typst/packages
            cp -LR --reflink=auto --no-preserve=mode -t $out/typst/packages $src/*
          '';
        };

        buildTypstProject = { name, src, file }: pkgs.stdenv.mkDerivation {
          inherit name src;
          nativeBuildInputs = with pkgs; [
            typst
            migu
            (emacs.pkgs.withPackages (epkgs: with epkgs; [ org ox-typst ]))
          ];
          buildPhase = ''
            emacs --batch \
                  --eval "(progn
                            (require 'ox-typst)
                            (find-file \"${file}.org\")
                            (setq org-export-with-toc nil)
                            (org-typst-export-to-typst))"

            export TYPST_FONT_PATHS="${pkgs.migu}/share/fonts/truetype/migu"
            export TYPST_PACKAGE_PATH="${typstPackagesCache}/typst/packages"
            typst compile ${file}.typ
          '';
          installPhase = ''
            mkdir -p $out
            cp ${file}.pdf $out/${name}.pdf
          '';
        };
      in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ typst migu ];
          };

          packages = {
            phperkaigi-2025-pamphlet = buildTypstProject {
              name = "phperkaigi-2025-pamphlet";
              src = ./phperkaigi-2025-pamphlet;
              file = "article";
            };
            phpcon-nagoya-2025 = buildTypstProject {
              name = "phpcon-nagoya-2025";
              src = ./phpcon-nagoya-2025;
              file = "slide";
            };
          };
        }
    );
}
