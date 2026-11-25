---
title: "4.2. カスタムアジェンダビューの設計"
---



# org-agenda-custom-commandsの完全な構造

`org-agenda-custom-commands` はOrg-modeのアジェンダをカスタマイズするためのもっとも強力な変数です。この変数を理解することで、自分だけのタスク管理システムを構築できます。


## 基本構造: 6つの要素

```emacs-lisp
(setq org-agenda-custom-commands
      '((KEY DESC TYPE MATCH SETTINGS FILES)))
```

各要素の詳細:

| 要素     | 必須 | 説明                           |
| -------- | --- | ------------------------------ |
| KEY      | 必須 | 1文字のキー（C-c aの後に押すキー） |
| DESC     | 任意 | ディスパッチャーに表示される説明文 |
| TYPE     | 必須 | ビューの種類（agenda, alltodo, tags等） |
| MATCH    | 条件 | マッチ式（tagsタイプ等で使用） |
| SETTINGS | 任意 | ローカル設定のalist            |
| FILES    | 任意 | 検索対象ファイルのリスト       |


## TYPEに指定できる値

```emacs-lisp
;; 単一ビュータイプ
'agenda      ; カレンダービュー（SCHEDULED/DEADLINE付き）
'alltodo     ; すべてのTODOアイテム
'tags        ; タグマッチ（完了タスクも含む）
'tags-todo   ; タグマッチ（TODOのみ）
'todo        ; 特定のTODOキーワード
'search      ; 全文検索
'stuck       ; スタックプロジェクト

;; ブロックアジェンダ（複合ビュー）
'((agenda "") (alltodo ""))  ; 複数ビューを組み合わせ
```


## SETTINGSで使用できる主要オプション

```emacs-lisp
;; 表示関連
(org-agenda-overriding-header "カスタムヘッダー")
(org-agenda-prefix-format " %i %-12:c")
(org-agenda-remove-tags t)
(org-agenda-todo-keyword-format "%-1s")

;; 時間関連
(org-agenda-span 'day)    ; day, week, month, year, または数字
(org-agenda-start-day "+0d")
(org-agenda-start-on-weekday nil)

;; ソート関連
(org-agenda-sorting-strategy '(priority-down effort-up))

;; フィルタリング関連
(org-agenda-tag-filter-preset '("+work"))
(org-agenda-category-filter-preset '("+Project"))
(org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled))
```


# 単一ビューの定義


## agendaタイプ

日付ベースのカレンダービュー:

```emacs-lisp
;; 基本的な日間アジェンダ
("d" "Today" agenda ""
 ((org-agenda-span 'day)))

;; 週間アジェンダ
("w" "Week" agenda ""
 ((org-agenda-span 'week)
  (org-agenda-start-on-weekday 1)))  ; 月曜始まり

;; 今後2週間
("W" "Next 2 weeks" agenda ""
 ((org-agenda-span 14)
  (org-agenda-start-day "+0d")))
```


## alltodoタイプ

すべてのTODOアイテムを表示:

```emacs-lisp
;; 全TODOリスト
("T" "All TODOs" alltodo ""
 ((org-agenda-overriding-header "All TODO items")))

;; 優先度でソート
("p" "By Priority" alltodo ""
 ((org-agenda-overriding-header "Tasks by Priority")
  (org-agenda-sorting-strategy '(priority-down))))
```


## tagsタイプとtags-todoタイプ

タグやプロパティでフィルタリング:

```emacs-lisp
;; タグマッチ（完了も含む）
("h" "Home tasks (all)" tags "+@home"
 ((org-agenda-overriding-header "Home (including DONE)")))

;; タグマッチ（TODOのみ）
("H" "Home tasks (TODO)" tags-todo "+@home"
 ((org-agenda-overriding-header "Home tasks")))

;; 複合タグ条件
("O" "Office high priority" tags-todo "+@office+PRIORITY=\"A\""
 ((org-agenda-overriding-header "Urgent Office Tasks")))
```


## todoタイプ

特定のTODOキーワードでフィルタリング:

```emacs-lisp
;; WAITING状態のタスク
("W" "Waiting" todo "WAITING"
 ((org-agenda-overriding-header "Waiting for...")))

;; 複数キーワード
("N" "Next Actions" todo "NEXT|TODO"
 ((org-agenda-overriding-header "Next Actions")))
```


## searchタイプ

全文検索:

```emacs-lisp
;; インタラクティブ検索
("s" "Search" search ""
 ((org-agenda-overriding-header "Search Results")))

;; 事前定義された検索
("S" "Search meeting notes" search "meeting"
 ((org-agenda-files '("~/org/meetings.org"))))
```


# マッチ式の書き方


## タグ条件

```emacs-lisp
;; 基本的なタグ
"+work"         ; workタグを持つ
"-work"         ; workタグを持たない
"+work+urgent"  ; workとurgent両方を持つ
"+work|+home"   ; workまたはhomeを持つ
"+work-meeting" ; workを持ちmeetingを持たない
```


## TODOキーワード条件

```emacs-lisp
;; TODOキーワードとの組み合わせ
"+work/TODO"           ; workタグでTODO状態
"+work/!TODO"          ; workタグでTODO状態（厳密マッチ）
"+work/TODO|NEXT"      ; workタグでTODOまたはNEXT
"+work/!-DONE-CANCELLED"  ; 完了・キャンセル以外
```


## プロパティ条件

```emacs-lisp
;; プロパティ値でマッチ
"ENERGY=\"high\""           ; ENERGYプロパティがhigh
"Effort<30"                 ; 見積もり30分未満
"Effort>=\"1:00\""          ; 見積もり1時間以上
"LOCATION=\"office\""       ; 場所がoffice
"CATEGORY=\"project\""      ; カテゴリがproject
```


## 優先度条件

```emacs-lisp
;; 優先度でマッチ
"PRIORITY=\"A\""            ; 優先度A
"PRIORITY>=\"B\""           ; 優先度B以上（A, B）
"PRIORITY<\"C\""            ; 優先度C未満（A, B）
```


## 複合条件の例

```emacs-lisp
;; 複雑なマッチ式
"+@office+PRIORITY=\"A\"-meeting/TODO|NEXT"
;; 意味: @officeタグあり、優先度A、meetingタグなし、TODO or NEXT状態

"+project+Effort<=\"0:30\"+ENERGY=\"low\"/!-DONE"
;; 意味: projectタグ、30分以下、低エネルギー向け、未完了
```


# ブロックアジェンダ


## 基本構造

複数のビューを1つの画面に表示:

```emacs-lisp
(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((agenda "" ((org-agenda-span 'day)))
          (alltodo "" ((org-agenda-overriding-header "All Tasks")))))))
```


## GTDダッシュボード

```emacs-lisp
("g" "GTD Dashboard"
 ((agenda "" ((org-agenda-span 'day)
              (org-agenda-overriding-header "Today's Schedule")))

  (tags-todo "+inbox"
             ((org-agenda-overriding-header "Inbox - Process These")
              (org-agenda-skip-function
               '(org-agenda-skip-entry-if 'scheduled 'deadline))))

  (todo "NEXT"
        ((org-agenda-overriding-header "Next Actions")
         (org-agenda-sorting-strategy '(priority-down effort-up))))

  (todo "WAITING"
        ((org-agenda-overriding-header "Waiting For")))

  (tags-todo "+project-someday/!"
             ((org-agenda-overriding-header "Active Projects")
              (org-agenda-skip-function 'my/skip-non-stuck-projects)))))
```


## デイリーレビュー用

```emacs-lisp
("D" "Daily Review"
 ((agenda "" ((org-agenda-span 'day)
              (org-agenda-overriding-header "=== TODAY ===")))

  (agenda "" ((org-agenda-span 1)
              (org-agenda-start-day "+1d")
              (org-agenda-overriding-header "=== TOMORROW ===")))

  (tags-todo "+PRIORITY=\"A\""
             ((org-agenda-overriding-header "=== HIGH PRIORITY ===")))

  (todo "NEXT"
        ((org-agenda-overriding-header "=== NEXT ACTIONS ===")))

  (tags-todo "DEADLINE<=\"<+7d>\""
             ((org-agenda-overriding-header "=== UPCOMING DEADLINES ===")))))
```


## 週次レビュー用

```emacs-lisp
("R" "Weekly Review"
 ((agenda "" ((org-agenda-span 7)
              (org-agenda-start-on-weekday 1)
              (org-agenda-overriding-header "=== THIS WEEK ===")))

  ;; 完了タスク
  (tags "CLOSED>=\"<-7d>\""
        ((org-agenda-overriding-header "=== COMPLETED THIS WEEK ===")))

  ;; スタックプロジェクト
  (stuck ""
         ((org-agenda-overriding-header "=== STUCK PROJECTS ===")))

  ;; 未レビュー項目
  (tags-todo "-REVIEWED"
             ((org-agenda-overriding-header "=== NEEDS REVIEW ===")))

  ;; Someday/Maybe
  (tags-todo "+someday"
             ((org-agenda-overriding-header "=== SOMEDAY/MAYBE ===")))))
```


# ローカル設定


## org-agenda-overriding-header

セクションのヘッダーをカスタマイズ:

```emacs-lisp
;; シンプルなヘッダー
((org-agenda-overriding-header "My Custom Header"))

;; 装飾付きヘッダー
((org-agenda-overriding-header
  "\n===== HIGH PRIORITY TASKS =====\n"))

;; 関数によるダイナミックヘッダー
((org-agenda-overriding-header
  (lambda ()
    (format "Tasks as of %s" (format-time-string "%Y-%m-%d %H:%M")))))
```


## org-agenda-sorting-strategy

ソート順をカスタマイズ:

```emacs-lisp
;; 利用可能なソートキー
'priority-down    ; 優先度高い順
'priority-up      ; 優先度低い順
'effort-down      ; 見積もり時間長い順
'effort-up        ; 見積もり時間短い順
'time-down        ; 時刻遅い順
'time-up          ; 時刻早い順
'timestamp-down   ; タイムスタンプ新しい順
'timestamp-up     ; タイムスタンプ古い順
'scheduled-down   ; SCHEDULED遅い順
'scheduled-up     ; SCHEDULED早い順
'deadline-down    ; DEADLINE遅い順
'deadline-up      ; DEADLINE早い順
'ts-down          ; アクティブタイムスタンプ新しい順
'ts-up            ; アクティブタイムスタンプ古い順
'tsia-down        ; インアクティブタイムスタンプ新しい順
'tsia-up          ; インアクティブタイムスタンプ古い順
'todo-state-down  ; TODO状態逆順
'todo-state-up    ; TODO状態順
'category-keep    ; カテゴリ順（維持）
'category-up      ; カテゴリ昇順
'category-down    ; カテゴリ降順
'tag-up           ; タグ昇順
'tag-down         ; タグ降順
'alpha-up         ; アルファベット昇順
'alpha-down       ; アルファベット降順
'habit-up         ; 習慣スコア昇順
'habit-down       ; 習慣スコア降順

;; 複数キーの組み合わせ
((org-agenda-sorting-strategy
  '((agenda time-up priority-down category-keep)
    (todo priority-down effort-up category-keep)
    (tags priority-down effort-up)
    (search category-keep))))
```


## org-agenda-prefix-format

行のプレフィックスをカスタマイズ:

```emacs-lisp
;; フォーマット指定子
"%c"   ; カテゴリ
"%e"   ; 見積もり時間（Effort）
"%l"   ; 見出しレベル
"%i"   ; アイコン（時間依存）
"%s"   ; 追加情報（時間、警告等）
"%t"   ; 時刻（HH:MM形式）
"%T"   ; 時刻（HH:MM-HH:MM形式、範囲）
"%b"   ; ブレッドクラム（親見出し）

;; 幅指定
"%-12:c"   ; カテゴリを12文字で左揃え（短縮可）
"%12:c"    ; カテゴリを12文字で右揃え（短縮可）
"%-12c"    ; カテゴリを12文字で左揃え（短縮不可）

;; ビュータイプ別設定
((org-agenda-prefix-format
  '((agenda . " %i %-12:c%?-12t% s")
    (todo . " %i %-12:c")
    (tags . " %i %-12:c")
    (search . " %i %-12:c"))))

;; 見積もり時間を表示
((org-agenda-prefix-format " %i %-12:c [%e] "))

;; ブレッドクラム付き
((org-agenda-prefix-format " %i %-12:c%b "))
```


## org-agenda-todo-keyword-format

TODOキーワードの表示形式:

```emacs-lisp
;; デフォルト
((org-agenda-todo-keyword-format "%-1s"))

;; 固定幅
((org-agenda-todo-keyword-format "%-8s"))

;; 非表示
((org-agenda-todo-keyword-format ""))
```


# フィルタリング戦略


## org-agenda-skip-function

エントリをスキップする条件を指定:

```emacs-lisp
;; org-agenda-skip-entry-if を使用
;; スケジュール済みをスキップ
((org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled)))

;; 締切設定済みをスキップ
((org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline)))

;; タイムスタンプ付きをスキップ
((org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp)))

;; 正規表現マッチをスキップ
((org-agenda-skip-function
  '(org-agenda-skip-entry-if 'regexp "\\[#C\\]")))

;; NOT条件（スケジュールなしをスキップ = スケジュール済みのみ表示）
((org-agenda-skip-function
  '(org-agenda-skip-entry-if 'notscheduled)))

;; 複数条件（OR）
((org-agenda-skip-function
  '(org-agenda-skip-entry-if 'scheduled 'deadline)))
```


## org-agenda-skip-subtree-if

サブツリー全体をスキップ:

```emacs-lisp
;; TODO状態でないサブツリーをスキップ
((org-agenda-skip-function
  '(org-agenda-skip-subtree-if 'nottodo '("TODO" "NEXT"))))

;; 特定タグのサブツリーをスキップ
((org-agenda-skip-function
  '(org-agenda-skip-subtree-if 'regexp ":archive:")))
```


## カスタムスキップ関数

より複雑な条件:

```emacs-lisp
;; 子タスクがあるプロジェクトのみ表示（リーフタスクをスキップ）
(defun my/skip-non-projects ()
  "Skip entries that are not projects (have no subtasks)."
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (re-search-forward "^\*+ \\(TODO\\|NEXT\\)" subtree-end t)
        nil  ; 子タスクあり、スキップしない
      subtree-end)))  ; 子タスクなし、スキップ

;; 使用例
("P" "Projects" tags-todo "+project"
 ((org-agenda-skip-function 'my/skip-non-projects)
  (org-agenda-overriding-header "Active Projects")))
```

```emacs-lisp
;; スタックプロジェクトのみ表示
(defun my/skip-non-stuck-projects ()
  "Skip projects that have NEXT actions."
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (re-search-forward "^\*+ NEXT " subtree-end t)
        subtree-end  ; NEXT アクションあり、スキップ
      nil)))  ; NEXT なし、表示

;; 使用例
("S" "Stuck Projects" tags-todo "+project"
 ((org-agenda-skip-function 'my/skip-non-stuck-projects)
  (org-agenda-overriding-header "Stuck Projects (no NEXT action)")))
```

```emacs-lisp
;; 特定期間内のDEADLINEのみ表示
(defun my/skip-deadline-not-in-range ()
  "Skip entries without DEADLINE in the next 7 days."
  (let ((deadline (org-entry-get nil "DEADLINE")))
    (if (and deadline
             (time-less-p (org-time-string-to-time deadline)
                          (time-add (current-time) (days-to-time 7))))
        nil  ; 7日以内、表示
      (save-excursion (org-end-of-subtree t)))))  ; それ以外、スキップ
```

```emacs-lisp
;; 習慣以外をスキップ（習慣のみ表示）
(defun my/skip-non-habits ()
  "Skip entries that are not habits."
  (let ((style (org-entry-get nil "STYLE")))
    (if (and style (string= style "habit"))
        nil  ; 習慣、表示
      (save-excursion (org-end-of-subtree t)))))

;; 使用例
("H" "Habits" agenda ""
 ((org-agenda-span 'day)
  (org-agenda-skip-function 'my/skip-non-habits)
  (org-agenda-overriding-header "Daily Habits")))
```


## タグフィルターの事前設定

```emacs-lisp
;; 特定タグのみ
((org-agenda-tag-filter-preset '("+work")))

;; 複数タグ条件
((org-agenda-tag-filter-preset '("+work" "-meeting")))
```


## カテゴリフィルターの事前設定

```emacs-lisp
;; 特定カテゴリのみ
((org-agenda-category-filter-preset '("+Projects")))

;; カテゴリを除外
((org-agenda-category-filter-preset '("-Archive")))
```


# 実践的なビュー例（20パターン以上）


## 基本パターン


### （1）今日のアジェンダ

```emacs-lisp
("d" "Today's Agenda" agenda ""
 ((org-agenda-span 'day)
  (org-agenda-start-day "+0d")
  (org-agenda-overriding-header "Today's Schedule")))
```


### （2）今週のアジェンダ

```emacs-lisp
("w" "This Week" agenda ""
 ((org-agenda-span 'week)
  (org-agenda-start-on-weekday 1)
  (org-agenda-overriding-header "This Week")))
```


### （3）全TODOリスト

```emacs-lisp
("T" "All TODOs" alltodo ""
 ((org-agenda-overriding-header "All Open Tasks")
  (org-agenda-sorting-strategy '(priority-down category-keep))))
```


### （4）高優先度タスク

```emacs-lisp
("A" "Priority A tasks" tags-todo "+PRIORITY=\"A\""
 ((org-agenda-overriding-header "High Priority Tasks")
  (org-agenda-sorting-strategy '(effort-up))))
```


## タグ/プロパティ活用


### （5）コンテキスト別（@office, @home, @errands）

```emacs-lisp
;; オフィスでできるタスク
("co" "Office Tasks" tags-todo "+@office"
 ((org-agenda-overriding-header "Tasks for Office")
  (org-agenda-sorting-strategy '(priority-down effort-up))))

;; 自宅でできるタスク
("ch" "Home Tasks" tags-todo "+@home"
 ((org-agenda-overriding-header "Tasks for Home")
  (org-agenda-sorting-strategy '(priority-down effort-up))))

;; 外出時にできるタスク
("ce" "Errands" tags-todo "+@errands"
 ((org-agenda-overriding-header "Errands")
  (org-agenda-sorting-strategy '(priority-down))))
```


### （6）プロジェクト別

```emacs-lisp
;; プロジェクトAのタスク
("pa" "Project Alpha" tags-todo "+project_alpha"
 ((org-agenda-overriding-header "Project Alpha Tasks")))

;; 全プロジェクト一覧
("pp" "All Projects" tags-todo "+project-someday"
 ((org-agenda-overriding-header "Active Projects")
  (org-agenda-skip-function 'my/skip-non-projects)))
```


### （7）エネルギーレベル別

```emacs-lisp
;; 高エネルギー時向けタスク
("eh" "High Energy Tasks" tags-todo "ENERGY=\"high\""
 ((org-agenda-overriding-header "Tasks requiring focus")
  (org-agenda-sorting-strategy '(priority-down))))

;; 低エネルギー時向けタスク
("el" "Low Energy Tasks" tags-todo "ENERGY=\"low\""
 ((org-agenda-overriding-header "Easy tasks for tired moments")
  (org-agenda-sorting-strategy '(effort-up))))
```


### （8）所要時間別

```emacs-lisp
;; 5分以内のクイックタスク
("tq" "Quick Tasks (< 5min)" tags-todo "Effort<6"
 ((org-agenda-overriding-header "Quick Wins (under 5 minutes)")
  (org-agenda-sorting-strategy '(effort-up priority-down))))

;; 30分以内のタスク
("ts" "Short Tasks (< 30min)" tags-todo "Effort<31"
 ((org-agenda-overriding-header "Short Tasks (under 30 minutes)")
  (org-agenda-sorting-strategy '(effort-up priority-down))))

;; 1時間以上のタスク
("tl" "Long Tasks (> 1h)" tags-todo "Effort>60"
 ((org-agenda-overriding-header "Long Tasks (over 1 hour)")
  (org-agenda-sorting-strategy '(effort-down priority-down))))
```


## ブロックアジェンダ


### （9）GTDダッシュボード

```emacs-lisp
("g" "GTD Dashboard"
 ((agenda ""
          ((org-agenda-span 'day)
           (org-agenda-overriding-header "=== TODAY'S SCHEDULE ===")))

  (tags-todo "+inbox"
             ((org-agenda-overriding-header "=== INBOX (Process!) ===")
              (org-agenda-skip-function
               '(org-agenda-skip-entry-if 'scheduled 'deadline))))

  (todo "NEXT"
        ((org-agenda-overriding-header "=== NEXT ACTIONS ===")
         (org-agenda-sorting-strategy
          '(priority-down effort-up category-keep))))

  (todo "WAITING"
        ((org-agenda-overriding-header "=== WAITING FOR ===")
         (org-agenda-sorting-strategy '(timestamp-up))))

  (tags-todo "+project-someday/!"
             ((org-agenda-overriding-header "=== ACTIVE PROJECTS ===")
              (org-agenda-skip-function 'my/skip-non-projects)))

  (tags-todo "+someday"
             ((org-agenda-overriding-header "=== SOMEDAY/MAYBE ===")))))
```


### （10）デイリーレビュー用

```emacs-lisp
("D" "Daily Review"
 ((agenda ""
          ((org-agenda-span 'day)
           (org-agenda-overriding-header "=== TODAY ===")))

  (agenda ""
          ((org-agenda-span 1)
           (org-agenda-start-day "+1d")
           (org-agenda-overriding-header "=== TOMORROW ===")))

  (tags-todo "+PRIORITY=\"A\""
             ((org-agenda-overriding-header "=== HIGH PRIORITY ===")))

  (todo "NEXT"
        ((org-agenda-overriding-header "=== NEXT ACTIONS ===")
         (org-agenda-max-entries 10)))

  (tags "DEADLINE<=\"<+3d>\"+TODO=\"TODO\"|DEADLINE<=\"<+3d>\"+TODO=\"NEXT\""
        ((org-agenda-overriding-header "=== DEADLINES WITHIN 3 DAYS ===")))))
```


### （11）週次レビュー用

```emacs-lisp
("R" "Weekly Review"
 ((agenda ""
          ((org-agenda-span 7)
           (org-agenda-start-on-weekday 1)
           (org-agenda-overriding-header "=== THIS WEEK ===")))

  (tags "CLOSED>=\"<-7d>\""
        ((org-agenda-overriding-header "=== COMPLETED LAST 7 DAYS ===")
         (org-agenda-sorting-strategy '(tsia-down))))

  (stuck ""
         ((org-agenda-overriding-header "=== STUCK PROJECTS ===")))

  (tags-todo "+inbox"
             ((org-agenda-overriding-header "=== ITEMS IN INBOX ===")))

  (tags-todo "-REVIEWED+TODO=\"TODO\"|+TODO=\"NEXT\""
             ((org-agenda-overriding-header "=== NEEDS REVIEW ===")))

  (tags-todo "+someday"
             ((org-agenda-overriding-header "=== SOMEDAY/MAYBE ===")))))
```


## 高度なパターン


### （12）スタックプロジェクト（子タスクすべて完了で表示）

```emacs-lisp
(defun my/is-project-p ()
  "Check if current entry is a project (has subtasks)."
  (save-excursion
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (re-search-forward "^\*+ " subtree-end t))))

(defun my/skip-non-stuck-projects ()
  "Skip projects that have active next actions."
  (save-excursion
    (let ((subtree-end (org-end-of-subtree t)))
      (if (and (my/is-project-p)
               (not (re-search-forward "^\*+ \\(NEXT\\|TODO\\) " subtree-end t)))
          nil  ; Stuck: no active tasks
        subtree-end))))

("s" "Stuck Projects" tags-todo "+project"
 ((org-agenda-overriding-header "Projects without NEXT actions")
  (org-agenda-skip-function 'my/skip-non-stuck-projects)))
```


### （13）特定期間内のDEADLINE

```emacs-lisp
;; 今後7日以内のデッドライン
("d7" "Deadlines in 7 days"
 tags "DEADLINE<=\"<+7d>\"+DEADLINE>=\"<today>\""
 ((org-agenda-overriding-header "Upcoming Deadlines (7 days)")
  (org-agenda-sorting-strategy '(deadline-up priority-down))))

;; 今後30日以内のデッドライン
("d30" "Deadlines in 30 days"
 tags "DEADLINE<=\"<+30d>\"+DEADLINE>=\"<today>\""
 ((org-agenda-overriding-header "Upcoming Deadlines (30 days)")
  (org-agenda-sorting-strategy '(deadline-up))))

;; 期限切れのデッドライン
("do" "Overdue Deadlines"
 tags "DEADLINE<\"<today>\""
 ((org-agenda-overriding-header "OVERDUE!")
  (org-agenda-sorting-strategy '(deadline-up))))
```


### （14）最近完了したタスク

```emacs-lisp
;; 今日完了したタスク
("ct" "Completed Today" tags "CLOSED>=\"<today>\""
 ((org-agenda-overriding-header "Completed Today")))

;; 今週完了したタスク
("cw" "Completed This Week" tags "CLOSED>=\"<-7d>\""
 ((org-agenda-overriding-header "Completed This Week")
  (org-agenda-sorting-strategy '(tsia-down))))

;; 今月完了したタスク
("cm" "Completed This Month" tags "CLOSED>=\"<-30d>\""
 ((org-agenda-overriding-header "Completed This Month")
  (org-agenda-sorting-strategy '(tsia-down))))
```


### （15）クロック中タスク関連

```emacs-lisp
;; 最近クロックしたタスク
("C" "Recently Clocked"
 ((agenda ""
          ((org-agenda-span 1)
           (org-agenda-start-day "-0d")
           (org-agenda-log-mode-items '(clock))
           (org-agenda-include-inactive-timestamps t)
           (org-agenda-overriding-header "Clocked Today")))

  (tags "LAST_CLOCKED>=\"<-7d>\""
        ((org-agenda-overriding-header "Clocked This Week")))))
```


### （16）習慣トラッキング専用

```emacs-lisp
(defun my/skip-non-habits ()
  "Skip entries that don't have STYLE property set to habit."
  (let ((style (org-entry-get nil "STYLE")))
    (if (and style (string= style "habit"))
        nil
      (save-excursion (org-end-of-subtree t)))))

("H" "Habits" agenda ""
 ((org-agenda-span 'day)
  (org-agenda-skip-function 'my/skip-non-habits)
  (org-agenda-overriding-header "Daily Habits")
  (org-habit-show-all-today t)
  (org-habit-show-habits-only-for-today t)))
```


### （17）特定ファイルのみ

```emacs-lisp
;; 仕事用ファイルのみ
("fw" "Work File Only" alltodo ""
 ((org-agenda-files '("~/org/work.org"))
  (org-agenda-overriding-header "Tasks from work.org")))

;; 特定ディレクトリのファイルのみ
("fp" "Project Files" alltodo ""
 ((org-agenda-files (directory-files-recursively "~/org/projects/" "\\.org$"))
  (org-agenda-overriding-header "All Project Tasks")))
```


### （18）特定ファイルを除外

```emacs-lisp
(defun my/agenda-files-without-archive ()
  "Return agenda files excluding archive files."
  (seq-filter
   (lambda (f) (not (string-match-p "archive" f)))
   (org-agenda-files)))

("x" "Excluding Archives" alltodo ""
 ((org-agenda-files (my/agenda-files-without-archive))
  (org-agenda-overriding-header "Tasks (excluding archives)")))
```


### （19）カスタムソート

```emacs-lisp
;; カスタムソート関数
(defun my/agenda-sort-by-context (a b)
  "Sort by context tags (@office, @home, @errands)."
  (let* ((context-order '("@office" "@home" "@errands" "@phone" "@computer"))
         (ta (car (seq-filter (lambda (x) (member x context-order))
                              (org-get-tags (get-text-property 0 'org-marker a)))))
         (tb (car (seq-filter (lambda (x) (member x context-order))
                              (org-get-tags (get-text-property 0 'org-marker b)))))
         (pa (or (cl-position ta context-order :test 'equal) 99))
         (pb (or (cl-position tb context-order :test 'equal) 99)))
    (cond ((< pa pb) -1)
          ((> pa pb) +1)
          (t nil))))

;; org-agenda-cmp-user-defined に設定して使用
("u" "By Context" alltodo ""
 ((org-agenda-overriding-header "Tasks by Context")
  (org-agenda-cmp-user-defined 'my/agenda-sort-by-context)
  (org-agenda-sorting-strategy '(user-defined-up priority-down))))
```


### （20）検索結果の保存（エクスポート）

```emacs-lisp
;; アジェンダをファイルに書き出す設定
("E" "Export Views"
 ((agenda "" nil)
  (alltodo "" nil))
 ("~/org/exports/agenda.txt")  ; 出力ファイル
 )

;; HTML出力
("Eh" "Export HTML" agenda ""
 ((org-agenda-span 'week))
 ("~/org/exports/agenda.html"))
```


## 追加の実践パターン


### （21）2分ルール対応（すぐできるタスク）

```emacs-lisp
("2" "2-Minute Tasks" tags-todo "Effort<3"
 ((org-agenda-overriding-header "2-Minute Tasks (do now!)")
  (org-agenda-sorting-strategy '(priority-down))
  (org-agenda-max-entries 5)))
```


### （22）今日中にやるべきタスク

```emacs-lisp
("!" "Must Do Today"
 ((agenda ""
          ((org-agenda-span 'day)
           (org-agenda-overriding-header "=== SCHEDULED TODAY ===")))
  (tags "DEADLINE=\"<today>\""
        ((org-agenda-overriding-header "=== DUE TODAY ===")))
  (tags-todo "+PRIORITY=\"A\"-SCHEDULED>=\"<tomorrow>\""
             ((org-agenda-overriding-header "=== HIGH PRIORITY ===")))))
```


### （23）未スケジュールのタスク

```emacs-lisp
("U" "Unscheduled TODOs" alltodo ""
 ((org-agenda-overriding-header "Unscheduled Tasks")
  (org-agenda-skip-function
   '(org-agenda-skip-entry-if 'scheduled 'deadline 'timestamp))
  (org-agenda-sorting-strategy '(priority-down category-keep))))
```


### （24）委譲済みタスクの追跡

```emacs-lisp
("W" "Delegated Tasks" todo "DELEGATED"
 ((org-agenda-overriding-header "Delegated Tasks")
  (org-agenda-sorting-strategy '(timestamp-up))
  (org-agenda-prefix-format " %i %-12:c [%e] ")))
```


### （25）アーカイブ候補の確認

```emacs-lisp
("a" "Archive Candidates" tags "CLOSED<=\"<-30d>\""
 ((org-agenda-overriding-header "Completed over 30 days ago (archive?)")
  (org-agenda-sorting-strategy '(tsia-up))))
```


# キーバインドの階層化


## サブメニューの作成

```emacs-lisp
(setq org-agenda-custom-commands
      '(;; トップレベルコマンド
        ("d" "Dashboard" ...)

        ;; サブメニュー定義（文字列のペア）
        ("c" . "Contexts")  ; "c" でコンテキストサブメニュー

        ;; サブメニューのコマンド
        ("co" "Office" tags-todo "+@office" ...)
        ("ch" "Home" tags-todo "+@home" ...)
        ("ce" "Errands" tags-todo "+@errands" ...)
        ("cp" "Phone" tags-todo "+@phone" ...)

        ;; 別のサブメニュー
        ("p" . "Projects")
        ("pa" "All Projects" tags "+project" ...)
        ("ps" "Stuck Projects" stuck "" ...)
        ("pc" "Current Sprint" tags-todo "+sprint" ...)

        ;; 時間関連サブメニュー
        ("t" . "Time-based")
        ("tq" "Quick (< 5min)" tags-todo "Effort<6" ...)
        ("ts" "Short (< 30min)" tags-todo "Effort<31" ...)
        ("tl" "Long (> 1h)" tags-todo "Effort>60" ...)))
```


## 実践的な階層構造例

```emacs-lisp
(setq org-agenda-custom-commands
      '(;; === Quick Access (Single Key) ===
        ("d" "Today" agenda ""
         ((org-agenda-span 'day)
          (org-agenda-overriding-header "Today's Agenda")))

        ("n" "Next Actions" todo "NEXT"
         ((org-agenda-overriding-header "Next Actions")))

        ("g" "GTD Dashboard"
         ((agenda "" ((org-agenda-span 'day)))
          (todo "NEXT" nil)
          (todo "WAITING" nil)))

        ;; === Context Menu ===
        ("c" . "Context (@)")
        ("co" "Office" tags-todo "+@office"
         ((org-agenda-overriding-header "@ Office")))
        ("ch" "Home" tags-todo "+@home"
         ((org-agenda-overriding-header "@ Home")))
        ("ce" "Errands" tags-todo "+@errands"
         ((org-agenda-overriding-header "@ Errands")))
        ("cc" "Computer" tags-todo "+@computer"
         ((org-agenda-overriding-header "@ Computer")))
        ("cp" "Phone" tags-todo "+@phone"
         ((org-agenda-overriding-header "@ Phone")))

        ;; === Work Menu ===
        ("w" . "Work")
        ("wa" "All Work Tasks" tags-todo "+work"
         ((org-agenda-overriding-header "Work Tasks")))
        ("wm" "Meetings" tags "+work+meeting"
         ((org-agenda-overriding-header "Meetings")))
        ("wp" "Projects" tags-todo "+work+project"
         ((org-agenda-overriding-header "Work Projects")))
        ("wd" "Deadlines" tags "+work+DEADLINE<=\"<+14d>\""
         ((org-agenda-overriding-header "Work Deadlines (2 weeks)")))

        ;; === Review Menu ===
        ("r" . "Review")
        ("rd" "Daily Review"
         ((agenda "" ((org-agenda-span 'day)))
          (todo "NEXT" nil)))
        ("rw" "Weekly Review"
         ((agenda "" ((org-agenda-span 'week)))
          (stuck "" nil)
          (tags "CLOSED>=\"<-7d>\"" nil)))
        ("rm" "Monthly Review"
         ((tags "CLOSED>=\"<-30d>\"" nil)
          (tags-todo "+someday" nil)))

        ;; === Time/Effort Menu ===
        ("e" . "Effort/Energy")
        ("eq" "Quick (< 5min)" tags-todo "Effort<6"
         ((org-agenda-overriding-header "Quick Tasks")))
        ("es" "Short (< 15min)" tags-todo "Effort<16"
         ((org-agenda-overriding-header "Short Tasks")))
        ("em" "Medium (< 1h)" tags-todo "Effort<61"
         ((org-agenda-overriding-header "Medium Tasks")))
        ("el" "Low Energy" tags-todo "ENERGY=\"low\""
         ((org-agenda-overriding-header "Low Energy Tasks")))
        ("eh" "High Energy" tags-todo "ENERGY=\"high\""
         ((org-agenda-overriding-header "High Energy Tasks")))

        ;; === Archive/Cleanup ===
        ("A" . "Archive/Admin")
        ("Aa" "Archive Candidates" tags "CLOSED<=\"<-30d>\""
         ((org-agenda-overriding-header "Archive Candidates")))
        ("Au" "Unscheduled" alltodo ""
         ((org-agenda-skip-function
           '(org-agenda-skip-entry-if 'scheduled 'deadline))
          (org-agenda-overriding-header "Unscheduled Tasks")))))
```


# まとめ: カスタムビュー設計のベストプラクティス


## 設計原則

1.  **目的を明確に**: 各ビューは特定の質問に答えるべき
    -   「今日何をすべき？」
    -   「どのプロジェクトが停滞中？」
    -   「すぐできるタスクは？」

2.  **階層化を活用**: 関連するビューをグループ化

3.  **ソートを適切に**: ビューの目的に合ったソート順

4.  **情報過多を避ける**: 必要な情報のみ表示


## 推奨設定のテンプレート

```emacs-lisp
;; 完全な設定例
(setq org-agenda-custom-commands
      '(;; Daily Driver
        ("d" "Daily Agenda"
         ((agenda "" ((org-agenda-span 'day)
                      (org-agenda-overriding-header "=== TODAY ===")))
          (todo "NEXT"
                ((org-agenda-overriding-header "=== NEXT ACTIONS ===")))
          (tags-todo "+PRIORITY=\"A\""
                     ((org-agenda-overriding-header "=== HIGH PRIORITY ==="))))
         ((org-agenda-compact-blocks t)))

        ;; GTD Contexts
        ("c" . "Context")
        ("co" "Office" tags-todo "+@office" nil)
        ("ch" "Home" tags-todo "+@home" nil)

        ;; Reviews
        ("r" . "Review")
        ("rd" "Daily" agenda "" ((org-agenda-span 'day)))
        ("rw" "Weekly" agenda "" ((org-agenda-span 'week)))))

;; 関連設定
(setq org-agenda-window-setup 'current-window)
(setq org-agenda-restore-windows-after-quit t)
(setq org-agenda-compact-blocks nil)
(setq org-agenda-block-separator "")
```
