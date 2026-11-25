---
title: "5.3. org-citeと文献管理"
---



# org-citeとは

-   Org 9.5で導入された標準引用機能
-   外部パッケージ不要
-   拡張可能な設計


# 基本的な使い方

-   (??, ????) 形式
-   (??, ) でスタイル指定
-   複数引用 (??, a, ??, a)


# 文献ファイルの設定

-   \#+bibliography: file.bib
-   org-cite-global-bibliography
-   BibTeX/BibLaTeX形式


# 引用スタイル

-   著者年（author-year）
-   番号（numeric）
-   カスタムスタイル


# エクスポート時の処理

-   LaTeX出力: natbib/biblatex連携
-   HTML出力: csl-json
-   CSL（Citation Style Language）


# citar との連携

-   補完フレームワーク統合
-   Vertico/Consult対応
-   ファイルオープン、ノート作成


# org-ref との使い分け

-   org-ref: 学術論文向け、多機能
-   org-cite: 軽量、標準、カスタマイズ性
-   移行の考慮点
