(defgroup as3-mode nil
  "Set of utility functions for running Flex SDK programs"
  :group 'languages)

(defvar *flex-home* (expand-file-name "~/Flex/SDK/4.0/"))

(defun as3-compile ()
  "Compiles the AS file using mxmlc (Flex compiler)"
  (interactive)
  (let ((source
	 (read-file-name "Select file to compile: "
			 (if (equal major-mode 'dired-mode)
			     default-directory
			   (buffer-file-name))))
	(source-path 
	 (read-file-name "Select project root directory: "
			 (if (equal major-mode 'dired-mode)
			     default-directory
			   (buffer-file-name))))
	(output 
	 (read-file-name "How should I call the output file?: "
			 (if (equal major-mode 'dired-mode)
			     default-directory
			   (buffer-file-name)))))
    (shell-command 
     (concat 
      *flex-home* "bin/mxmlc "
      source " -o " output " -sp " source-path
      " -static-link-runtime-shared-libraries=true"))))

(defun as3-debug (swf)
  "Starts fdb (Flex debugger) with the SWF you want to debug"
  (interactive "fSelect the file to debug: ")
  (term (concat *flex-home* "/bin/fdb"))
  (call-interactively 'term-mode)
  (rename-buffer "*(fdb)*")
  (insert (concat "r " (expand-file-name swf)))
  (term-send-input))

(defun as3-fcsh ()
  "Starts fcsh (Flex Compiler Shell)"
  (interactive)
  (term (concat *flex-home* "/bin/fcsh"))
  (call-interactively 'term-mode)
  (rename-buffer "*FCSh*"))

;; (setq auto-mode-alist (append '(("\\.pl$" . prolog-mode)
;; 				("\\.m$" . mercury-mode))
;; 			      auto-mode-alist))



(defface breakpoint-face
  '((((class color) (background dark))
     (:background "#551100"))		; dark brown
    (t (:inverse-video t)))
  "Face used to highlight current line."
  :group 'flash-debug)

(defvar breakpoint-overlay
  (make-overlay 1 1)
  "Overlay for highlighting.")

(overlay-put breakpoint-overlay
	     'face 'breakpoint-face)

(defun highlight-breakpoint ()
  "Highlights the line containing breakpoint"
  (interactive)
  (let ((beg (progn (beginning-of-line) (point)))
	(end (progn (end-of-line) (point))))
    (move-overlay breakpoint-overlay beg end)))

(defun unhighlight-breakpoint ()
  "Clears overlay created by entering a breakpoint"
  (interactive)
  (delete-overlay breakpoint-overlay))

(defun as3-get-checkers-buffer ()
  (interactive)
  (insert (buffer-name (process-buffer (get-process *ash-process-name*)))))

(defun as3-get-checkers-status ()
  (interactive)
  (insert (process-status *ash-process-name*)))

(defface as3-error-face
  '((((class color) (background dark))
     (:background "#551100"))
    (t (:inverse-video t)))
  "Face used to highlight as3 errors."
  :group 'as3-error)

(defun as3-highlight-error
  (buffer error-line error-col &optional error-text)
  "Highlights the line region containing as3 error"
  (let ((old-buffer (current-buffer))
	(old-line)
	(old-point)
	(error-overlay))
    (unwind-protect
	(progn
	  (set-buffer buffer)
	  (setq old-line (line-number-at-pos)
		old-point (point))
	  (goto-line error-line buffer)
	  (setq error-overlay (make-overlay 1 1 buffer))
	  (overlay-put error-overlay
	     'face 'as3-error-face)
	  (let ((beg (progn (beginning-of-line) (point)))
		(end (progn (end-of-line) (point))))
	    (move-overlay error-overlay beg end buffer))
	  (goto-line old-line)
	  (goto-char old-point))
      (set-buffer old-buffer))))

(defun as3-remove-highlight-error ()
  "Clears overlay created by `as3-highlight-error'"
  (delete-overlay *as3-error-overlay*))

(defun as3-checker-filter (proc string)
  (let ((old-buffer (current-buffer))
	(debug-on-error t))
    (display-buffer (process-buffer proc))
    (unwind-protect
        (let ((moving)
	      (error-text)
	      (error-line)
	      (error-col)
	      (searched-to))
          (set-buffer (process-buffer proc))
          (setq moving (= (point) (process-mark proc)))
          (save-excursion
            (goto-char (process-mark proc))
	    (setq searched-to
		  (when (string-match "\\[Compiler\\] Error" string)
		    (1+ (match-end 0))))
	    ;; This should have it's onw function
	    (if searched-to
		(progn
		  (setq error-text
			(substring string searched-to
				   (setq searched-to
					 (string-match "$" string searched-to))))
		  (setq error-line
			(string-to-number
			 (substring string
				    (setq searched-to
					  (+ 8 (string-match "\\.as, Ln " string searched-to)))
				    (setq searched-to
					  (string-match "," string searched-to)))))
		  (setq error-col
			(string-to-number
			 (substring string
				    (setq searched-to
					  (+ 4
					     (string-match "Col " string searched-to)))
				    (setq searched-to
					  (string-match ":" string searched-to)))))
		  (insert (format
			   "Error: %s \nLine: %s\nColumn: %s\n"
			   error-text error-line error-col))
		  (as3-highlight-error old-buffer
				       error-line
				       error-col
				       error-text))
	      (insert string))
            (set-marker (process-mark proc) (point)))
          (if moving (goto-char (process-mark proc))))
      (set-buffer old-buffer))))

(defvar *package-path* "/home/wvxvw/Projects/e4xu/actionscript/")

(defvar *ash-process-name* "AS3 Syntax Check")

(defvar *as3-errors* nil)

(defun as3-syntax-check ()
  "Runs (ash) to try to compile the current file
and highlights the line(s) containing errors, if any"
  ;; AscShell http://code.google.com/p/flashdevelop/source/
  ;; browse/trunk/FD4/External/Plugins/AS3Context/Resources/
  ;; java/AscShell.java
  (interactive)
  ;; Need to set path separator according to OS
  (set-process-filter
   (start-process
    *ash-process-name*
    "*(ash)*"
    "java"
    "-classpath"
    (concat *flex-home* "lib/asc.jar:" *package-path*)
    "AscShell")
   'as3-checker-filter))

(defun as3-send-file-to-ash (as-file)
  "Sends file (path) to verify by ash"
  (interactive "fFile you want to check: ")
  (message "Checking file: %s" as-file)
  (process-send-string *ash-process-name*
		       (concat (expand-file-name as-file) "\n")))

(defun as3-next-error (steps reset)
  "This function is used to step through the errors discovered in the buffer"
  (let ((error-point (nth (mod steps (length *as3-errors*)) *as3-errors*)))
    (goto-line (car error-point))
    (coto-char (cdr error-point))))

(defun as3-mode ()
  "Starts the AS3 mode"
  (interactive)
  (kill-all-local-variables)
  (setq major-mode 'as3-mode)
  (setq next-error-function 'as3-next-error)
  (setq mode-name "Experimental mode for AS3 editing"))

(provide 'as3-mode)