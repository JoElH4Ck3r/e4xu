(in-package :cl-user)
(require :cxml)
(defpackage cl-amf-system
  (:use :common-lisp :cl :asdf :cxml))
(in-package :cl-amf-system)

(asdf:defsystem :cl-amf
  :description "Library for reading and writing AMF 3.0 (ActionScript Message Format)."
  :version "0.0.1"
  :author "wvxvw"
  :components ((:file "packages") ;; defines (defpackage :cl-amf)
	       (:file "amf-object" :depends-on ("packages"))
	       (:file "amf-reader" :depends-on ("packages"))))