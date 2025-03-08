# ブログリポジトリ情報

このリポジトリは[Hugo](https://gohugo.io/)で構築された個人ブログであり、[org-roam](https://www.orgroam.com/)と[ox-hugo](https://ox-hugo.scripter.co/)を使用してツェッテルカステン方式でコンテンツを生成しています。

## リポジトリ構造

- **content/**: ブログ記事とページを含む
- **static/**: 画像、CSS、JavaScriptなどの静的アセット
- **themes/**: Hugoテーマを含む（カスタムテーマ：hugo-take-theme）
- **org/**: コンテンツ生成に使用されるorg-modeファイル
- **archetypes/**: 新しいコンテンツのテンプレート
- **zenn/**: Zennプラットフォーム向けのコンテンツ
- **typst/**: Typstドキュメント
- **scripts/**: ブログ用のユーティリティスクリプト

## 開発

ブログをローカルで実行するには：

```bash
# Hugoをインストール
# Hugoサーバーを実行
hugo server -D --port 52112 --bind 0.0.0.0 --disableFastRender
```

## 公開

ブログは以下に公開されています：
- メインサイト: https://takeokunn.org (GitHub Pages)
- Zenn: https://zenn.dev/takeokunn

## テーマ

このブログは、カスタムテーマを使用しています: [takeokunn/hugo-take-theme](https://github.com/takeokunn/hugo-take-theme)

テーマを更新するには：
```bash
git submodule update --remote --recursive
```