{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nur-packages.url = "github:takeokunn/nur-packages";
    flake-utils.url = "github:numtide/flake-utils";
    org-roam-ui-lite.url = "github:tani/org-roam-ui-lite";
  };

  outputs = { self, nixpkgs, nur-packages, flake-utils, org-roam-ui-lite }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        nur-pkgs = nur-packages.legacyPackages.${system};
        emacsPkg = pkgs.emacs.override {
          withNativeCompilation = false;
        };

        textlintrc = (pkgs.formats.json { }).generate "textlintrc" {
          plugins = {
            org = true;
          };
          rules = {
            preset-ja-technical-writing = {
              ja-no-weak-phrase = false;
              ja-no-mixed-period = false;
              no-exclamation-question-mark = false;
              sentence-length = false;
              no-doubled-joshi = false;
              max-kanji-continuous-len = {
                max = 8;
              };
            };
            write-good = {
              weasel = false;
            };
            preset-japanese = {
              sentence-length = false;
              no-doubled-joshi = false;
            };
            prh = {
              rulePaths = [
                "${pkgs.textlint-rule-prh}/lib/node_modules/textlint-rule-prh/node_modules/prh/prh-rules/media/techbooster.yml"
              ];
            };
          };
        };
      in
        {
          devShells = {
            default = pkgs.mkShell {
              packages = with pkgs; [
                nodejs
                (textlint.withPackages [
                  textlint-rule-preset-ja-technical-writing
                  textlint-rule-prh
                  textlint-rule-write-good
                  textlint-plugin-org
                  nur-pkgs.textlint-rule-preset-japanese
                ])
              ];

              shellHook = ''
                [ -f .textlintrc ] && unlink .textlintrc
                ln -s ${textlintrc} .textlintrc
              '';
            };
          };

          packages = {
            build-hugo = pkgs.stdenv.mkDerivation {
              name = "build-hugo";
              src = ./.;
              nativeBuildInputs = with pkgs; [
                hugo
                nur-pkgs.tcardgen
                (emacsPkg.pkgs.withPackages (epkgs: (with epkgs.melpaPackages; [ ox-hugo org-roam ])))
              ];
              buildPhase = ''
                rm -fr org/private/
                emacs --batch --load scripts/ox-roam.el --funcall export-org-roam-files
                tcardgen --fontDir=tcardgen/font --output=static/ogp --config=tcardgen/ogp.yml content/posts/**/*.md
                env HUGO_ENVIRONMENT=production hugo --minify
              '';
              installPhase = ''
                cp -r ./public $out/
              '';
            };
            build-org-roam-ui-lite = pkgs.stdenv.mkDerivation {
              name = "build-org-roam-ui-lite";
              src = ./.;
              nativeBuildInputs = with pkgs; [
                org-roam-ui-lite.packages.${system}.export
                (emacsPkg.pkgs.withPackages (epkgs: (with epkgs.melpaPackages; [ org-roam ])))
              ];
              buildPhase = ''
                rm -fr org/private/
                emacs --batch --load scripts/org-roam-ui.el --funcall org-roam-db-sync
                org-roam-ui-lite-export -d org-roam.db -o ./public
              '';
              installPhase = ''
                cp -r ./public $out/
              '';
            };
          };
        }
    );
}
