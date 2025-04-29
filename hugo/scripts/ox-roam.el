(require 'ox-hugo)
(require 'org-roam)

(setq org-roam-db-location "./org-roam.db")
(setq org-id-locations-file "./.org-id-locations")
(setq org-roam-directory default-directory)

(org-roam-db-sync)

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

(defun export-org-roam-files ()
  "Exports Org-Roam files to Hugo markdown."
  (interactive)
  (let ((org-id-extra-files (directory-files-recursively default-directory "org")))
    (dolist (f (append (file-expand-wildcards "org/about.org")
                       (file-expand-wildcards "org/diary/*.org")
                       (file-expand-wildcards "org/fleeting/*.org")
                       (file-expand-wildcards "org/index/*.org")
                       (file-expand-wildcards "org/literature/*.org")
                       (file-expand-wildcards "org/permanent/*.org")
                       (file-expand-wildcards "org/structure/*.org")
                       (file-expand-wildcards "org/poem/*.org")))
      (with-current-buffer (find-file f)
        (org-hugo-export-wim-to-md)))))
