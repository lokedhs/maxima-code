;;; -*-  Mode: Lisp; Package: Maxima; Syntax: Common-Lisp; Base: 10 -*- ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;     The data in this file contains enhancments.                    ;;;;;
;;;                                                                    ;;;;;
;;;  Copyright (c) 1984,1987 by William Schelter,University of Texas   ;;;;;
;;;     All rights reserved                                            ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :maxima)

(macsyma-module rat3a)

;; This is the new Rational Function Package Part 1.
;; It includes most of the coefficient and polynomial routines required
;; by the rest of the functions.  Certain specialized functions are found
;; elsewhere.  Most low-level utility programs are also in this file.

(declare-top (special *a* *x*))

(declare-top (unspecial coef var exp p y))

;;These do not need to be special for this file and they
;;slow it down on lispm. We also eliminated the special
;;from ptimes2--wfs

;; Global variables referenced throughout the rational function package.

(defmvar modulus nil "Global switch for doing modular arithmetic")

;; CQUOTIENT
;;
;; Calculate the quotient of two coefficients, which should be numbers. If
;; MODULUS is non-nil, we try to take the reciprocal of A with respect to the
;; modulus (using CRECIP) and then multiply by B. Note that this fails if B
;; divides A as an integer, but B is not a unit in the ring of integers modulo
;; MODULUS. For example,
;;
;;   (let ((modulus 20)) (cquotient 10 5)) => ERROR
;;
;; If MODULUS is nil, then we work over the ring of integers when A and B are
;; integers, and raise a RAT-ERROR if A is not divisible by B. If either A or B
;; is a float then the division is done in floating point. Floats can get as far
;; as the rational function code if $KEEPFLOAT is true.
(defun cquotient (a b)
  (cond ((equal a 0) 0)
	((null modulus)
         (if (or (floatp a) (floatp b)
                 (zerop (rem a b)))
             (/ a b)
             (rat-error "quotient is not exact")))
	(t (ctimes a (crecip b)))))

;; ALG
;;
;; Get any value stored on the tellrat property of (car l). Returns NIL if L
;; turns out not to be a list or if $ALGEBRAIC is false.
(defun alg (l)
  (unless (atom l) (algv (car l))))

;; PACOEFP
;;
;; Return T if either X is a bare coefficient or X is a polynomial whose main
;; variable has a declared value as an algebraic integer. Otherwise return NIL.
(defun pacoefp (x)
  (and (or (pcoefp x) (alg x))
       T))

;; LEADTERM
;;
;; Return the leading term of POLY as a polynomial itself.
(defun leadterm (poly)
  (if (pcoefp poly)
      poly
      (make-poly (p-var poly) (p-le poly) (p-lc poly))))

;; Coefficient Arithmetic -- coefficients are assumed to be something
;; that is NUMBERP in lisp.  If MODULUS is non-NIL, then all coefficients
;; are assumed to be less than its value.  Some functions use LOGAND
;; when MODULUS = 2.  This will not work with bignum coefficients.

;; CRECIP
;;
;; Takes the inverse of an integer N mod MODULUS. If there is a modulus then the
;; result is constrained to lie in (-modulus/2, modulus/2]
;;
;; This just uses the extended Euclidean algorithm: once you have found a,b such
;; that a*n + b*modulus = 1 then a must be the reciprocal you're after.
;;
;; When MODULUS is greater than 2^15, we use exactly the same algorithm in
;; CRECIP-GENERAL, but it can't use fixnum arithmetic. Note: There's no
;; particular reason to target 32 bits except that trying to work out the right
;; types on the fly looks complicated and this lisp compiler, at least, uses 32
;; bit words. Since we have to take a product, we constrain the types to 16 bit
;; numbers.
(defun crecip (n)
  ;; Punt on anything complicated
  (unless (and modulus (typep modulus '(unsigned-byte 15)))
    (return-from crecip (crecip-general n)))

  ;; And make sure that -MODULUS < N < MODULUS
  (unless (<= (- modulus) n modulus)
    (merror "N is out of range [-MODULUS, MODULUS] in crecip."))

  ;; N in [0, MODULUS]
  (when (minusp n) (setf n (+ n modulus)))

  ;; The mod-copy parameter stores a copy of MODULUS on the stack, which is
  ;; useful because the lisp implementation doesn't know that the special
  ;; variable MODULUS is still an (unsigned-byte 15) when we get to the end
  ;; (since it can't tell that our function calls don't change it behind our
  ;; backs, I guess)
  (let ((mod modulus) (remainder n) (a 1) (b 0)
        (mod-copy modulus))
    ;; On SBCL in 2013 at least, the compiler doesn't spot that MOD and
    ;; REMAINDER are unsigned and bounded above by MODULUS, a 16-bit integer. So
    ;; we have to tell it. Also, the lisp implementation can't really be
    ;; expected to know that Bezout coefficients are bounded by the modulus and
    ;; remainder, so we have to tell it that too.
    (declare (type (unsigned-byte 15) mod mod-copy remainder)
             (type (signed-byte 16) a b))

    (loop
       until (= remainder 1)

       when (zerop remainder) do
         (merror (intl:gettext "CRECIP: attempted inverse of zero (mod ~M)")
                 mod)
       doing
         (multiple-value-bind (quot rem)
             (truncate mod remainder)
           (setf mod remainder
                 remainder rem)
           (psetf a (- b (* a quot))
                  b a))

       finally
         ;; Since this isn't some general purpose Euclidean algorithm, but
         ;; instead is trying to find a modulo inverse, we need to ensure that
         ;; the Bezout coefficient we found (called A) is actually in [0,
         ;; MODULUS).
         ;;
         ;; The general code calls CMOD here, but that doesn't know about the
         ;; types of A and MODULUS, so we do it by hand, special-casing the easy
         ;; case of modulus=2.
         (return
           (if (= mod-copy 2)
               (logand a 1)
               (let ((nn (mod a mod-copy)))
                 ;; nn here is in [0, modulus)
                 (if (<= (* 2 nn) mod-copy)
                     nn
                     (- nn mod-copy))))))))

;; CRECIP-GENERAL
;;
;; The general algorithm for CRECIP, valid when the modulus is any integer. See
;; CRECIP for more details.
(defun crecip-general (n)
  ;; We assume that |n| < modulus, so n+modulus is always positive
  (let ((mod modulus)
        (remainder (if (minusp n) (+ n modulus) n))
        (a 1) (b 0))
    (loop
       until (= remainder 1)

       when (zerop remainder) do
         (merror (intl:gettext "CRECIP: attempted inverse of zero (mod ~M)")
                 mod)
       doing
         (let ((quotient (truncate mod remainder)))
           (psetf mod remainder
                  remainder (- mod (* quotient remainder)))
           (psetf a (- b (* a quotient))
                  b a))

       finally (return (cmod a)))))

;; CEXPT
;;
;; Raise an coefficient to a positive integral power. BASE should be a
;; number. POW should be a non-negative integer.
(defun cexpt (base pow)
  (unless (typep pow '(integer 0))
    (error "CEXPT only defined for non-negative integral exponents."))
  (if (not modulus)
      (expt base pow)
      (do ((pow (ash pow -1) (ash pow -1))
           (s (if (oddp pow) base 1)))
          ((zerop pow) s)
        (setq base (rem (* base base) modulus))
        (when (oddp pow) (setq s (rem (* s base) modulus))))))

;; CMOD
;;
;; When MODULUS is null, this is the identity. Otherwise, it normalises N, which
;; should be a number, to lie in the range (-modulus/2, modulus/2].
(defun cmod (n)
  (declare (type number n))
  (if (not modulus)
      n
      (let ((rem (mod n modulus)))
        (if (<= (* 2 rem) modulus)
            rem
            (- rem modulus)))))

(defun cplus       (a b) (cmod (+ a b)))
(defun ctimes      (a b) (cmod (* a b)))
(defun cdifference (a b) (cmod (- a b)))

;; SET-MODULUS
;;
;; Set the base in which the rational function package works. This does
;; sanity-checking on the value chosen and is probably the way you should set
;; the global value.
;;
;; Valid values for M are either a positive integer or NULL.
(defun set-modulus (m)
  (if (or (null m) (typep m '(integer 0)))
      (setq modulus m)
      (error "modulus must be a positive number or nil"))
  (values))

;; PCOEFADD
;;
;; Prepend a term to an existing polynomial. EXPONENT should be the exponent of
;; the term to add; COEFF should be its coefficient; REMAINDER is a list of
;; polynomial terms. The function returns polynomial terms that correspond to
;; adding the given term.
;;
;; The function doesn't check that EXPONENT is higher than the highest exponent
;; in REMAINDER, so you have to do this yourself.
(defmfun pcoefadd (exponent coeff remainder)
  (if (pzerop coeff)
      remainder
      (cons exponent (cons coeff remainder))))

;; PPLUS
;;
;; Add together two polynomials.
(defmfun pplus (x y)
  (cond ((pcoefp x) (pcplus x y))
	((pcoefp y) (pcplus y x))
	((eq (p-var x) (p-var y))
	 (psimp (p-var x) (pplus1 (p-terms y) (p-terms x))))
	((pointergp (p-var x) (p-var y))
	 (psimp (p-var x) (ptcplus y (p-terms x))))
	(t (psimp (p-var y) (ptcplus x (p-terms y))))))

(defun pplus1 (x y)
  (cond ((ptzerop x) y)
	((ptzerop y) x)
	((= (pt-le x) (pt-le y))
	 (pcoefadd (pt-le x)
		   (pplus (pt-lc x) (pt-lc y))
		   (pplus1 (pt-red x) (pt-red y))))
	((> (pt-le x) (pt-le y))
	 (cons (pt-le x) (cons (pt-lc x) (pplus1 (pt-red x) y))))
	(t (cons (pt-le y) (cons (pt-lc y) (pplus1 x (pt-red y))))))) 

(defun pcplus (c p)
  (cond ((pcoefp p) (cplus p c))
	(t (psimp (p-var p) (ptcplus c (p-terms p))))))

;; PTCPLUS
;;
;; Add a coefficient to a list of terms. C should be a coefficient; TERMS is a
;; list of a polynomial's terms.
(defun ptcplus (c terms)
  (cond
    ;; Adding zero doesn't do anything.
    ((pzerop c) terms)
    ;; Adding to zero, you just get the coefficient.
    ((null terms) (list 0 c))
    ;; If terms are from a constant polynomial, we can just add C to its leading
    ;; coefficient (which might not be a number in the multivariate case, so you
    ;; have to use PPLUS)
    ((zerop (pt-le terms))
     (pcoefadd 0 (pplus c (pt-lc terms)) nil))
    ;; If TERMS is a polynomial with degree > 0, recurse.
    (t
     (cons (pt-le terms) (cons (pt-lc terms) (ptcplus c (pt-red terms)))))))

(defmfun pdifference (x y)
  (cond ((pcoefp x) (pcdiffer x y))
	((pcoefp y) (pcplus (cminus y) x))
	((eq (p-var x) (p-var y))
	 (psimp (p-var x) (pdiffer1 (p-terms x) (p-terms y))))
	((pointergp (p-var x) (p-var y))
	 (psimp (p-var x) (pcdiffer2 (p-terms x) y)))
	(t (psimp (p-var y) (pcdiffer1 x (p-terms y))))))

(defun pdiffer1 (x y)
  (cond ((ptzerop x) (pminus1 y))
	((ptzerop y) x)
	((= (pt-le x) (pt-le y))
	 (pcoefadd (pt-le x)
		   (pdifference (pt-lc x) (pt-lc y))
		   (pdiffer1 (pt-red x) (pt-red y))))
	((> (pt-le x) (pt-le y))
	 (cons (pt-le x) (cons (pt-lc x) (pdiffer1 (pt-red x) y))))
	(t (cons (pt-le y) (cons (pminus (pt-lc y))
				 (pdiffer1 x (pt-red y)))))))

(defun pcdiffer (c p)
  (cond ((pcoefp p) (cdifference c p))
	(t (psimp (car p) (pcdiffer1 c (cdr p))))))	 

(defun pcdiffer1 (c x)
  (cond ((null x) (cond ((pzerop c) nil) (t (list 0 c))))
	((pzerop (car x))
	 (pcoefadd 0 (pdifference c (cadr x)) nil))
	(t (cons (car x)
		 (cons (pminus (cadr x)) (pcdiffer1 c (cddr x)))))))

(defun pcdiffer2 (x c)
  (cond ((null x) (cond ((pzerop c) nil) (t (list 0 (pminus c)))))
	((pzerop (car x)) (pcoefadd 0 (pdifference (cadr x) c) nil))
	(t (cons (car x) (cons (cadr x) (pcdiffer2 (cddr x) c))))))

(defun pcsubsty (vals vars p)		;list of vals for vars
  (cond ((null vars) p)
	((atom vars) (pcsub p (list vals) (list vars)))	;one val hack
	(t (setq vars (sort (mapcar #'cons vars vals) #'pointergp :key #'car))
	   (pcsub p (mapcar (function cdr) vars)
		  (mapcar (function car) vars)))))

(defun pcsubst (p val var)		;one val for one var
  (cond ((pcoefp p) p)
	((eq (car p) var) (pcsub1 (cdr p) val () ()))
	((pointergp var (car p)) p)
	(t (psimp (car p) (pcsub2 (cdr p) (ncons val) (ncons var)))))) 

(defun pcsub1 (a val vals vars)
  (if (equal val 0) (pcsub (pterm a 0) vals vars)
      (do ((p (pt-red a) (pt-red p))
	   (ans (pcsub (pt-lc a) vals vars)
		(pplus (ptimes ans
			       (pexpt val (- ld (pt-le p))))
		       (pcsub (pt-lc p) vals vars)))
	   (ld (pt-le a) (pt-le p)))
	  ((null p) (ptimes ans (pexpt val ld))))))

(defun pcsub (p vals vars)
  (cond ((null vals) p)
	((pcoefp p) p)
	((eq (p-var p) (car vars)) (pcsub1 (p-terms p) (car vals)
					   (cdr vals) (cdr vars)))
	((pointergp (car vars) (p-var p))
	 (pcsub p (cdr vals) (cdr vars)))
	(t (psimp (p-var p) (pcsub2 (p-terms p) vals vars)))))

(defun pcsub2 (terms vals vars)
  (loop for (exp coef) on terms by #'cddr
	 unless (pzerop (setq coef (pcsub coef vals vars)))
	 nconc (list exp coef)))



(defmfun pderivative (p vari)
  (if (pcoefp p)
      0
      (psimp (p-var p) (cond ((eq vari (p-var p))
			      (pderivative2 (p-terms p)))
			     ((pointergp vari (p-var p))
			      (ptzero))
			     (t (pderivative3 (p-terms p) vari))))))

(defun pderivative2 (x)
  (cond ((null x) nil)
	((zerop (pt-le x)) nil)
	(t (pcoefadd (1- (pt-le x))
		     (pctimes (cmod (pt-le x)) (pt-lc x))
		     (pderivative2 (pt-red x))))))

(defun pderivative3 (x vari)
  (cond ((null x) nil)
	(t (pcoefadd
	    (pt-le x)
	    (pderivative (pt-lc x) vari)
	    (pderivative3 (pt-red x) vari)))))

(defmfun pdivide (x y)
  (cond ((pzerop y) (rat-error "Quotient by zero"))
	((pacoefp y) (list (ratreduce x y) (rzero)))
	((pacoefp x) (list (rzero) (cons x 1)))
	((pointergp (car x) (car y)) (list (ratreduce x y) (rzero)))
	(t (pdivide1 x y))))

(defun pdivide1 (u v)
  (prog (k inc lcu lcv q r)
     (setq lcv (cons (caddr v) 1))
     (setq q (rzero))
     (setq r (cons u 1) )
     a    (setq k (- (pdegree (car r) (p-var v)) (p-le v)))
     (if (minusp k) (return (list q r)))
     (setq lcu (cons (p-lc (car r)) (cdr r)))
     (setq inc (ratquotient lcu lcv))
     (setq inc (cons (psimp (car v) (list k (car inc)))
		     (cdr inc)))
     (setq q (ratplus q inc))
     (setq r (ratplus r  (rattimes (cons (pminus v) 1) inc t)))
     (go a)))
	 
(defmfun pexpt (p n)
  (cond ((= n 0) 1)
	((= n 1) p)
	((minusp n) (pquotient 1 (pexpt p (- n))))
	((pcoefp p) (cexpt p n))
	((alg p) (pexptsq p n))
	((null (p-red p))
	 (psimp (p-var p)
		(pcoefadd (* n (p-le p)) (pexpt (p-lc p) n) nil)))
	(t (let ((*a* (1+ n))
		 (*x* (psimp (p-var p) (p-red p)))
		 (b (make-poly (p-var p) (p-le p) (p-lc p))))
	     (do ((bl (list (pexpt b 2) b)
		      (cons (ptimes b (car bl)) bl))
		  (m 2 (1+ m)))
		 ((= m n) (pplus (car bl)
				 (pexpt2 1 1 *x* (cdr bl)))))))))

(defun nxtbincoef (m nom)
  (truncate (* nom (- *a* m)) m))

(defun pexpt2 (m nom b l)
  (if (null l) b
      (pplus (ptimes (pctimes (cmod (setq nom (nxtbincoef m nom))) b) (car l))
	     (pexpt2 (1+ m)
		     nom
		     (if (eq *x* b) (pexpt b 2)
			 (ptimes *x* b))
		     (cdr l)))))

(defmfun pminusp (p)
  (if (realp p) (minusp p)
      (pminusp (p-lc p))))

(defmfun pminus (p)
  (if (pcoefp p) (cminus p)
      (cons (p-var p) (pminus1 (p-terms p)))))

(defun pminus1 (x)
  (loop for (exp coef) on x by #'cddr
	 nconc (list exp (pminus coef))))

(defmfun pmod (p)
  (if (pcoefp p) (cmod p)
      (psimp (car p)
	     (loop for (exp coef) on (p-terms p) by #'cddr
		    unless (pzerop (setq coef (pmod coef)))
		    nconc (list exp coef)))))

(defmfun pquotient (x y)
  (cond ((pcoefp x)
	 (cond ((pzerop x) (pzero))
	       ((pcoefp y) (cquotient x y))
	       ((alg y) (paquo x y))
	       (t (rat-error "Quotient by a polynomial of higher degree"))))
	((pcoefp y) (cond ((pzerop y) (rat-error "Quotient by zero"))
			  (modulus (pctimes (crecip y) x))
			  (t (pcquotient x y))))
	((alg y) (or (let ($algebraic)
                       (ignore-rat-err (pquotient x y)))
		     (patimes x (rainv y))))
	((pointergp (p-var x) (p-var y)) (pcquotient x y))
	((or (pointergp (p-var y) (p-var x)) (> (p-le y) (p-le x)))
	 (rat-error "Quotient by a polynomial of higher degree"))
	(t (psimp (p-var x) (pquotient1 (p-terms x) (p-terms y))))))

(defun pcquotient (p q)
  (psimp (p-var p) (pcquotient1 (p-terms p) q)))

(defun pcquotient1 (p1 q)
  (loop for (exp coef) on p1 by #'cddr
	 nconc (list exp (pquotient coef q))))

(declare-top(special k q*)
	    (fixnum k i))

(defun pquotient1 (u v &aux q* (k 0))
  (declare (fixnum k))
  (loop do (setq  k (- (pt-le u) (pt-le v)))
	 when (minusp k) do (rat-error "Polynomial quotient is not exact")
	 nconc (list k (setq q* (pquotient (pt-lc u) (pt-lc v))))
	 until (ptzerop (setq u (pquotient2 (pt-red u) (pt-red v))))))

(defun pquotient2 (x y &aux (i 0))	;X-v^k*Y*Q*
  (cond ((null y) x)
	((null x) (pcetimes1 y k (pminus q*)))
	((minusp (setq i (- (pt-le x) (pt-le y) k)))
	 (pcoefadd (+ (pt-le y) k)
		   (ptimes q* (pminus (pt-lc y)))
		   (pquotient2 x (pt-red y))))
	((zerop i) (pcoefadd (pt-le x)
			     (pdifference (pt-lc x) (ptimes q* (pt-lc y)))
			     (pquotient2 (pt-red x) (pt-red y))))
	(t (cons (pt-le x) (cons (pt-lc x) (pquotient2 (pt-red x) y))))))

(declare-top (unspecial k q*))

(defun algord (var)
  (and $algebraic (get var 'algord)))

(defun psimp (var x)
  (cond ((ptzerop x) 0)
	((atom x) x)
	((zerop (pt-le x)) (pt-lc x))
	((algord var)			;wrong alg ordering
	 (do ((p x (cddr p)) (sum 0))
	     ((null p) (cond ((pzerop sum) (cons var x))
			     (t (pplus sum (psimp2 var x)))))
	   (unless (or (pcoefp (cadr p)) (pointergp var (caadr p)))
	     (setq sum (pplus sum
			      (if (zerop (pt-le p)) (pt-lc p)
				  (ptimes 
				   (make-poly var (pt-le p) 1)
				   (pt-lc p)))))
	     (setf (pt-lc p) 0))))
	(t (cons var x))))

(defun psimp1 (var x)
  (let ($algebraic) (psimp var x)))

(defun psimp2 (var x)
  (do ((p (setq x (cons nil x)) ))
      ((null (cdr p)) (psimp1 var (cdr x)))
    (cond ((pzerop (caddr p)) (rplacd p (cdddr p)))
	  (t (setq p (cddr p))))))

(defun pterm  (p n)
  (do ((p p (pt-red p)))
      ((ptzerop p) (pzero))
    (cond ((< (pt-le p) n) (return (pzero)))
	  ((= (pt-le p) n) (return (pt-lc p))))))


(defmfun ptimes (x y)
  (cond ((pcoefp x) (if (pzerop x) (pzero) (pctimes x y)))
	((pcoefp y) (if (pzerop y) (pzero) (pctimes y x)))
	((eq (p-var x) (p-var y))
	 (palgsimp (p-var x) (ptimes1 (p-terms x) (p-terms y)) (alg x)))
	((pointergp (p-var x) (p-var y))
	 (psimp (p-var x) (pctimes1 y (p-terms x))))
	(t (psimp (p-var y) (pctimes1 x (p-terms y))))))

(defun   ptimes1 (x y-orig &aux uuu  )
  (do ((vvv (setq uuu (pcetimes1 y-orig (pt-le x) (pt-lc x))))
       (x (pt-red x) (pt-red x)))
      ((ptzerop x) uuu)
    (let ((y y-orig) (xe (pt-le x)) (xc (pt-lc x)))
      (prog (e u c) 
       a1 (cond ((null y) (return nil)))
       (setq e (+ xe (car y)))
       (setq c (ptimes (cadr y) xc))
       (cond ((pzerop c) (setq y (cddr y)) (go a1))
	     ((or (null vvv) (> e (car vvv)))
	      (setq uuu (setq vvv (pplus1 uuu (list e c))))
	      (setq y (cddr y)) (go a1))
	     ((= e (car vvv))
	      (setq c (pplus c (cadr vvv)))
	      (cond ((pzerop c)
		     (setq uuu (setq vvv (pdiffer1 uuu (list (car vvv) (cadr vvv))))))
		    (t (rplaca (cdr vvv) c)))
	      (setq y (cddr y))
	      (go a1)))
       a  
       (cond ((and (cddr vvv) (> (caddr vvv) e))
	      (setq vvv (cddr vvv)) (go a)))
       (setq u (cdr vvv ))
       b  (cond ((or (null (cdr u)) (< (cadr u) e))
		 (rplacd u (cons e (cons c (cdr u)))) (go e)))
       (cond ((pzerop (setq c (pplus (caddr u) c)))
	      (rplacd u (cdddr u)) (go d))
	     (t (rplaca (cddr u) c)))
       e  (setq u (cddr u))
       d  (setq y (cddr y))
       (cond ((null y) (return nil)))
       (setq e (+ xe (car y)))
       (setq c (ptimes (cadr y) xc))
       c  (cond ((and (cdr u) (> (cadr u) e)) (setq u (cddr u)) (go c)))
       (go b))))
  uuu)

(defun pcetimes1 (y e c)		;C*V^E*Y
  (loop for (exp coef) on y by #'cddr
	 unless (pzerop (setq coef (ptimes c coef)))
	 nconc (list (+ e exp) coef)))

(defun pctimes (c p)
  (if (pcoefp p) (ctimes c p)
      (psimp (p-var p) (pctimes1 c (p-terms p)))))

(defun pctimes1 (c terms)
  (loop for (exp coef) on terms by #'cddr
	 unless (pzerop (setq coef (ptimes c coef)))
	 nconc (list exp coef)))

(defun leadalgcoef (p)
  (cond ((pacoefp p) p)
	(t (leadalgcoef (p-lc p))) ))

(defun painvmod (q)
  (cond ((pcoefp q) (crecip q))
	(t (paquo (list (car q) 0 1) q ))))

(defun palgsimp (var p tell)		;TELL=(N X) -> X^(1/N)
  (psimp var (cond ((or (null tell) (null p)
			(< (car p) (car tell))) p)
		   ((null (cddr tell)) (pasimp1 p (car tell) (cadr tell)))
		   (t (pgcd1 p tell)) )))

(defun pasimp1 (p deg kernel)		;assumes deg>=(car p)
  (do ((a p (pt-red a))
       (b p a))
      ((or (null a) (< (pt-le a) deg))
       (rplacd (cdr b) nil)
       (pplus1 (pctimes1 kernel p) a))
    (rplaca a (- (pt-le a) deg))))

(defmfun monize (p) 
  (cond ((pcoefp p) (if (pzerop p) p 1))
	(t (cons (p-var p) (pmonicize (copy-list (p-terms p)))))))

(defun pmonicize (p)			;CLOBBERS POLY
  (cond ((equal (pt-lc p) 1) p)
	(t (pmon1 (painvmod (leadalgcoef (pt-lc p))) p) p)))

(defun pmon1 (mult l)
  (cond (l (pmon1 mult (pt-red l))
	   (setf (pt-lc l) (ptimes mult (pt-lc l))))))

(defun pmonz (poly &aux lc)		;A^(N-1)*P(X/A)
  (setq poly (pabs poly))       
  (cond ((equal (setq lc (p-lc poly)) 1) poly)
	(t (do ((p (p-red poly) (pt-red p))
		(p1 (make-poly (p-var poly) (p-le poly) 1))
		(mult 1)
		(deg (1- (p-le poly)) (pt-le p)))
	       ((null p) p1)
	     (setq mult (ptimes mult (pexpt lc (- deg (pt-le p)))))
	     (nconc p1 (list (pt-le p) (ptimes mult (pt-lc p))))))))

;;	THESE ARE ROUTINES FOR MANIPULATING ALGEBRAIC NUMBERS

(defun algnormal (p) (car (rquotient p (leadalgcoef p))))

(defun algcontent (p)
  (destructuring-let* ((lcf (leadalgcoef p))
		       ((prim . denom) (rquotient p lcf)))
    (list (ratreduce lcf denom) prim)))

(defun rquotient (p q &aux algfac* a e)	;FINDS PSEUDO QUOTIENT IF PSEUDOREM=0
  (cond ((equal p q) (cons 1 1))
	((pcoefp q) (ratreduce p q))
	((setq a (testdivide p q)) (cons a 1))
	((alg q) (rattimes (cons p 1) (rainv q) t))
	(t (cond ((alg (setq a (leadalgcoef q)))
		  (setq a (rainv a))
		  (setq p (ptimes p (car a)))
		  (setq q (ptimes q (car a)))
		  (setq a (cdr a)) ))
	   (cond ((minusp (setq e (+ 1 (- (cadr q)) (pdegree p (car q)))))
		  (rat-error "Quotient by a polynomial of higher degree")))
	   (setq a (pexpt a e))
	   (ratreduce (or (testdivide (ptimes a p) q)
			  (prog2 (setq a (pexpt (p-lc q) e))
			      (pquotient (ptimes a p) q)))
		      a)) ))

(defun patimes (x r) (pquotientchk (ptimes x (car r)) (cdr r)))

(defun paquo (x y) (patimes x (rainv y)))

(defun mpget (var)
  (cond ((null (setq var (alg var))) nil)
	((cddr var) var)
	(t (list (car var) 1 0 (pminus (cadr var))))))


(defun rainv (q)
  (cond ((pcoefp q)
	 (cond (modulus (cons (crecip q) 1))
	       (t (cons 1 q))))
	(t (let ((var (car q)) (p (mpget q)))
	     (declare (special var))	;who uses this? --gsb
	     (cond ((null p) (cons 1 q))
		   (t (setq p (car (let ($ratalgdenom)
				     (bprog q (cons var p)))))
		      (rattimes (cons (car p) 1) (rainv (cdr p)) t)))))))

(defun pexptsq (p n)
  (do ((n (ash n -1) (ash n -1))
       (s (if (oddp n) p 1)))
      ((zerop n) s)
    (setq p (ptimes p p))
    (and (oddp n) (setq s (ptimes s p))) ))

;;	THIS IS THE END OF THE NEW RATIONAL FUNCTION PACKAGE PART 1.

;; Someone should determine which of the variables special in this file
;; (and others) are really special and which are used just for dynamic
;; scoping.  -- cwh

(declare-top (unspecial *a* *x*))
