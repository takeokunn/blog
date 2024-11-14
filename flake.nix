{
  description = "takeokunn's blog";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nur-pkgs.url = "github:takeokunn/nur-packages";
  };

  outputs = { self, nixpkgs, nur-pkgs }:
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
            nur = nur-pkgs.legacyPackages.${system};

            textlintrc = (pkgs.formats.json { }).generate "textlintrc" {
              plugins = {
                org = true;
              };
              rules = {
                preset-ja-technical-writing = {
                  sentence-length = false;
                  no-doubled-joshi = false;
                  no-exclamation-question-mark = false;
                };
                write-good = {
                  weasel = false;
                };
                preset-japanese = {
                  sentence-length = false;
                  no-doubled-joshi = false;
                };
                preset-ja-spacing = true;
                preset-jtf-style = true;
                prh = {
                  rulePaths = [
                    "./prh.yml"
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
                  nur.textlint-rule-preset-jtf-style
                  nur.textlint-rule-preset-japanese
                  nur.textlint-rule-preset-ja-spacing
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
