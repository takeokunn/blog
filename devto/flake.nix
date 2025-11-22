{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        emacsPkg = pkgs.emacs.override {
          withNativeCompilation = false;
        };
        textlintrc = (pkgs.formats.json { }).generate "textlintrc" {
          plugins = {
            org = true;
          };
          rules = {
            write-good = {
              weasel = false;
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
                  textlint-rule-write-good
                  textlint-plugin-org
                ])
              ];

              shellHook = ''
                  [ -f .textlintrc ] && unlink .textlintrc
                  ln -s ${textlintrc} .textlintrc
                '';
            };
          };
          packages = {
            build-devto = pkgs.stdenv.mkDerivation {
              name = "build-devto";
              src = ./.;
              nativeBuildInputs = with pkgs; [
                (emacsPkg.pkgs.withPackages (epkgs: (with epkgs.melpaPackages; [ ox-gfm ])))
              ];
              buildPhase = ''
                mkdir -p ./articles
                emacs --batch --load scripts/ox-devto.el --funcall export-org-devto-files
              '';
              installPhase = ''
                mkdir -p $out
                # Article Sync 形式: articles/{slug}/article.json + article.md
                for dir in ./articles/*/; do
                  if [ -f "$dir/article.json" ]; then
                    cp -r "$dir" $out/
                  fi
                done
              '';
            };
          };
        }
    );
}
