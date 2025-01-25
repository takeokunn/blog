(require 'ox-typst)

(setq org-export-with-toc nil)

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
