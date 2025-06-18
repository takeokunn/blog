{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
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
        emacsPkg = pkgs.emacs.override {
          withNativeCompilation = false;
        };
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

        buildTypstProject = { name, type }:
          let
            _ = assert builtins.elem; type [ "article" "slide" ];
            emacsBuildPhase = name: if type == "article"
                                    then
                                      "emacs --batch --load scripts/ox-typst.el --file org/${name}/article.org --funcall org-typst-export-to-typst"
                                    else
                                      "emacs --batch --load scripts/ox-typst.el --file org/${name}/article.org --funcall org-typst-slide-export-to-typst";
          in
            pkgs.stdenv.mkDerivation {
              inherit name;
              src = ./.;
              nativeBuildInputs = with pkgs; [
                typst
                polylux2pdfpc
                hackgen-font
                fira-math
                fira-code
                (emacsPkg.pkgs.withPackages (epkgs: with epkgs; [ org ox-typst ]))
              ];
              buildPhase = ''
                ${emacsBuildPhase name}

                export TYPST_FONT_PATHS="$TYPST_FONT_PATHS:${pkgs.fira-math}/share/fonts/opentype"
                export TYPST_FONT_PATHS="$TYPST_FONT_PATHS:${pkgs.fira-code}/share/fonts/truetype/NerdFonts/FiraCode/"
                export TYPST_FONT_PATHS="$TYPST_FONT_PATHS:${pkgs.hackgen-font}/share/fonts/hackgen"
                export TYPST_PACKAGE_PATH="${typstPackagesCache}/typst/packages"

                cp ./themes/dracula.typ org/${name}/dracula.typ
                cp ./themes/Dracula.tmTheme org/${name}/Dracula.tmTheme

                typst compile org/${name}/article.typ
                polylux2pdfpc org/${name}/article.typ
              '';
              installPhase = ''
                mkdir -p $out
                cp org/${name}/article.pdf $out/${name}.pdf
                cp org/${name}/article.pdfpc $out/${name}.pdfpc
              '';
            };
      in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ typst ];
          };

          packages = {
            example-slide = buildTypstProject {
              name = "example-slide";
              type = "slide";
            };
            nix-meetup-3-my-nix-usecase = buildTypstProject {
              name = "nix-meetup-3-my-nix-usecase";
              type = "slide";
            };
            phperkaigi-2025-pamphlet = buildTypstProject {
              name = "phperkaigi-2025-pamphlet";
              type = "article";
            };
            typst-presentation-practice = buildTypstProject {
              name = "typst-presentation-practice";
              type = "slide";
            };
          };
        }
    );
}
