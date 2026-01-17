---
title: "1.2. Org構文の基礎と構造化"
---



# アウトライン構造

-   見出しレベル（\* から \*\*\*\*\*\*\*\*）
-   見出しのプロパティ（TODO、優先度、タグ）
-   折りたたみ（Fold）の概念


# プロパティとドロワー

-   :PROPERTIES: ブロックの構文
-   標準プロパティ（ID、CREATED、CUSTOM<sub>ID等</sub>）
-   カスタムプロパティの定義と活用
-   :LOGBOOK: による履歴管理


# ブロック構文

-   \#+BEGIN<sub>xxx</sub> &#x2026; #+END<sub>xxx</sub> の基本形
-   SRCブロック（コード）
-   QUOTEブロック（引用）
-   EXAMPLEブロック（整形済みテキスト）
-   CENTERブロック、VERSEブロック


# インライン要素

-   強調（\*bold\*, *italic*, <span class="underline">underline</span>, ~~strikethrough~~, `code`, =verbatim=）
-   リンク
-   脚注（ `[fn:1]` ）
-   LaTeX数式（$inline$, \begin{equation}&#x2026;）


# リスト

-   順序なしリスト（-, +, \*）
-   順序付きリスト（1., 1)）
-   **定義リスト（term:** definition）
-   チェックボックス（[ ], [X], [-]）
