(in-package #-gcl #:maxima #+GCL "MAXIMA")

#+(or ecl abcl) ($load "lisp-utils/defsystem.lisp")

(load (merge-pathnames (make-pathname :name "numericalio" :type "system") (maxima-load-pathname-directory)))

(mk:oos "numericalio" :compile)
