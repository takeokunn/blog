(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-refresh-contents)
(package-initialize)
(package-install 'ox-hugo)
(package-install 'org-roam)

(require 'ox-hugo)
(require 'org-roam)
(require 'org-roam-db)

(setq org-roam-directory "./")
(org-roam-db-autosync-enable)

(defun export-org-files ()
  "Re-exports all Org-roam files to Hugo markdown."
  (interactive)
  (let ((org-id-extra-files (directory-files-recursively default-directory "org")))
    (dolist (f (append (file-expand-wildcards "org/*.org")
                       (file-expand-wildcards "org/**/*.org")))
      (with-current-buffer (find-file f)
        (org-hugo-export-wim-to-md)))))

(defun collect-backlinks-string (backend)
  (when (org-roam-node-at-point)
    (goto-char (point-max))
    ;; Add a new header for the references
    (let* ((backlinks (org-roam-backlinks-get (org-roam-node-at-point))))
      (when (> (length backlinks) 0)
        (insert "\n\n* Backlinks\n")
        (dolist (backlink backlinks)
          (message (concat "backlink: " (org-roam-node-title (org-roam-backlink-source-node backlink))))
          (let* ((source-node (org-roam-backlink-source-node backlink))
                 (node-file (org-roam-node-file source-node))
                 (file-name (file-name-nondirectory node-file))
                 (title (org-roam-node-title source-node)))
            (insert
             (format "- [[./%s][%s]]\n" file-name title))))))))

(add-hook 'org-export-before-processing-functions #'collect-backlinks-string)
