---
title: "7.3. Emacsの起動高速化"
---



# パッケージマネージャ比較

-   package.el: 標準、シンプル
-   use-package: 宣言的設定
-   leaf: use-packageの日本発代替
-   straight.el: 再現性重視
-   elpaca: 非同期、最新


# early-init.el

-   GUI初期化前の設定
-   ツールバー無効化
-   フレームサイズ
-   package-enable-at-startup


# native-comp

-   ELispのネイティブコンパイル
-   Emacs 28以降
-   設定と確認方法
-   初回コンパイルの待ち時間


# pdumper

-   ポータブルダンプ
-   カスタムdumpの作成
-   劇的な起動時間短縮


# 遅延ロード

-   :defer, :commands
-   autoload の仕組み
-   after-init-hook の活用


# ベンチマーク

-   esup: 起動時間プロファイル
-   benchmark-init
-   最適化の指針
