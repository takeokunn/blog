---
title: "6.2. 次世代の検索とナビゲーション"
---



# 補完フレームワーク

-   Vertico: ミニバッファ補完
-   Orderless: 柔軟なマッチング
-   Marginalia: 注釈表示
-   Embark: コンテキストアクション


# Consult

-   consult-org-heading
-   consult-org-agenda
-   consult-ripgrep + Org
-   プレビュー機能


# org-ql

-   SQLライクなクエリ
-   複雑な条件でのタスク検索
-   カスタムビューの作成


# 高速ジャンプ

-   avy + Org
-   ace-link
-   org-goto の改善


# embark-org

-   EmbarkのOrg-mode専用アクション
    -   リンク上でのアクション
    -   見出し上でのアクション
    -   タイムスタンプ上でのアクション
-   主要なアクション
    -   org-store-link: リンクの保存
    -   org-insert-link: リンクの挿入
    -   org-open-at-point: リンクを開く
    -   org-todo: TODO状態の変更
-   カスタムアクションの追加
    -   embark-define-keymap
    -   org特有のコンテキスト
-   Consultとの連携
    -   consult-org-heading + embark
    -   検索結果への即座のアクション
