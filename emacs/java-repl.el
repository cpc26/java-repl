; java-repl
(defvar java-repl-file-path "/Users/cpc26/opt/java_repl/bin/java-repl"
  "Path to the program used by `run-java-repl'")
;
(defvar java-repl-cli-arguments '()
  "Commandline arguments to pass to `java-repl-cli'")
;
(defvar java-repl-mode-map
  (let ((map (nconc (make-sparse-keymap) comint-mode-map)))
    ;; example definition
    (define-key map "\t" 'completion-at-point)
    map)
  "Basic mode map for `run-java-repl'")
;
(defvar java-repl-prompt-regexp "^\\(?:\\[[^@]+@[^@]+\\]\\)"
  "Prompt for `run-java-repl'.")
;
(defun run-java-repl ()
  "Run an inferior instance of `java-repl' inside Emacs."
  (interactive)
  (let* ((java-repl-program java-repl-file-path)
         (buffer (comint-check-proc "java-repl")))
    ;; pop to the "*java-repl*" buffer if the process is dead, the
    ;; buffer is missing or it's got the wrong mode.
    (pop-to-buffer-same-window
     (if (or buffer (not (derived-mode-p 'java-repl-mode))
             (comint-check-proc (current-buffer)))
         (get-buffer-create (or buffer "*java-repl*"))
       (current-buffer)))
    ;; create the comint process if there is no buffer.
    (unless buffer
      (apply 'make-comint-in-buffer "java-repl" buffer
             java-repl-program java-repl-cli-arguments)
      (java-repl-mode))))
(defun java-repl--initialize ()
  "Helper function to initialize java-repl"
  (setq comint-process-echoes t)
  (setq comint-use-prompt-regexp t))
;
(define-derived-mode java-repl-mode comint-mode "java-repl"
  "Major mode for `run-java-repl'.

\\<java-repl-mode-map>"
  nil "java-repl"
  ;; this sets up the prompt so it matches things like: [foo@bar]
  (setq comint-prompt-regexp java-repl-prompt-regexp)
  ;; this makes it read only; a contentious subject as some prefer the
  ;; buffer to be overwritable.
  (setq comint-prompt-read-only t)
  ;; this makes it so commands like M-{ and M-} work.
  (set (make-local-variable 'paragraph-separate) "\\'")
  (set (make-local-variable 'font-lock-defaults) '(java-repl-font-lock-keywords t))
  (set (make-local-variable 'paragraph-start) java-repl-prompt-regexp))

;; this has to be done in a hook. grumble grumble.
(add-hook 'java-repl-mode-hook 'java-repl--initialize)
;;;; END JAVA-REPL
