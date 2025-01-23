{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        nativeBuildInputs = with pkgs; [
          typst
          migu
          (emacs.pkgs.withPackages (epkgs: with epkgs; [ org ox-typst ]))
        ];
      in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ typst ];
          };

          packages = {
            phperkaigi-2025-pamphlet = pkgs.stdenv.mkDerivation {
              name = "phperkaigi-2025-pamphlet";
              src = ./phperkaigi-2025-pamphlet;
              nativeBuildInputs = nativeBuildInputs;
              buildPhase = ''
                emacs --batch \
                      --eval "(progn
                                (setq org-export-with-toc nil)
                                (require 'ox-typst)
                                (find-file \"article.org\")
                                (org-typst-export-to-typst))"

                export TYPST_FONT_PATHS="${pkgs.migu}/share/fonts/truetype/migu"
                typst compile article.typ
              '';
              installPhase = ''
                mkdir -p $out
                cp article.pdf $out/phperkaigi-2025-pamphlet.pdf
                cp article.typ $out/phperkaigi-2025-pamphlet.typ
              '';
            };
          };
        }
    );
}
