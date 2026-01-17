---
title: "Appendix G. 著名Emacsユーザーの設定から学ぶ"
---



# Carsten Dominik氏（Org Mode作者）

Org Modeの生みの親であるCarsten Dominik氏の設計哲学を理解することは、Org Modeを効果的に使う上で非常に重要です。

-   基本的な使い方の哲学
    -   プレーンテキストの力
    -   漸進的な複雑さの導入
    -   ユーザーの自由度を最大化
-   シンプルさへのこだわり
    -   必要最小限の設定から始める
    -   機能は必要になってから追加
-   参考リソース
    -   [Org Mode Tutorial by David O'Toole](https://orgmode.org/worg/org-tutorials/orgtutorial_dto.html)（Carsten氏推奨）
    -   Google Tech Talk: "Org Mode for Emacs"


# Howard Abrams氏

Literate DevOpsの提唱者として知られるHoward Abrams氏は、org-babelを駆使した設定管理の第一人者です。

-   Literate DevOpsの概念
    -   インフラ作業をOrg文書として記録
    -   実行可能なドキュメント
    -   知識の永続化
-   org-babel活用の極致
    -   シェルスクリプト、Python、SQLの統合
    -   サーバー管理のワークフロー
-   dot-files管理
    -   Org文書からEmacsの設定をtangle
    -   設定の説明とコードの一体化
-   参考リソース
    -   [GitHub: howardabrams/dot-files](https://github.com/howardabrams/dot-files)
    -   [Literate DevOps](https://howardism.org/Technical/Emacs/literate-devops.html)


# Sacha Chua氏

Emacs Newsの週刊キュレーターとして、Emacsコミュニティに多大な貢献をしているSacha Chua氏の設定は実用性に優れています。

-   Emacs News キュレーター
    -   毎週のEmacs関連ニュースまとめ
    -   コミュニティへの橋渡し
-   Weekly Review実践
    -   GTDの週次レビューをOrg Modeで実装
    -   org-agendaのカスタムビュー
-   ビジュアル化の工夫
    -   org-modeによるスケッチノート
    -   図解を活用した情報整理
    -   アイデアの可視化
-   参考リソース
    -   [Sacha's Emacs configuration](https://sachachua.com/dotemacs/)
    -   [Emacs Blog Posts](https://sachachua.com/blog/category/emacs/)
    -   [GitHub: sachac/.emacs.d](https://github.com/sachac/.emacs.d)


# Bernt Hansen氏

GTDメソッドをOrg Modeで実装する際のバイブルともいえる詳細なドキュメントを公開しています。

-   GTD実装の詳細解説
    -   包括的なOrg Modeワークフロー
    -   タスク状態の設計
    -   プロジェクト管理手法
-   Worgへの貢献
    -   多くのチュートリアルとガイド
    -   ベストプラクティスの文書化
-   org-agendaのマスター
    -   複雑なカスタムビュー
    -   効率的なタスク処理
-   参考リソース
    -   [Org Mode - Organize Your Life In Plain Text!](https://doc.norang.ca/org-mode.html)


# Nicolas Goaziou氏（org-element作者）

Org Modeのパーサーであるorg-elementの作者として、Org Modeの内部構造をもっとも理解している開発者の一人です。

-   org-element設計思想
    -   文書の構造化表現
    -   解析と操作のAPI
-   パーサーの内部構造
    -   要素と対象の区別
    -   構文木の構築
-   コントリビューションの方法
    -   Org Modeへのパッチ投稿
    -   メーリングリストでの議論
-   参考リソース
    -   [Org Element API](https://orgmode.org/worg/dev/org-element-api.html)
    -   Org Mode メーリングリストアーカイブ


# Karl Voit氏

PIM（Personal Information Management）の研究者として、タグやファイル管理に関する体系的なアプローチを提唱しています。

-   タグの体系的活用
    -   階層的タグ設計
    -   検索効率の最適化
-   ファイル命名規則
    -   日付ベースの命名
    -   一貫性のある管理
-   PIM（Personal Information Management）
    -   情報管理の学術的アプローチ
    -   長期的な持続可能性
-   参考リソース
    -   [Karl Voit's PIM Articles](https://karl-voit.at/tags/pim/)
    -   [GitHub: novoid/dot-emacs](https://github.com/novoid/dot-emacs)


# Protesilaos Stavrou氏（Prot）

modus-themesの作者として知られ、Emacsの哲学と実践について深い洞察をもつユーザーです。

-   modus-themes作者
    -   アクセシビリティを重視したテーマ
    -   WCAG準拠のコントラスト
-   Emacs哲学
    -   シンプルさと拡張性のバランス
    -   カスタマイズの価値
-   denote開発者
    -   シンプルなノートテイキングツール
    -   ファイル名ベースのメタデータ
    -   Org Modeとの統合
-   シンプルなワークフロー
    -   過度な複雑さを避ける
    -   本質に集中
-   参考リソース
    -   [Prot's Emacs configuration](https://protesilaos.com/emacs/dotemacs)
    -   [Denote package](https://protesilaos.com/emacs/denote)
    -   [GitHub: protesilaos/dotfiles](https://github.com/protesilaos/dotfiles)


# System Crafters（David Wilson氏）

YouTubeでEmacsチュートリアルを提供し、Emacs入門者に大きな影響を与えています。

-   YouTube解説シリーズ
    -   Emacs From Scratch
    -   Org Mode入門シリーズ
    -   ライブストリーミング
-   org-roam実践
    -   Zettelkasten手法の実装
    -   知識管理のワークフロー
-   Crafted Emacsプロジェクト
    -   合理的なデフォルト設定
    -   モジュラーな設計
-   参考リソース
    -   [YouTube: System Crafters](https://www.youtube.com/@SystemCrafters)
    -   [GitHub: SystemCrafters/crafted-emacs](https://github.com/SystemCrafters/crafted-emacs)
    -   [David Wilson's Emacs Config](https://config.daviwil.com/emacs)


# 日本のコミュニティ

日本語環境でのOrg Mode利用には、日本のコミュニティからの情報が欠かせません。

-   rubikitch氏の貢献
    -   日本語でのEmacs解説
    -   多数の書籍執筆
    -   パッケージ開発
-   日本語情報源
    -   Qiitaの記事
    -   Zennの記事
    -   日本語ブログ
-   日本特有の設定
    -   日本語入力との統合
    -   SKK、mozc等との設定
    -   日本語フォント設定
    -   日本語でのorg-export設定
-   参考リソース
    -   [Emacs JP](https://emacs-jp.github.io/)
    -   [Qiita: org-mode タグ](https://qiita.com/tags/orgmode)


# 設定を学ぶリソース

他者の設定から学ぶための情報源をまとめます。

-   GitHub dotfiles検索のコツ
    -   `topic:dotfiles language:emacs-lisp` で検索
    -   スター数でソート
    -   最近の更新をチェック
-   Doom Emacs, Spacemacsのorg設定
    -   [Doom Emacs org module](https://github.com/doomemacs/doomemacs/tree/master/modules/lang/org)
    -   [Spacemacs org layer](https://github.com/syl20bnr/spacemacs/tree/develop/layers/%2Bemacs/org)
    -   ディストリビューションの設定から学ぶ
-   Worgの設定例
    -   [Org Configurations](https://orgmode.org/worg/org-configs/index.html)
    -   コミュニティの知識集積
-   Reddit r/orgmode
    -   [r/orgmode](https://www.reddit.com/r/orgmode/)
    -   質問と回答の宝庫
    -   設定共有スレッド


# 設定を参考にする際の注意点

他者の設定を参考にする際は、次の点に注意が必要です。

-   バージョンの違い
    -   古い設定は動かないことがある
    -   非推奨になった関数の使用
    -   新機能を活用できていない可能性
-   環境の違い
    -   OS依存の設定
    -   パッケージマネージャーの違い
    -   インストール済みパッケージの前提
-   そのまま使わず理解する
    -   なぜその設定が必要かを理解
    -   自分のワークフローに合うか検討
    -   コードを読んで学ぶ姿勢
-   段階的な導入
    -   一度にすべてを取り込まない
    -   小さな変更から始める
    -   問題が起きたら切り分けやすくする
    -   変更ごとに動作確認
