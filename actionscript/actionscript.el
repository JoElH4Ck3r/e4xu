(defgroup actionscript nil
  "Set of utility functions for running Flex SDK programs"
  :group 'languages)

(defvar *flex-home* (expand-file-name "~/Flex/SDK/4.0/"))

(defun actionscript-compile ()
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
     (concatenate 'string 
		  *flex-home* "bin/mxmlc "
		  source " -o " output " -sp " source-path
		  " -static-link-runtime-shared-libraries=true"))))

(defun actionscript-debug ()
  "Starts fdb (Flex debugger) with the SWF you want to debug"
  (interactive)
  (let ((filename 
	 (read-file-name "Select file to debug: "
			 (if (equal major-mode 'dired-mode)
			     default-directory
			   (buffer-file-name)))))
    (term *flex-home* "bin/fdb")
    (process-send-string 
     nil 
     (concatenate 'string "r " (expand-file-name filename) "\n"))))

(defun actionscript-fcsh ()
  "Starts fcsh (Flex Compiler Shell)"
  (interactive)
  (term (concatenate 'string *flex-home* "bin/fcsh")))

(provide 'actionscript)