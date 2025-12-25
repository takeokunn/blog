---
title: "3.6. Emacs設定のLiterate化実践"
---



# なぜEmacs設定をLiterate化するのか

-   設定の自己文書化
    -   コードと説明の一体化
    -   数年後の自分への説明
    -   他者への共有
-   管理が容易
    -   トピック別の整理
    -   依存関係の明示
    -   無効化の容易さ
-   学習効果
    -   設定を書きながら学ぶ
    -   試行錯誤の記録


# 基本アーキテクチャ

-   README.org → init.el の生成
    -   単一ファイルアプローチ
    -   org-babel-tangle の活用
-   複数ファイル構成
    -   トピック別orgファイル
    -   読み込み順序の制御
    -   early-init.org の扱い


# org-babel-load-file

-   起動時の自動tangle
    -   （org-babel-load-file "~/.emacs.d/config.org"）
    -   .elファイルのキャッシュ
    -   更新検知と再tangle
-   利点と欠点
    -   設定変更の即時反映
    -   起動時間への影響
    -   デバッグの難しさ


# tangleヘッダー引数の活用

-   :tangle yes/no
    -   ブロック単位の有効/無効
    -   実験的設定の管理
-   :tangle "filename"
    -   出力先の指定
    -   複数ファイルへの分割
-   :noWeb yes
    -   コードブロックの参照
    -   共通部品の再利用
-   :comments link
    -   元のorgファイルへのリンク
    -   デバッグ時のジャンプ


# 実践的な構成例

-   推奨ディレクトリ構成
    -   ~/.emacs.d/
    -   config.org（メイン設定）
    -   early-init.el（直接記述）
    -   lisp/（tangle出力先）
-   セクション構成の例
    -   基本設定
    -   パッケージ管理
    -   UI/UX
    -   言語別設定
    -   Org-mode設定


# 条件分岐とOS対応

-   システム判定
    -   system-type によるOS判定
    -   window-system によるGUI判定
-   条件付きtangle
    -   :tangle （when （eq system-type 'darwin） "init.el"）
    -   Elisp式の評価
-   環境変数の活用
    -   getenv での取得
    -   機密情報の分離


# デバッグとトラブルシューティング

-   よくある問題
    -   tangle後のシンタックスエラー
    -   読み込み順序の問題
    -   変数の未定義
-   デバッグ手法
    -   emacs -Q での確認
    -   バイトコンパイルエラー
    -   :comments link の活用
-   段階的な有効化
    -   セクション単位でのテスト
    -   git bisect 的アプローチ


# 移行のベストプラクティス

-   既存init.elからの移行
    -   段階的な移行
    -   動作確認しながら進める
-   維持管理
    -   定期的な棚卸し
    -   使わない設定の削除
    -   バージョン管理との連携
-   コミュニティ事例
    -   有名なLiterate config
    -   参考になるリポジトリ
