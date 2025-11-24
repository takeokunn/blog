{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nur-packages.url = "github:takeokunn/nur-packages";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nur-packages, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        emacsPkg = pkgs.emacs.override {
          withNativeCompilation = false;
        };
        nur-pkgs = nur-packages.legacyPackages.${system};
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
              no-unmatched-pair = false;
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
            prh = false;
            # prh = {
            #   rulePaths = [
            #     "${pkgs.textlint-rule-prh}/lib/node_modules/textlint-rule-prh/node_modules/prh/prh-rules/media/techbooster.yml"
            #   ];
            # };
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
            build-zenn = pkgs.stdenv.mkDerivation {
              name = "build-zenn";
              src = ./.;
              nativeBuildInputs = with pkgs; [
                (emacsPkg.pkgs.withPackages (epkgs: (with epkgs.melpaPackages; [ ox-zenn ])))
              ];
              buildPhase = ''
                emacs --batch --load scripts/ox-zenn.el --funcall export-org-zenn-files
              '';
              installPhase = ''
                cp -r ./public $out/
              '';
            };
          };
        }
    );
}
