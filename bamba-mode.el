;;; bamba-mode-el -- Major mode for editing WPDL files

;; Author: prestosilver
;; Created: 25 Sep 2000

;;; Commentary:
;;
;; This mode is an example used in a tutorial about Emacs
;; mode creation. The tutorial can be found here:
;; http://two-wugs.net/emacs/mode-tutorial.html

;;; Code:
(defvar bamba-mode-hook nil)
(defvar bamba-mode-map
  (let ((smap (make-keymap)))
    (define-key smap "\C-j" 'newline-and-indent)
    smap)
  "Keymap for BAMBA major mode.")

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.bam\\'" . bamba-mode))

(defconst bamba-font-lock-keywords-1
  (list
   '("\\<\\(comptime\\|return\\|extern\\|import\\|break\\|class\\|entry\\)\\>" . font-lock-constant-face)
  )
  "Minimal highlighting expressions for BAMBA mode.")
(defconst bamba-font-lock-keywords-2
  (append bamba-font-lock-keywords-1
    (list
     '("\\<\\(brk\\|macro\\|ret\\|asm\\|of\\|temp\\|push\\|oper\\|-\\|*\\|,\\|/%\\|+\\|^\\|!\\|!=\\|==\\|<\\|>\\|&&\\|||\\|()\\|sys0\\|sys1\\|sys2\\|sys3\\|sys4\\|sys5\\|sys6\\|[\\|]\\|\\)\\>" . font-lock-builtin-face)
    )
  )
  "Minimal highlighting expressions for BAMBA mode.")
(defvar bamba-font-lock-keywords bamba-font-lock-keywords-2
  "Default highlighting expressions for BAMBA mode.")


;(defconst bamba-font-lock-keywords-1
;  (list
;   '("\\<\\(argv?\\|co\\(?:py\\|vr\\)\\|d\\(?:isc\\|ump\\)\\|lambda\\|nop\\|putc?\\|readc?\\|s\\(?:im\\|wap\\)\\)\\>" . font-lock-builtin-face)
;   '("\\<\\(proc\\)\\>" . font-lock-constant-face)
;   '("\\('\\w*'\\)" . font-lock-variable-name-face)
;  )
;  "Minimal highlighting expressions for BAMBA mode.")

; (regexp-opt '("sim" "lambda" "nop" "swap" "dump" "copy"
; "covr" "readc" "read" "putc" "put" "disc" "argv" "argc"
; "envp" "sys0" "sys1" "sys2" "sys3") t)
; ".\\(argv?\\|co\\(?:py\\|vr\\)\\|d\\(?:isc\\|ump\\)\\|lambda\\|nop\\|putc?\\|readc?\\|s\\(?:im\\|wap\\)\\)"

(defvar bamba-mode-syntax-table
  (let ((syntax-table (make-syntax-table)))
    ; This is added so entity names with underscores can be more easily parsed
    (modify-syntax-entry ?_ "w" syntax-table)
    (modify-syntax-entry ?\" "w" syntax-table)

    ; Comment styles are same as C++
    (modify-syntax-entry ?{ "<" syntax-table)
    (modify-syntax-entry ?} ">" syntax-table)
    syntax-table)
  "Syntax table for bamba-mode.")

(defun bamba-mode ()
  "Major mode for editing bamba files."
  (interactive)
  (kill-all-local-variables)
  (set-syntax-table bamba-mode-syntax-table)
  (use-local-map bamba-mode-map)
  (set (make-local-variable 'font-lock-defaults) '(bamba-font-lock-keywords))
  (setq major-mode 'bamba-mode)
  (setq mode-name "BAMBA")
  (run-hooks 'bamba-mode-hook))

(defun org-babel-execute:bamba (body params)
  "Execute a block of Bamba code with org-babel."
  (let ((in-file (org-babel-temp-file "s" ".slm"))
       (verbosity (or (cdr (assq :verbosity params)) 0)))
    (with-temp-file in-file
      (insert body))
    (let ((out-file (org-babel-temp-file "s" ""))
         (verbosity (or (cdr (assq :verbosity params)) 0)))
    (org-babel-eval
      (format "bamba -o %s %s > /dev/null; chmod +X %s; %s"
              (org-babel-process-file-name out-file)
              (org-babel-process-file-name in-file)
              (org-babel-process-file-name out-file)
              (org-babel-process-file-name out-file))
      ""))))


(provide 'org-babel-execute:bamba)
(provide 'bamba-mode)
;;; bamba-mode.el ends here
