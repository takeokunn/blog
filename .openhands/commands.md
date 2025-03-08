# 便利なコマンド

## Hugoコマンド

```bash
# ローカル開発用のHugoサーバーを起動
hugo server -D --port 52112 --bind 0.0.0.0 --disableFastRender

# サイトをビルド
hugo

# 新しい投稿を作成
hugo new posts/my-new-post.md
```

## Gitコマンド

```bash
# テーマのサブモジュールを更新
git submodule update --remote --recursive

# サブモジュールの初期化（必要な場合）
git submodule init
git submodule update
```

## Node.jsコマンド

```bash
# 依存関係をインストール
npm install

# シークレットリンティングを実行
npm run lint:secret
```

## コンテンツ生成

```bash
# org-modeとox-hugoを使用している場合、orgファイルをHugoマークダウンにエクスポート
# これは通常Emacs内で行われます
```

## デプロイメント

サイトはGitHub Pagesにデプロイされています。デプロイプロセスはGitHub Actionsまたは類似のCI/CDパイプラインを通じて処理されていると思われます。