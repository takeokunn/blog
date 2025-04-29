{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nur-packages.url = "github:takeokunn/nur-packages";
  };

  outputs = { self, nixpkgs, nur-packages }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
      {
        devShells = forAllSystems (
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
              deploy = pkgs.mkShell {
                packages = with pkgs; [
                  (emacsPkg.pkgs.withPackages (epkgs: (with epkgs.melpaPackages; [ ox-zenn ])))
                ];
              };
            }
        );
      };
}
