;(in-package :cl-amf)

(defparameter *half-byte* #x3F)
(defconstant +null+ (code-char 0)) 

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


(defun read-amf-format (stream &rest ref-table)
  (let ((marker (read-byte stream :eof-error-p nil)))
    (format t "marker: ~a~&" marker)
    (when marker
      ;; Note: there must be 3 of them, one for strings, another
      ;; for object properties and yet another one for the rest...
      ;; well, that's what I could understand so far...
      (when (null ref-table) 
	(setf ref-table (make-hash-table :test 'equal)))
      (case marker
	((0 1 2) nil)
	(3 t)
	(4 (read-integer stream))
	(5 (read-double stream ref-table))
	(6 (read-string stream ref-table))
	((7 11) (read-xml stream ref-table))
	(8 (read-date stream ref-table))
	(9 (read-array stream ref-table))
	(10 (read-object stream ref-table))
	(12 (read-bytearray stream ref-table))
	(otherwise (format t "Type marker not recognized: ~a~&" marker))))))

(defun unset-leftmost-significant (of-byte)
  (loop for i from 8 downto 0
       for b = (ash 1 i)
       do (when (>= of-byte b)
	    (return (logand (1- b) of-byte)))
       finally (return 0)))

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
  (loop	for byte = (read-byte stream)
     with total = 0
     for is-last-byte = (> total #x3FFF)
     for shift = (if is-last-byte 8 7)
     do (setf total 
	      (+ (ash total shift) 
		 (logand byte (if is-last-byte #xFF #x7F))))
     when (or is-last-byte (zerop (ash byte -7)))
     return total))

(defun decode-ui29-but-first (stream first-byte)
  (loop	with if-first = t
     for byte = (if if-first
		    (progn (setf if-first nil)
			   (logand #x7F first-byte))
		    (read-byte stream))
     with total = 0
     for is-last-byte = (> total #x3FFF)
     for shift = (if is-last-byte 8 7)
     do (format t "byte: ~a, ~a~&" byte (ash byte -7))
     do (setf total 
	      (+ (ash total shift) 
		 (logand byte (if is-last-byte #xFF #x7F))))
     when (or is-last-byte (zerop (ash byte -7)))
     return total))

(defun read-integer (stream) (decode-ui29 stream))

(defun read-string (stream ref-table)
  (let ((ref-or-val (read-byte stream))
	(result 
	 (make-array '(0) 
		     :element-type 'base-char
		     :fill-pointer 0
		     :adjustable t)))
    (if (zerop (logand ref-or-val #x80))
	(if (= ref-or-val 1)
	    result
	    (with-output-to-string (is result)
	      (loop for i from 0 upto 
		   (1- (decode-ui29-but-first stream (ash ref-or-val -1)))
		 do (format t "collected string: ~a~&" result)
		 do (write-char (read-utf8-char stream) is))
	      result))
	(gethash (decode-ui29-but-first stream ref-or-val) ref-table))))

(defun read-double (stream ref-table))

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
  (format t "read-array entered~&")
  (let ((ref-or-val (read-byte stream))
	(dense-length)
	(array))
    (format t "vars declared: ~a~&" (logand ref-or-val #x80))
    (if (not (zerop (logand ref-or-val #x80)))
	(gethash (decode-ui29 stream) ref-table)
	(progn
	  (setf array (make-instance 'amf-array))
	  (setf dense-length 
		 (decode-ui29-but-first 
		  stream (ash ref-or-val -1)))
	  (format t "dense-length: ~a~&" dense-length)
	  (do ((prop-name (read-string stream ref-table)
			  (read-string stream ref-table))
	       (value))
	      ((string= prop-name ""))
	    (format t "read property name: ~a~&" prop-name)
	    (setf value (read-amf-format stream ref-table))
	    (setf (property array prop-name) value))
	  (loop for i from 0 upto (1- dense-length)
	     do (format t "setting dense part: ~a~&" i)
	     do (setf (property array i) 
		      (read-amf-format stream ref-table)))
	  array))))

;; U29O-ref = U29 ; The first (low) bit is a flag
;;                ; (representing whether an instance
;;                ; follows) with value 0 to imply that
;;                ; this is not an instance but a
;;                ; reference. The remaining 1 to 28
;;                ; significant bits are used to encode an
;;                ; object reference index (an integer).
;; U29O-traits-ref = U29 ; The first (low) bit is a flag with
;;                       ; value 1. The second bit is a flag
;;                       ; (representing whether a trait
;;                       ; reference follows) with value 0 to
;;                       ; imply that this objects traits are
;;                       ; being sent by reference. The remaining
;;                       ; 1 to 27 significant bits are used to
;;                       ; encode a trait reference index (an
;;                       ; integer).
;; U29O-traits-ext = U29 ; The first (low) bit is a flag with
;;                       ; value 1. The second bit is a flag with
;;                       ; value 1. The third bit is a flag with
;;                       ; value 1. The remaining 1 to 26
;;                       ; significant bits are not significant
;;                       ; (the traits member count would always
;;                       ; be 0).
;; U29O-traits = U29 ; The first (low) bit is a flag with
;;                   ; value 1. The second bit is a flag with
;;                   ; value 1. The third bit is a flag with
;;                   ; value 0. The fourth bit is a flag
;;                   ; specifying whether the type is
;;                   ; dynamic. A value of 0 implies not
;;                   ; dynamic, a value of 1 implies dynamic.
;;                   ; Dynamic types may have a set of name
;;                   ; value pairs for dynamic members after
;;                   ; the sealed member
;;                   ; section. The
;;                   ; remaining 1 to 25 significant bits are
;;                   ; used to encode the number of sealed
;;                   ; traits member names that follow after
;;                    the class name (an integer).
;; class-name = UTF-8-vr
;; ; Note: use the empty string for
;; ; anonymous classes.
;; dynamic-member = UTF-8-vr
;;                 value-type
;; ; Another dynamic member follows
;; ; until the string-type is the
;; ; empty string.
;; object-type = object-marker (U29O-ref | (U29O-traits-ext
;;              class-name *(U8)) | U29O-traits-ref | (U29O-
;;             traits class-name *(UTF-8-vr))) *(value-type)
;;            *(dynamic-member)))
(defun read-object (stream ref-table)
  (let ((ref-or-val (read-byte stream))
	(class-name)
	(traits-count)
	(traits)
	(result)
	(result-class))
    (if (not (zerop (logand ref-or-val #x80)))
	(cond
	  ((= (logand #b11100000 ref-or-val) #b11100000)
	   (let ((*amf-tables* ref-table)
		 (*amf-stream*)
		 (*amf-class-name* (read-string stream)))
	     ;; TODO: need a separate table for callbacks and such, 
	     ;; will need to set couple of globals, as maybe for 
	     ;; other tables.
	     (funcall (gethash *amf-class-name* ref-table))))
	  ((= (loagand #b11000000 ref-or-val) #b11000000)
	   ;; Dynamic
	   (setf traits-count 
		 (decode-ui29-but-first 
		  stream
		  (loagand #b11000000 ref-or-val)))
	   (setf class-name (read-string stream))
	   (setf result-class (gethash class-name ref-table) 
	   (setf result
		 (make-instance 
		  (if result-class result-class 'amf-object)))
	   (setf traits
		 (loop for i from 0 upto traits-count
		    collect (read-string stream)))
	   (loop for i from 0 upto traits-count
		with trait-name = traits
		do (setf 
		    (property result (car trait-name)) 
		    (read-amf-format stream ref-table))
		do (setf trait-name (cdr trait-name))) 
	   (unless (zerop (loagand #b10000 ref-or-val))
	       (read-dynamic-object result stream ref-table))
	   result
	  ((t) (setf traits-count
		     (decode-ui29-but-first
		      stream (ash ref-or-val -1)))
	   (loop for i in (gethash traits-count ref-table)
	      do (setf (property result i) (read-amf-format)))
	   ;; weirdly the spec doesn't say how would I know if the object is
	   ;; dynamic here, I'll just write this together with the traits reference
	   ;; since it looks like the most probable way to deal with it.
	   (when (gethash traits-count ref-table)
	     ;; NOTE: all references need to be redone.
	       (read-dynamic-object result stream ref-table))
	   result))))))

(defun read-bytearray (stream ref-table))

(defun read-date (stream ref-table)
  (let ((ref-or-val (read-byte stream))
    (if (logand ref-or-val #x80)
	(gethash ref-table (decode-ui29 stream))
	(decode-ieee-754 stream))))

(defun read-xml (stream ref-table))

(defun parse-amf (amf-file)
  (with-open-file 
      (stream amf-file
	      :direction :input 
	      :element-type '(unsigned-byte 8))
    (read-amf-format stream)))

(parse-amf "./data.amf")