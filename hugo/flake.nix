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

        # OGP 画像用の書体。nix の sandbox はネットワークに出られないため、
        # google/fonts のコミットを固定して取得する。
        googleFontsRev = "06bfe0d62a98375cb09c942fa18e68bd32cff057";
        ogpFonts = pkgs.linkFarm "ogp-fonts" (
          pkgs.lib.mapAttrsToList
            (style: hash: {
              name = "MPLUSRounded1c-${style}.ttf";
              path = pkgs.fetchurl {
                url = "https://raw.githubusercontent.com/google/fonts/${googleFontsRev}/ofl/mplusrounded1c/MPLUSRounded1c-${style}.ttf";
                inherit hash;
              };
            })
            {
              Regular = "sha256-/QA8ohZot/GrVmWszRp4VYe3Xhi47f9lxmP6b6zv2II=";
              Medium = "sha256-jEvxsrPsfrGVawYDGXqV2vpZgeSxcFP3lI0Unsw3ly0=";
              Bold = "sha256-xpgzDiSq3Q2oDKsfMh7unAUtQbZu+E5+U3noH7CEqJA=";
              ExtraBold = "sha256-mQ8ER1qT7wx6P626ozB9RJFyx1ynwPm9dUxhS5MZDhU=";
            }
        );

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
                "prh.yml"
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
                # nixpkgs の Hugo は libsass を含まないため、テーマの SCSS には Dart Sass が要る
                dart-sass
                nur-pkgs.tcardgen
                (python3.withPackages (ps: [ ps.pillow ]))
                (emacsPkg.pkgs.withPackages (epkgs: (with epkgs.melpaPackages; [ ox-hugo org-roam ])))
              ];
              buildPhase = ''
                export TZ=Asia/Tokyo
                rm -fr org/private/
                emacs --batch --load scripts/ox-roam.el --funcall export-org-roam-files

                # tcardgen は Regular が無いと止まるため 4 書体を揃える。
                # 背景画像はこのリポジトリの assets/ogp/tcard-template.png (cwd 基準) を使う。
                ogp_theme=themes/hugo-take-theme/scripts/ogp
                find content/posts -name '*.md' ! -name '_index.md' -print0 \
                  | xargs -0 tcardgen --fontDir=${ogpFonts} --output=static/ogp --template=assets/ogp/tcard-template.png --config=$ogp_theme/tcardgen.config.yaml

                # 3 行を超えるタイトルは警告として出力されるだけで、exit 0 で終わる。
                python3 -I $ogp_theme/preview.py --fonts ${ogpFonts} --check content/posts

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
                perl
                findutils
                org-roam-ui-lite.packages.${system}.export
                (emacsPkg.pkgs.withPackages (epkgs: (with epkgs.melpaPackages; [ org-roam ])))
              ];
              buildPhase = ''
                rm -fr org/private/

                # org-roam-ui-lite が相対パス (file:../../static/images/...) を正しく解決できるよう
                # 各 org サブディレクトリに static へのシンボリックリンクを作成
                for dir in org/*/; do
                  ln -s ../../static "$dir/static"
                done

                emacs --batch --load scripts/org-roam-ui.el --funcall org-roam-db-sync
                org-roam-ui-lite-export -d org-roam.db -o ./public

                # quickhack: サブディレクトリ(/graph/)配置対応のためパスを絶対パスに変換
                # public配下の全ファイルでパスを置換（書き込み権限を付与してから実行）
                chmod -R u+w ./public
                find ./public -type f \( -name "*.html" -o -name "*.js" -o -name "*.css" \) -exec \
                  perl -pi -e 's|"/assets/|"/graph/assets/|g; s|"/vite.svg"|"/graph/vite.svg"|g; s|"/api/|"/graph/api/|g' {} \;
              '';
              installPhase = ''
                cp -r ./public $out/
              '';
            };
          };
        }
    );
}
