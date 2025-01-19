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
      in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ typst ];
          };

          packages.default = pkgs.stdenv.mkDerivation {
            name = "phperkaigi-2025-pamphlet";
            src = ./src;
            nativeBuildInputs = with pkgs; [
              typst
              migu
              (emacs.pkgs.withPackages (
                epkgs: with epkgs; [
                  org
                  ox-typst
                ]
              ))
            ];
            buildPhase = ''
              emacs --batch \
                    --eval "(progn
                              (require 'ox-typst)
                              (find-file \"main.org\")
                              (org-typst-export-to-typst))"

              export TYPST_FONT_PATHS="${pkgs.migu}/share/fonts/truetype/migu"
              typst compile main.typ
            '';
            installPhase = ''
              mkdir -p $out
              cp main.pdf $out/
            '';
          };
        }
    );
}
