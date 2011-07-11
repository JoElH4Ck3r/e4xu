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

(defmethod (setf property) (value (container amf-object) (name string))
  (check-type value amf-value "A value that is possible to serialize using AMF protocol")
  (setf (gethash name (slot-value container 'properties)) value))

(defmethod print-object ((obj amf-object) stream)
  (print-unreadable-object (obj stream :type t)
    (princ "{ " stream)
    (loop with hash = (slot-value obj 'properties)
       with first = t
       for p being the hash-keys in hash
       for value = (print-amf-type (gethash p hash))
       do (if first
	      (setf first (format stream "~a : ~a" p value))
	      (format stream ", ~a : ~a" p value)))
    (princ " }" stream)))

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
this operation is O(n) complex, try not to abuse it"))

(defmethod amf-length ((container amf-array))
  (car (first (last (slot-value container 'members)))))

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

(defmethod print-object ((obj amf-array) stream)
  (print-unreadable-object (obj stream :type t)
    (princ "[" stream)
    (loop for i from 0 upto (amf-length obj)
       with first = t
       for value = (print-amf-type (car (item obj i)))
       do (if first
	      (setf first (format stream "~a" value))
	      (format stream ",~a" value)))
    (princ "]" stream)))

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

