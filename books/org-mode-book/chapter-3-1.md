---
title: "3.1. 文芸的プログラミングの思想"
---



# Literate Programmingとは

-   Donald Knuthの提唱（1984年）
-   WebシステムとTeX
-   「プログラムを書くのではなく、説明を書く」


# TangleとWeave

-   Tangle: ドキュメントからソースコードを抽出
-   Weave: ドキュメントから人間向け文書を生成
-   Org-modeにおける実現（C-c C-v t, エクスポート）


# コードブロックの構文

-   \#+BEGIN<sub>SRC</sub> lang &#x2026; #+END<sub>SRC</sub>
-   ヘッダー引数の基本（:tangle, :exports, :results）
-   インラインソースブロック（）


# 引数の詳細

-   :tangle yes/no/filename - 出力先制御
-   :exports code/results/both/none - エクスポート対象
-   :eval yes/no/never/query - 実行制御
-   :cache yes/no - 結果のキャッシュ


# 多言語混在プログラミング

-   同一ドキュメント内での複数言語
-   言語間のデータ受け渡し
-   設定ファイル生成の例（init.el, config.yaml等）


# 実践例: Emacs設定のLiterate化

-   README.org から init.el を生成
-   設定の説明とコードの一体化
-   org-babel-load-file の活用
