(require 'ox-typst)
(require 'oc)
(require 'oc-basic)

(setq org-export-with-toc nil)

;; org-cite を Typst の #cite() 形式にエクスポートするプロセッサを定義
(org-cite-register-processor 'typst-cite
  :export-citation
  (lambda (citation _style _ info)
    (let* ((references (org-cite-get-references citation))
           (keys (mapcar (lambda (ref) (org-element-property :key ref)) references)))
      (mapconcat (lambda (key) (format "#cite(<%s>)" key)) keys " ")))
  :export-bibliography
  (lambda (_keys _files _style _props _backend info)
    "#bibliography(\"references.bib\", title: [参考文献], style: \"ieee\")"))

;; Typst エクスポート時に typst-cite プロセッサを使用
(setq org-cite-export-processors '((typst typst-cite) (t basic)))

(org-export-define-backend 'typst-slide
  '((export-block . org-typst-export-block)
    (headline . org-typst-headline)
    (item . org-typst-item)
    (keyword . org-typst-keyword)
    (section . org-typst-section)
    (src-block . org-typst-src-block))
  :menu-entry
  '(?y "Export to Typst"
       ((?F "As Typst buffer" org-typst-export-as-typst)
        (?f "As Typst file" org-typst-export-to-typst)
        (?p "As PDF file" org-typst-export-to-pdf)))
  :options-alist
  '((:typst-format-drawer-function nil nil #'(lambda (_ contents) contents))
    (:typst-format-inlinetask-function nil
                                       nil
                                       #'(lambda (_ contents) contents))))

(defun org-typst-slide-export-as-typst (&optional async subtreep visible-only body-only ext-plist)
  (interactive)
  (org-export-to-buffer 'typst-slide "*Org Typst Slide Export*"
    async subtreep visible-only body-only ext-plist))

(defun org-typst-slide-export-to-typst (&optional async subtreep visible-only body-only ext-plist)
  (interactive)
  (let ((outfile (org-export-output-file-name ".typ" subtreep)))
    (org-export-to-file 'typst-slide outfile
      async subtreep visible-only body-only ext-plist)))
