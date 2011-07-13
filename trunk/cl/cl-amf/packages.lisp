(defpackage :cl-amf
  (:use :cl :cxml)
  (:export 
   ;; structs
   :as3-fqname
   ;; types
   :amf-value
   ;; classes
   :amf-object
   :amf-array
   :amf-date
   ;; functions
   :read-amf-format
   :item
   :amf-length))
