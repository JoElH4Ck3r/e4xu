;(in-package :cl-amf)

;; Remember Dictionary and Vector.<T>
;; undocs

(defstruct
    (as3-fqname 
      (:print-function
       (lambda (struct stream depth)
	   (declare (ignore depth))
	   (format stream "~a:~a" 
		   (as3-fqname-package struct)
		   (as3-fqname-name struct)))))
  (package "" :type string)
  (name "" :type string))

;; (defstruct (amf-object
;; 	     (:print-function
;; 	      (lambda (struct stream depth)
;; 		  (declare (ignore depth))
;; 		  (format stream "[~a object]" 
;; 			  (amf-object-class struct)))))
;;   (class (make-as3-fqname :as3-name "Object")
;; 	     :type as3-fqname)
;;   (properties (make-hash-table :test 'equal)))


(deftype amf-value ()
  '(satisfies amf-value-p))

(defun print-amf-type (value)
  (cond
    ((typep value 'string) (concatenate 'string "\"" value "\""))
    ((null value) "null")
    ((typep value 'boolean) "true")
    (t (write-to-string value))))

;;-----------------------------------------------------------
;; Object class
;;-----------------------------------------------------------

(defclass amf-object ()
  ((constructor 
    :initarg :constructor
    :initform (make-as3-fqname :name "Object")
    :type as3-fqname)
   (properties
    :initform (make-hash-table :test 'equal)
    :type hash-table)))

(defgeneric get-property (container name)
  (:documentation "Generic method for reading from `amf-object' properties"))

(defmethod get-property ((container amf-object) (name string))
  (gethash name (slot-value container 'properties)))

(defgeneric (setf property) (value container name)
  (:documentation "Generic method for writing the properties of `amf-object'"))

(defmethod (setf property) (value (container amf-object) (name string))
  (check-type value amf-value "A value that is possible to serialize using AMF protocol")
  (setf (gethash name (slot-value container 'properties)) value))

(defmethod print-object ((obj amf-object) stream)
  (print-unreadable-object (obj stream :type t)
    (let ((*print-circle* t))
      (princ "{ " stream)
      (loop with hash = (slot-value obj 'properties)
	 with first = t
	 for p being the hash-keys in hash
	 for value = (print-amf-type (gethash p hash))
	 do (if first
		(setf first (format stream "\"~a\" : ~a" p value))
		(format stream ", \"~a\" : ~a" p value)))
      (princ " }" stream))))

;;-----------------------------------------------------------
;; Array class
;;-----------------------------------------------------------

(defclass amf-array (amf-object)
  ((constructor 
    :initform (make-as3-fqname :name "Array"))
   (members
    :initform nil
    :initarg :members
    :type list)))

(defgeneric amf-length (container)
  (:documentation "Calculates the length of the `container', note, 
this operation is O(n) complex, where n is the number of all numerical offsets 
in the underlying pairlist, try not to abuse it."))

(defmethod amf-length ((container amf-array))
  (let ((array (slot-value container 'members)))
    (if array
	(let ((last-pair (first (last array))))
	  (1+
	   (if (typep last-pair 'integer) 
	       last-pair (first last-pair)))) 0)))

(defgeneric item (container index)
  (:documentation "Fetches an item at specified `index'."))

(defmethod item ((container amf-array) (index integer))
	  (assoc index (slot-value container 'members)))

(defmethod get-property ((container amf-array) (name string))
  (multiple-value-bind (possible-int stopped-at)
      (parse-integer name :junk-allowed t)
    (if (= (length name) stopped-at)
	(item container possible-int)
	(gethash name (slot-value container 'properties)))))

(defmethod (setf property) (value (container amf-array) (name string))
  (check-type value amf-value "A value that is possible to serialize using AMF protocol")
  (multiple-value-bind (possible-int stopped-at)
      (parse-integer name :junk-allowed t)
    (if (= (length name) stopped-at)
	(setf (property container possible-int) value)
	(setf (gethash name (slot-value container 'properties)) value))))

(defmethod (setf property) (value (container amf-array) (name integer))
  (check-type value amf-value "A value that is possible to serialize using AMF protocol")
  (if (slot-value container 'members)
      (loop with members = (slot-value container 'members)
	 with len = (length members)
	 for i in members
	 for inc from 0
	 do (cond
	      ((= (car i) name)
	       (setf (cdr i) value)
	       (return))
	      ((and (> (car i) name) (zerop inc))
	       (setf (slot-value container 'members) 
		     (cons (cons 0 value) members))
	       (return))
	      ((> (car i) name)
	       (push (cons name value) (cdr (nthcdr (1- inc) members)))
	       (return))
	      ((= len (1+ inc))
	       (setf (cdr (last members)) (cons (cons name value) nil)))
	      (t nil)))
      (setf (slot-value container 'members) 
	    (cons (cons name value) nil))) value)

(defmethod print-object ((obj amf-array) stream)
  (print-unreadable-object (obj stream :type t)
    (let ((*print-circle* t))
      (princ "[" stream)
      (loop for i from 0 upto (1- (amf-length obj))
	 with first = t
	 for value = (print-amf-type (cdr (item obj i)))
	 do (if first
		(setf first (format stream "~a" value))
		(format stream ",~a" value)))
      (princ "]" stream))))

;;-----------------------------------------------------------
;; Date class
;;-----------------------------------------------------------

(defclass amf-date ()
  ((value 
    :initarg :value
    ;; AS dates are in milliseconds
    :initform (* (get-universal-time) 1000)
    :type integer)))

(defmethod print-object ((obj amf-date) stream)
  (multiple-value-bind
	(second minute hour date month year)
      (decode-universal-time (/ (slot-value obj 'value) 1000))
    (print-unreadable-object (obj stream :type t)
      (format stream "~2,'0d:~2,'0d:~2,'0d ~d/~2,'0d/~d"
	      hour minute second month date year))))

;;-----------------------------------------------------------
;; Utility functions
;;-----------------------------------------------------------

;; This is said to be uselsess... well, I'll leave it here to remember to research the issue
;; in depth
(defun amf-value-p (x)
  (or (typep x 'amf-object)
      (typep x 'amf-date)
      (null x)
      (eq x t)
      (typep x 'string)
      (when (typep x 'integer) 
	(and (>= x #x-7FFFFFFF) (<= x #xFFFFFFFF)))
      (typep x 'float)))


;; (defvar *amf-array* (make-instance 'amf-array))
;; (setf (property *amf-array* 1) 33)
;; (setf (property *amf-array* 0) 42)
;; (setf (property *amf-array* 3) 66)
;; (setf (slot-value *amf-array* 'members) nil)
;; (slot-value *amf-array* 'members)