---
title: "2.8. org-columnによるプロパティの俯瞰ビュー"
---



# Column Viewとは

Column Viewは、Org-modeのエントリに設定されたプロパティをスプレッドシートのように表形式で俯瞰・編集できる機能です。


## スプレッドシート的な表示

```org
* プロジェクト
  :PROPERTIES:
  :COLUMNS: %25ITEM %10TODO %10PRIORITY %15DEADLINE
  :END:
** タスクA
   :PROPERTIES:
   :TODO: DOING
   :PRIORITY: A
   :END:
** タスクB
   :PROPERTIES:
   :TODO: TODO
   :PRIORITY: B
   :END:
```

Column Viewを有効にすると、次のような表形式で表示されます:

    | ITEM                    | TODO       | PRIORITY   | DEADLINE        |
    |-------------------------+------------+------------+-----------------|
    | プロジェクト            |            |            |                 |
    | タスクA                 | DOING      | A          |                 |
    | タスクB                 | TODO       | B          |                 |


## プロパティを列として可視化

Column Viewでは、各プロパティが列として表示され、階層構造を保ったまま一覧できる。 これにより、多数のタスクのステータスや属性を一目で把握できる。


## org-agendaとの違い

| 機能  | Column View    | org-agenda   |
| ----- | -------------- | ------------ |
| 表示形式 | スプレッドシート（列ベース） | リスト（行ベース） |
| 対象範囲 | 現在のサブツリー/バッファ | 複数ファイル横断可能 |
| 編集  | その場で編集可能 | 主に閲覧用（一部編集可） |
| プロパティ | 任意のプロパティを表示 | 日付ベースの情報が中心 |
| 集計  | サマリータイプで自動集計 | 統計情報は別途 |


# COLUMNS プロパティの定義


## 基本構文

COLUMNS プロパティは次の構文で定義します:

```text
%[WIDTH]PROPERTY[(TITLE)][{SUMMARY-TYPE}]
```

```org
:PROPERTIES:
:COLUMNS: %25ITEM %10TODO %3PRIORITY %15DEADLINE
:END:
```


## 幅指定（%10, %20等）

幅は%の後に数値で指定する。文字数を表す:

```org
:COLUMNS: %40ITEM(Task) %8TODO(Status) %3PRIORITY(P) %20DEADLINE(Due)
```

```emacs-lisp
;; 幅指定の例
;; %40ITEM  → 40文字幅でITEMを表示
;; %8TODO   → 8文字幅でTODOを表示
;; %3PRIORITY → 3文字幅でPRIORITYを表示
```


## タイトルのカスタマイズ

括弧内にカスタムタイトルを指定できる:

```org
:COLUMNS: %25ITEM(Task Name) %10TODO(Status) %3PRIORITY(Pri) %10TAGS(Labels)
```

日本語タイトルも使用可能:

```org
:COLUMNS: %30ITEM(タスク名) %8TODO(状態) %3PRIORITY(優先度) %15DEADLINE(締切)
```


## 継承と階層

COLUMNS定義は階層的に継承される:

```org
#+COLUMNS: %25ITEM %TODO %PRIORITY %TAGS

* プロジェクトA
  :PROPERTIES:
  :COLUMNS: %30ITEM %10Status %10Owner %15Deadline
  :END:
  ;; このサブツリーでは上記のCOLUMNS定義が適用される

** サブプロジェクトA-1
   :PROPERTIES:
   :COLUMNS: %20ITEM %10Progress{%}
   :END:
   ;; このサブツリーではさらに上書きされた定義が適用される
```


# 組み込みプロパティの活用

Org-modeには多くの組み込みプロパティが用意されている:


## ITEM - 見出しテキスト

見出しのテキスト本体を表示:

```org
:COLUMNS: %50ITEM(Task)
```


## TODO - TODO状態

TODOキーワードの状態を表示:

```org
:COLUMNS: %25ITEM %10TODO
```


## PRIORITY - 優先度

優先度（A, B, C等）を表示:

```org
:COLUMNS: %25ITEM %3PRIORITY
```


## TAGS - タグ

エントリに直接設定されたタグを表示:

```org
:COLUMNS: %25ITEM %15TAGS
```


## DEADLINE, SCHEDULED

日付情報を表示:

```org
:COLUMNS: %30ITEM %15SCHEDULED %15DEADLINE
```


## CLOCKSUM, CLOCKSUM<sub>T</sub>

クロッキングの合計時間を表示:

```org
:COLUMNS: %30ITEM %10CLOCKSUM %10CLOCKSUM_T
;; CLOCKSUM: 全期間の合計
;; CLOCKSUM_T: 今日の合計
```


## CATEGORY

カテゴリを表示:

```org
:COLUMNS: %25ITEM %15CATEGORY
```


## EFFORT（見積もり工数）

見積もり時間を表示:

```org
#+PROPERTY: Effort_ALL 0 0:10 0:30 1:00 2:00 3:00 4:00 5:00 6:00 7:00
#+COLUMNS: %40ITEM(Task) %17Effort(Estimated Effort){:} %CLOCKSUM
```


## ALLTAGS（継承タグ含む）

継承されたタグも含めて表示:

```org
:COLUMNS: %25ITEM %15TAGS %20ALLTAGS
```


## 組み込みプロパティの活用例

```org
#+COLUMNS: %50ITEM(Task) %TODO %3PRIORITY %10Effort{:} %10CLOCKSUM %20DEADLINE %TAGS

* 週間タスク
** TODO [#A] 重要な会議資料作成                                   :work:urgent:
   DEADLINE: <2024-03-15 Fri>
   :PROPERTIES:
   :Effort:   2:00
   :END:
** DOING [#B] コードレビュー                                      :work:
   :PROPERTIES:
   :Effort:   1:00
   :END:
```


# カスタムプロパティの定義と表示


## :PROPERTIES: でのプロパティ設定

```org
* プロジェクト管理
  :PROPERTIES:
  :COLUMNS: %25ITEM %10Status %10Owner %10Cost %15Due_Date
  :END:
** Webサイトリニューアル
   :PROPERTIES:
   :Status:   In Progress
   :Owner:    田中
   :Cost:     500000
   :Due_Date: 2024-04-01
   :END:
** 新機能開発
   :PROPERTIES:
   :Status:   Planning
   :Owner:    佐藤
   :Cost:     300000
   :Due_Date: 2024-05-15
   :END:
```


## 数値型、文字列型

プロパティの値は文字列として保存されるが、集計時に数値として扱える:

```org
:PROPERTIES:
:Cost:     100000      ;; 数値として扱われる
:Status:   "完了"       ;; 文字列として扱われる
:Progress: 75          ;; パーセンテージとして扱える
:END:
```


## 選択式プロパティ（<sub>ALL</sub> suffix）

`_ALL` サフィックスで選択可能な値を定義:

```org
* プロジェクト
  :PROPERTIES:
  :COLUMNS:     %20ITEM %9Approved(Approved?){X} %10Owner %11Status %10Time_Spent{:}
  :Owner_ALL:   Tammy Mark Karl Lisa Don
  :Status_ALL:  "In progress" "Not started yet" "Finished" ""
  :Approved_ALL: "[ ]" "[X]"
  :END:

** タスク1
   :PROPERTIES:
   :Owner:      Tammy
   :Status:     In progress
   :Approved:   [X]
   :Time_Spent: 1:45
   :END:
```

ファイル全体で使用する場合:

```org
#+PROPERTY: Status_ALL TODO DOING REVIEW DONE
#+PROPERTY: Priority_ALL High Medium Low
```


## デフォルト値

プロパティのデフォルト値を設定:

```org
* プロジェクト
  :PROPERTIES:
  :Status:   Not started
  :Owner:    未割当
  :END:
  ;; 子エントリはこれらの値を継承する
```


# Column View Summary タイプ

サマリータイプを使うと、子エントリの値を自動集計できる。


## 数値集計

| サマリー | 説明     | 使用例   |
| ---- | -------- | -------- |
| +    | 合計     | 工数や費用の合計 |
| $    | 通貨形式での合計 | 予算合計 |
| min  | 最小値   | 最短所要時間 |
| max  | 最大値   | 最長所要時間 |
| mean | 平均値   | 平均スコア |

```org
:COLUMNS: %25ITEM %10Cost{+} %10Time{:} %10Score{mean}
```


## 時間集計（:）

`:` サマリーは HH:MM 形式の時間を合計する:

```org
* プロジェクト
  :PROPERTIES:
  :COLUMNS: %30ITEM %10Time_Spent{:}
  :END:
** タスク1
   :PROPERTIES:
   :Time_Spent: 2:30
   :END:
** タスク2
   :PROPERTIES:
   :Time_Spent: 1:45
   :END:
;; 親の Time_Spent には自動的に 4:15 が表示される
```


## チェックボックス集計（X, X/）

| サマリー | 説明                     |
| ---- | ------------------------ |
| X    | すべて [X] なら [X]、それ以外は [-] |
| X/   | [完了数/総数] 形式で表示 |

```org
* 承認プロセス
  :PROPERTIES:
  :COLUMNS: %30ITEM %10Approved{X}
  :Approved_ALL: "[ ]" "[X]"
  :END:
** ステップ1
   :PROPERTIES:
   :Approved: [X]
   :END:
** ステップ2
   :PROPERTIES:
   :Approved: [X]
   :END:
** ステップ3
   :PROPERTIES:
   :Approved: [ ]
   :END:
;; 親のApprovedには [-] が表示される（全て完了していないため）
```


## 見積もり集計（est+）

```org
:COLUMNS: %30ITEM %10Effort{est+}
;; est+ は見積もりの低い値と高い値の範囲を集計
;; 例: 2-4 + 3-5 = 5-9
```


## パーセンテージ集計（%）

```org
* プロジェクト進捗
  :PROPERTIES:
  :COLUMNS: %40ITEM %10Progress{%}
  :END:
** 設計フェーズ
   :PROPERTIES:
   :Progress: 100
   :END:
** 実装フェーズ
   :PROPERTIES:
   :Progress: 50
   :END:
** テストフェーズ
   :PROPERTIES:
   :Progress: 0
   :END:
;; 親のProgressには平均値（50%）が表示される
```


## カスタムサマリー関数

Elispでカスタムサマリー関数を定義:

```emacs-lisp
;; カスタムサマリー関数を登録
(add-to-list 'org-columns-summary-types
             '("max-time" . org-columns--summary-max-time))

(defun org-columns--summary-max-time (values _printf)
  "HH:MM形式の時間の最大値を返す"
  (let ((max-minutes 0))
    (dolist (v values)
      (when (string-match "\\([0-9]+\\):\\([0-9]+\\)" v)
        (let ((minutes (+ (* 60 (string-to-number (match-string 1 v)))
                          (string-to-number (match-string 2 v)))))
          (when (> minutes max-minutes)
            (setq max-minutes minutes)))))
    (format "%d:%02d" (/ max-minutes 60) (% max-minutes 60))))
```

使用例:

```org
:COLUMNS: %30ITEM %15Max_Duration{max-time}
```


# Column Viewの操作


## Column Viewの開始と終了

```emacs-lisp
;; Column Viewを開始
;; C-c C-x C-c または M-x org-columns

;; Column Viewを終了
;; q または C-c C-x C-c
```


## 基本操作キーバインド

| キー        | 操作             |
| ----------- | ---------------- |
| C-c C-x C-c | Column View開始/終了 |
| q           | Column View終了  |
| g           | 表示を更新       |
| r           | Column View再構築 |
| e           | 現在のセルの値を編集 |
| v           | 値のフルテキストを表示 |
| S-LEFT      | 前の許可値に変更 |
| S-RIGHT     | 次の許可値に変更 |
| n / p       | 次/前の行に移動  |
| a           | サブツリー全体を表示 |
| c           | カラムを非表示/表示切り替え |


## 値の編集

```emacs-lisp
;; e: プロンプトで値を編集
;; v: 値のサイクル（_ALLで定義された値間を循環）
;; S-LEFT/S-RIGHT: 前/次の許可値に変更
```


## 表示の制御

```emacs-lisp
;; 特定のカラムを非表示にする
;; c キーでトグル

;; サブツリーの展開制御
;; a キーでサブツリー全体を表示
```


# org-columns-default-format の設定


## グローバル設定

init.elで設定:

```emacs-lisp
;; デフォルトのColumn View形式
(setq org-columns-default-format
      "%50ITEM(Task) %TODO %3PRIORITY %10TAGS %17Effort(Effort){:} %CLOCKSUM")

;; 別の設定例（タスク管理向け）
(setq org-columns-default-format
      "%40ITEM(Task) %8TODO(Status) %3PRIORITY(P) %15DEADLINE(Due) %10EFFORT{:}")

;; プロジェクト管理向け
(setq org-columns-default-format
      "%30ITEM(Task) %10Status %10Owner %10Progress{%} %15Due_Date")
```


## ファイル単位設定（#+COLUMNS:）

ファイルの先頭で定義:

```org
#+COLUMNS: %40ITEM(Task) %17Effort(Estimated Effort){:} %CLOCKSUM
#+PROPERTY: Effort_ALL 0 0:10 0:30 1:00 2:00 3:00 4:00 5:00 6:00 7:00

* タスク一覧
** TODO タスク1
   :PROPERTIES:
   :Effort:   1:00
   :END:
```


## サブツリー単位設定

特定のサブツリーにのみ適用:

```org
* プロジェクトA
  :PROPERTIES:
  :COLUMNS: %25ITEM %10Status %10Owner %15Deadline
  :Status_ALL: "Not Started" "In Progress" "Review" "Done"
  :Owner_ALL: Alice Bob Charlie
  :END:

* プロジェクトB
  :PROPERTIES:
  :COLUMNS: %25ITEM %10Priority{max} %10Cost{+}
  :Priority_ALL: 1 2 3 4 5
  :END:
```


# Dynamic Block との連携


## columnview Dynamic Block

Column Viewの内容をテーブルとして文書に埋め込める:

```org
#+BEGIN: columnview :hlines 1 :id local
| ITEM        | TODO | PRIORITY | Effort | CLOCKSUM |
|-------------+------+----------+--------+----------|
| プロジェクト |      |          |   4:30 |     3:15 |
| タスクA     | DONE | A        |   2:00 |     1:45 |
| タスクB     | TODO | B        |   2:30 |     1:30 |
#+END:
```


## :id 指定

```org
;; local: 現在のツリー
#+BEGIN: columnview :id local
#+END:

;; global: バッファ全体
#+BEGIN: columnview :id global
#+END:

;; 特定のID
#+BEGIN: columnview :id "project-overview"
#+END:
```

IDを指定する例:

```org
* Planning
  :PROPERTIES:
  :ID: planning-overview
  :COLUMNS: %25ITEM %10Status %10Progress{%}
  :END:

* レポートセクション
#+BEGIN: columnview :hlines 1 :id "planning-overview"
#+END:
```


## オプション一覧

| オプション       | 説明                    |
| ---------------- | ----------------------- |
| :id              | 対象（local/global/カスタムID） |
| :hlines          | 見出しレベル境界に水平線を追加 |
| :vlines          | 列間に垂直線を追加      |
| :maxlevel        | 表示する最大見出しレベル |
| :skip-empty-rows | 空行をスキップ          |
| :indent          | 階層に応じてインデント  |
| :match           | タグマッチングで絞り込み |
| :exclude-tags    | 除外するタグ            |

```org
#+BEGIN: columnview :hlines 2 :maxlevel 3 :skip-empty-rows t :id local
#+END:

;; タグでフィルタリング
#+BEGIN: columnview :hlines 1 :match "work+important" :id global
#+END:
```


## エクスポートへの活用

Dynamic Blockはエクスポート時にもそのままテーブルとして出力される:

```org
#+TITLE: プロジェクト進捗レポート

* 概要

本レポートはプロジェクトの現在の進捗を示す。

* 進捗一覧
#+BEGIN: columnview :hlines 1 :id "all-projects" :maxlevel 2
| ITEM            | Status      | Progress | Due Date   |
|-----------------+-------------+----------+------------|
| 全プロジェクト  |             |      65% |            |
| プロジェクトA   | In Progress |      80% | 2024-03-15 |
| プロジェクトB   | Planning    |      50% | 2024-04-01 |
#+END:
```

更新は `C-c C-x C-u` (`org-dblock-update`) で行う。


# 実践例


## プロジェクト進捗管理

```org
#+COLUMNS: %40ITEM(Task) %10Status %10Progress{%} %15Due_Date %10Owner

* プロジェクト: Webアプリ開発
  :PROPERTIES:
  :Status_ALL: "Not Started" "In Progress" "Review" "Done" "Blocked"
  :END:

** 要件定義フェーズ
   :PROPERTIES:
   :Status:   Done
   :Progress: 100
   :Due_Date: 2024-02-01
   :Owner:    佐藤
   :END:

*** 要件ヒアリング
    :PROPERTIES:
    :Status:   Done
    :Progress: 100
    :END:

*** 要件書作成
    :PROPERTIES:
    :Status:   Done
    :Progress: 100
    :END:

** 設計フェーズ
   :PROPERTIES:
   :Status:   In Progress
   :Progress: 60
   :Due_Date: 2024-02-28
   :Owner:    田中
   :END:

*** DB設計
    :PROPERTIES:
    :Status:   Done
    :Progress: 100
    :END:

*** API設計
    :PROPERTIES:
    :Status:   In Progress
    :Progress: 50
    :END:

*** UI設計
    :PROPERTIES:
    :Status:   Not Started
    :Progress: 0
    :END:

** 実装フェーズ
   :PROPERTIES:
   :Status:   Not Started
   :Progress: 0
   :Due_Date: 2024-04-30
   :Owner:    鈴木
   :END:
```


## 工数見積もり・実績管理

```org
#+PROPERTY: Effort_ALL 0:15 0:30 1:00 2:00 4:00 8:00
#+COLUMNS: %40ITEM(Task) %8Effort(Est.){:} %10CLOCKSUM(Actual) %10Diff

* スプリント#1
  :PROPERTIES:
  :COLUMNS: %40ITEM(Task) %8Effort(Est.){:} %10CLOCKSUM(Actual)
  :END:

** TODO ユーザー認証機能
   :PROPERTIES:
   :Effort:   4:00
   :END:
   :LOGBOOK:
   CLOCK: [2024-02-10 Sat 09:00]--[2024-02-10 Sat 11:30] =>  2:30
   :END:

** DOING データベースマイグレーション
   :PROPERTIES:
   :Effort:   2:00
   :END:
   :LOGBOOK:
   CLOCK: [2024-02-10 Sat 14:00]--[2024-02-10 Sat 15:00] =>  1:00
   :END:

** TODO APIエンドポイント実装
   :PROPERTIES:
   :Effort:   8:00
   :END:
```


## リソース管理

```org
#+COLUMNS: %30ITEM(Task) %10Assignee %8Status %10Start_Date %10End_Date %8Load{+}

* チームタスク割り当て
  :PROPERTIES:
  :Assignee_ALL: Alice Bob Charlie Diana
  :Status_ALL: Assigned Working Done Blocked
  :END:

** フロントエンド開発
   :PROPERTIES:
   :Assignee: Alice
   :Status:   Working
   :Start_Date: 2024-02-01
   :End_Date: 2024-02-28
   :Load:     100
   :END:

** バックエンド開発
   :PROPERTIES:
   :Assignee: Bob
   :Status:   Working
   :Start_Date: 2024-02-01
   :End_Date: 2024-03-15
   :Load:     80
   :END:

** インフラ構築
   :PROPERTIES:
   :Assignee: Charlie
   :Status:   Assigned
   :Start_Date: 2024-02-15
   :End_Date: 2024-03-01
   :Load:     60
   :END:
```


## 予算管理

```org
#+COLUMNS: %35ITEM(項目) %12Budget(予算){+} %12Spent(支出){+} %12Remaining(残額)

* 年間予算管理 2024
  :PROPERTIES:
  :COLUMNS: %35ITEM(項目) %12Budget(予算){+} %12Spent(支出){+} %12Remaining(残額)
  :END:

** 人件費
   :PROPERTIES:
   :Budget:    10000000
   :Spent:     2500000
   :Remaining: 7500000
   :END:

** 設備費
   :PROPERTIES:
   :Budget:    3000000
   :Spent:     1200000
   :Remaining: 1800000
   :END:

*** サーバー費用
    :PROPERTIES:
    :Budget:    1500000
    :Spent:     800000
    :Remaining: 700000
    :END:

*** ソフトウェアライセンス
    :PROPERTIES:
    :Budget:    1000000
    :Spent:     400000
    :Remaining: 600000
    :END:

*** オフィス機器
    :PROPERTIES:
    :Budget:    500000
    :Spent:     0
    :Remaining: 500000
    :END:

** 外注費
   :PROPERTIES:
   :Budget:    5000000
   :Spent:     0
   :Remaining: 5000000
   :END:
```


## 読書リスト管理

```org
#+COLUMNS: %40ITEM(Title) %6Rating{mean} %6Pages{+} %10Status %15Genre

* 2024年読書リスト
  :PROPERTIES:
  :Status_ALL: "未読" "読書中" "読了" "中断"
  :Genre_ALL: "技術書" "ビジネス" "小説" "その他"
  :Rating_ALL: 1 2 3 4 5
  :END:

** Clean Architecture
   :PROPERTIES:
   :Rating:  5
   :Pages:   400
   :Status:  読了
   :Genre:   技術書
   :Author:  Robert C. Martin
   :END:

** リファクタリング 第2版
   :PROPERTIES:
   :Rating:  4
   :Pages:   450
   :Status:  読書中
   :Genre:   技術書
   :Author:  Martin Fowler
   :END:

** The Pragmatic Programmer
   :PROPERTIES:
   :Rating:
   :Pages:   350
   :Status:  未読
   :Genre:   技術書
   :Author:  David Thomas, Andrew Hunt
   :END:
```


# Column View関連のElisp設定


## よく使う設定のまとめ

```emacs-lisp
;; デフォルトのカラム形式
(setq org-columns-default-format
      "%50ITEM(Task) %TODO %3PRIORITY %10TAGS %17Effort(Effort){:} %CLOCKSUM")

;; 見積もり時間の選択肢
(setq org-global-properties
      '(("Effort_ALL" . "0:15 0:30 1:00 2:00 3:00 4:00 6:00 8:00")))

;; Column Viewのフォントを固定幅に
(when (fboundp 'set-face-attribute)
  (set-face-attribute 'org-column nil
                      :height (face-attribute 'default :height)
                      :family (face-attribute 'default :family)))

;; Column Viewの面を設定
(custom-set-faces
 '(org-column ((t (:background "gray95" :strike-through nil :underline nil))))
 '(org-column-title ((t (:background "gray90" :weight bold)))))
```


## アジェンダでのColumn View

```emacs-lisp
;; アジェンダでのカラム形式
(setq org-agenda-overriding-columns-format
      "%20ITEM %DEADLINE %SCHEDULED %TODO %3PRIORITY")

;; アジェンダ表示時に自動でColumn Viewを有効化
(setq org-agenda-view-columns-initially nil)  ;; デフォルトはnil

;; カスタムアジェンダコマンドでColumn Viewを使用
(setq org-agenda-custom-commands
      '(("c" "Column View Agenda" alltodo ""
         ((org-agenda-overriding-columns-format "%40ITEM %DEADLINE %TODO %PRIORITY")
          (org-agenda-view-columns-initially t)))))
```


## 便利なカスタム関数

```emacs-lisp
;; Column Viewのトグル
(defun my/org-columns-toggle ()
  "Column Viewをトグルする"
  (interactive)
  (if org-columns-current-fmt
      (org-columns-quit)
    (org-columns)))

;; キーバインドを設定
(define-key org-mode-map (kbd "C-c C-x C") #'my/org-columns-toggle)

;; サブツリーのColumn Viewを表示
(defun my/org-columns-subtree ()
  "現在のサブツリーでColumn Viewを表示"
  (interactive)
  (org-narrow-to-subtree)
  (org-columns)
  (widen))
```


# まとめ

Column Viewは、Org-modeの強力なプロパティ管理機能を最大限に活用するための俯瞰ビューです。 スプレッドシートのような表形式でプロパティを一覧・編集でき、サマリータイプによる自動集計も可能。 プロジェクト管理、工数管理、予算管理など、さまざまな用途に応用できます。

Dynamic Blockと組み合わせることで、レポートの自動生成やエクスポートにも活用できる。 org-agendaが時間軸でのタスク俯瞰を得意とするのに対し、Column Viewはプロパティ軸での俯瞰を得意とする。 両者を使い分けることで、より効率的なタスク・プロジェクト管理が可能になる。
