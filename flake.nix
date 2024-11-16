{
  description = "takeokunn's blog";

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
        devShell = forAllSystems (
          system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            nur-pkgs = nur-packages.legacyPackages.${system};
            textlintrc = (pkgs.formats.json { }).generate "textlintrc" {
              filters = { };
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
                };
                write-good = {
                  weasel = false;
                };
                preset-japanese = {
                  sentence-length = false;
                  no-doubled-joshi = false;
                };
                # preset-ja-spacing = true;
                # preset-jtf-style = true;
                prh = {
                  rulePaths = [
                    "${pkgs.textlint-rule-prh}/lib/node_modules/textlint-rule-prh/node_modules/prh/prh-rules/media/WEB+DB_PRESS.yml"
                    "${pkgs.textlint-rule-prh}/lib/node_modules/textlint-rule-prh/node_modules/prh/prh-rules/media/techbooster.yml"
                  ];
                };
              };
            };
          in
            pkgs.mkShell {
              packages = with pkgs; [
                nodejs
                (textlint.withPackages [
                  textlint-rule-preset-ja-technical-writing
                  textlint-rule-prh
                  textlint-rule-write-good
                  textlint-plugin-org
                  nur-pkgs.textlint-rule-preset-japanese
                  # nur-pkgs.textlint-rule-preset-ja-spacing
                  # nur-pkgs.textlint-rule-preset-jtf-style
                ])
              ];

              shellHook = ''
                [ -f .textlintrc ] && unlink .textlintrc
                ln -s ${textlintrc} .textlintrc
              '';
            }
        );
      };
}
