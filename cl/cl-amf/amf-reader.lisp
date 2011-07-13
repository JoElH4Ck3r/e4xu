(in-package :cl-amf)

(defparameter *half-byte* #x3F)

;; undefined-marker = 0x00
;; null-marker = 0x01
;; false-marker = 0x02
;; true-marker = 0x03
;; integer-marker = 0x04
;; double-marker = 0x05
;; string-marker = 0x06
;; xml-doc-marker = 0x07
;; date-marker = 0x08
;; array-marker = 0x09
;; object-marker = 0x0A
;; xml-marker = 0x0B
;; byte-array-marker = 0x0C
;; NOTE: #13 is Vector.<T>, but it's not in the spec

;; The remaining 1 to 26 significant bits are not significant


(defun read-amf-format (stream ref-table)
  (let ((marker (read-char stream :eof-error-p nil)))
    (when marker
      (case (char-code marker)
	((0 1 2) nil)
	(3 t)
	(4 (read-integer stream))
	(5 (read-double stream))
	(6 (read-string stream))
	((7 11) (read-xml-doc stream))
	(8 (read-date stream ref-table))
	(9 (read-array stream))
	(10 (read-object stream))
	(12 (read-bytearray stream))))))

(defun read-utf8-char (stream)
  (loop for i from 7 downto 0
     with first-byte = (read-byte stream nil 0)
     do (when (= first-byte 0) (return +null+))
     do (when (or (not (logbitp i first-byte)) (= i 0))
	  (setf first-byte (logand first-byte (- (ash 1 i) 1)))
	  (return
	    (code-char 
	     (dotimes (a (- 6 i) first-byte)
	       (setf first-byte
		     (+ (ash first-byte 6)
			(logand (read-byte stream) #x3F)))))))))

;; (defun decode-utf-8 (bytes)
;;   (let ((first-byte (first bytes))
;; 	(result))
;;     (if (logbitp 7 first-byte)
;; 	(if (not (logbitp 5 first-byte))
;; 	    (setf result (+ (ash (logand first-byte #x1F) 6) 
;; 			    (logand (second bytes) #x3F)))
;; 	    (if (not (logbitp 4 first-byte))
;; 		(setf result (+ (ash (logand first-byte #xF) 12) 
;; 				(ash (logand (second bytes) #x3F) 6) 
;; 				(logand (third bytes) #x3F)))
;; 		(when (not (logbitp 3 first-byte)) 
;; 		  (setf result (+ (ash (logand first-byte #x7) 18) 
;; 				  (ash (logand (second bytes) #x3F) 12) 
;; 				  (ash (logand (third bytes) #x3F) 6) 
;; 				  (logand (fourth bytes) #x3F))))))
;; 	(setf result first-byte))
;;     (code-char result)))

(defun decode-ieee-754 (bytes)
  (let ((sign (if (logbitp 0 (first bytes)) 1 -1))
	(exponent (- (logior (ash (logand (first bytes) #x7F) 4) 
			     (ash (second bytes) -4)) #x3FF))
	(significand (+ #x10000000000000 
			(ash (logand (second bytes) #xF) 48)
			(reduce #'(lambda (x y)	(+ (ash x 8) y)) 
				(subseq bytes 2)))))
    (* sign (/ significand (ash 1 (- 52 exponent))))))

(defun decode-ui29 (stream)
  (loop	for byte = (char-code (read-char stream))
     with total = 0
     for is-last-byte = (> total #x3FFF)
     for shift = (if is-last-byte 8 7)
     do (setf total 
	      (+ (ash total shift) 
		 (logand byte (if is-last-byte #xFF #x7F))))
     when (or is-last-byte (= (ash byte 7) 0))
     return total))

(defun decode-ui29-but-first (stream)
  (loop	with if-first = t
     for byte = (if if-first
		    (progn (setf if-first nil)
			   (logand #x80 (char-code (read-char stream))))
		    (char-code (read-char stream)))
     with total = 0
     for is-last-byte = (> total #x3FFF)
     for shift = (if is-last-byte 8 7)
     do (setf total 
	      (+ (ash total shift) 
		 (logand byte (if is-last-byte #xFF #x7F))))
     when (or is-last-byte (= (ash byte 7) 0))
     return total))

(defun read-integer (stream) (decode-ui29 stream))

(defun read-string (stream))

(defun read-double (stream))

;; U29A-value = U29
;; The first (low) bit is a flag with
;; value 1. The remaining 1 to 28
;; significant bits are used to encode the
;; count of the dense portion of the Array.
;;
;; assoc-value = UTF-8-vr value-type
;; array-type = array-marker (U29O-ref | (U29A-value
;;             (UTF-8-empty | *(assoc-value) UTF-8-empty)
;;            *(value-type)))
;; If this isn't a reference, then in plain language it is:
;; #x09, length of the dense part (ui29), 
;; (basically the object record)* #x01 (type-marker value)*
(defun read-array (stream ref-table)
  (let ((ref-or-val (read-char stream))
	(dense-length)
	(array (make-instance 'amf-array)))
    (unread-char (code-char 9))
    (if (logand ref-or-val #x80)
	(gethash ref-table (decode-ui29 stream))
	(progn
	  (setf dense-length (decode-ui29-but-first stream))
	  (do ((prop-name (read-string stream)
			  (read-string stream))
	       (value (read-amf-format stream ref-table) 
		      (read-amf-format stream ref-table)))
	      ((string= prop-name ""))
	    ((setf (property array prop-name) value)))
	  (loop for i from 0 upto dense-length
	     do (setf (property array i) 
		      (read-amf-format stream ref-table)))
	  ))))

(defun read-object (stream))

(defun read-bytearray (stream))

(defun read-date (stream ref-table)
  (let ((ref-or-val (char-code (read-char stream))))
    (unread-char (code-char 8))
    (if (boole boole-and ref-or-val #x80)
	(gethash ref-table (decode-ui29 stream))
	(decode-ieee-754 stream))))

(defun read-xml (stream))