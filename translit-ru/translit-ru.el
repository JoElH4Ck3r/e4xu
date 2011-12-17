(defgroup translit-ru nil
  "The major mode for typing in Russian translit")

;; See http://stackoverflow.com/questions/8532921/override-self-insert-command-or-input-decode-map/8542336#8542336

(defvar *transliteration-on* nil)

(defvar *local-last-input* nil)

(defvar *latin-cyrillic-map*
  '((97  . "а") (98  . "б") (99  . "ц") (100 . "д")
    (101 . "е") (102 . "ф") (39  . "ь") (35  . "ъ")
    (103 . "г") (104 . "х") (105 . "и") (106 . "й")
    (107 . "к") (108 . "л") (109 . "м") (110 . "н")
    (111 . "о") (112 . "п") (113 . "щ") (114 . "р")
    (115 . "с") (116 . "т") (117 . "у") (118 . "в")
    (119 . "щ") (120 . "х") (121 . "ы") (122 . "з")))

(defvar *latin-cyrillic-prefices*
  '((106 . ((117 . "ю") (97 . "я") (101 . "э") (111 . "ё"))) ; j
    (39  . ((39  . "Ь")))				     ; '
    (35  . ((35  . "Ъ")))				     ; #
    (115 . ((104 . "ш")))				     ; s
    (99  . ((104 . "ч")))				     ; c
    (122 . ((104 . "ж")))))				     ; z

(defun upcase-if-needed (c needed)
  (if needed c (upcase c)))

(defun latin-to-cyrillic ()
  (interactive)
  (let* ((downcase-c (downcase last-input-char))
	 (matched-c (cdr (assq downcase-c *latin-cyrillic-map*)))
	 (continuation
	  (when *local-last-input*
	    (assq (downcase *local-last-input*)
		  *latin-cyrillic-prefices*)))
	 (completion (assq downcase-c continuation))
	 (last-input *local-last-input*)
	 (need-upcase (eq last-input-char downcase-c))
	 (reset-last (assq downcase-c *latin-cyrillic-prefices*)))
    (setq *local-last-input* nil)
    (cond
     (completion
      (when (eq last-input last-input-char)
	(setq reset-last nil))
      (insert (upcase-if-needed
	       (cdr completion)
	       (eq (downcase last-input) last-input))))
     (last-input
      (insert (upcase-if-needed
	       (cdr (assq (downcase last-input) *latin-cyrillic-map*))
	       (eq (downcase last-input) last-input)))
      (if (and matched-c (not reset-last))
	(insert (upcase-if-needed matched-c need-upcase))
	(unless matched-c (insert last-input-char))))
     ((and matched-c (not reset-last))
      (insert (upcase-if-needed matched-c need-upcase)))
     ((not matched-c) (insert last-input-char)))
    (when reset-last
      (setq *local-last-input* last-input-char))))

(defun change-translit-mode ()
  "Switches translit mode on and off"
  (interactive)
  (setq *local-last-input* nil)
  (define-key (current-local-map)
    [remap self-insert-command]
    (if *transliteration-on*  
	'self-insert-command
        'latin-to-cyrillic))
  (setq *transliteration-on* (not *transliteration-on*)))

(defun translit-mode ()
  "Starts the translit mode"
  (interactive)
  (kill-all-local-variables)
  (setq major-mode 'translit-ru)
  (setq mode-name "Transliterate as you type!")
  (local-set-key (kbd "<f12>") 'change-translit-mode))

(provide 'translit-ru)