(in-package :cl-amf)

(defclass amf-reader ()
	((encoding-version 
		:initform "3.0")
	(source
		:accessor :source
		:initarg :source))
	(:documentation "This class reads AMF 3.0 encoding"))

(defgeneric read-undefined (source)
	(:documentation "Reads 'undefined' record"))
(defgeneric read-null (source)
	(:documentation "Reads 'null' record"))
(defgeneric read-ui29 (source)
	(:documentation "Reads 'UI29' - a variable length unsigned integer record"))
(defgeneric read-utf-8 (source)
	(:documentation "Reads UTF-8 encoded string"))
(defgeneric read-false (source)
	(:documentation "Reads 'false' record"))
(defgeneric read-true (source)
	(:documentation "Reads 'true' record"))
(defgeneric read-double (source)
	(:documentation "Reads 'IEEE-754' double precision floating point record"))
(defgeneric read-array (source)
	(:documentation "Reads 'ECMAScript Array' record"))
(defgeneric read-object (source)
	(:documentation "Reads 'Object' record"))

(defparameter *half-byte* #x3F)

(defun move-on (source)
	
)

(defun read-next-byte ()
	
)

(defun decode-ieee-754 (bytes)
	(let (	(sign (if (logbitp 1 (first bytes)) 1 -1))
		(exponent (- (logior (ash (logand (first bytes) #x7F) 4) 
			(ash (second bytes) -4)) #x3FF))
		(significand (+ #x10000000000000 
			(ash (logand (second bytes) #xF) 48)
			(reduce #'(lambda (x y)	(+ (ash x 8) y)) 
				(subseq bytes 2)))))
	(* sign (/ significand (ash 1 (- 52 exponent))))))

(defun decode-ui29 (bytes)
	(loop	for byte in bytes
		with total = 0
		for is-last-byte = (> total #x3FFF)
		for shift = (if is-last-byte 8 7)
		do (setf total 
			(+ (ash total shift) 
				(logand byte (if is-last-byte #xFF #x7F))))
		when (or is-last-byte (= (ash byte 7) 0))
			return total))

(defmethod read-undefined (source)
		
)

(defmethod read-null (source)
		
)

(defmethod read-ui29 (source)
		
)

(defmethod read-utf-8 (source)
		
)

(defmethod read-false (source)
		
)


(defmethod read-true (source)
		
)

(defmethod read-double (source)
		
)

(defmethod read-array (source)
		
)


(defmethod read-object (source)
		
)

