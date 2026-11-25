---
title: "8.2. 大規模ファイルの運用戦略"
---



# Monolithアプローチ

-   単一ファイルの利点
-   限界点（数MB、数万行）
-   いつ分割を検討するか


# ファイル分割戦略

-   トピック別分割
-   年次/月次分割
-   \#+INCLUDE: での統合
-   org-agenda-files での管理


# アーカイブ

-   C-c C-x C-a: サブツリーアーカイブ
-   org-archive-location
-   日付ベースアーカイブ
-   アーカイブからの検索


# org-attach

-   添付ファイル管理
-   ID連携
-   ディレクトリ構造
-   継承設定


# 巨大ファイルの設定

-   large-file-warning-threshold
-   org-startup-with-inline-images nil
-   折りたたみ状態の保存
