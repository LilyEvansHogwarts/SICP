; Exercise 4.9: Many languages support a variety of iteration constructs, such as do, for, while, and until. In Scheme, iterative processes can be expressed in terms of ordinary procedure calls, so special iteration constructs provide no essential gain in computational power. On the other hand, such constructs are often convenient. Design some iteration constructs, give examples of their use, and show how to implement them as derived expressions.
(load "/home/soulomoon/git/SICP/Chapter4/Exercise4.08.scm")

(define (do-bindings exp)
  (cadr exp))
(define (do-vars exp)
  (map car (do-bindings exp)))
(define (do-inits exp)
  (map cadr (do-bindings exp)))
(define (do-steps exp)
  (map caddr (do-bindings exp)))


(define (do-clause exp)
  (caddr exp))
(define (do-clause-test exp)
  (car (do-clause exp)))
(define (do-clause-expressions exp)
  (cddr (do-clause exp)))
(define (do-commands exp)
  (cdddr exp))

; (let)

; (do ((vars inits steps))
;   (test expression..)
;   command...
; )

; (display (cons (map + '(1 2) '(3 4)) 'test))

(define (make-assignment var arg)
  (list 'set! var arg))

(define (do=>let exp)
  (let ((vars (do-vars exp))
        (inits (do-inits exp)))
        (let ((pairs (map cons vars inits))
              (body 
                (make-let-whole
                  'iter
                  '()
                  (make-if
                    (do-clause-test exp)
                    (sequence->exp (do-clause-expressions exp))
                    (sequence->exp
                      (list 
                        (sequence->exp
                          (map 
                            make-assignment
                              vars
                              inits))
                        (sequence->exp (do-commands exp))
                        '(iter)))))))
              (display body)
              (apply
                make-let
                (cons 
                  pairs
                  body)))))

; (do=>let )


; (do ((<variable1> <init1> <step1>)‌‌syntax 
; ...)
; (<test> <expression> ...)
; <command> ...)

; (do ()

; )


(do=>let '(do ((i 0 (+ i 1)))
          ((= i 5) i)
          (display i)))


; (let
;   ((var1 init1)
;    (var2 init2)
;    ...)
;   (let iter
;         ()
;         (if test
;             (sequence->exp expressions)
;             (sequence->exp
;               (list
;                 (sequence->exp
;                   (set! var1 step1)
;                   (set! var2 step2)
;                   ...
;                 )
;                 (sequence->exp commands)
;                 (iter))
;             ))))

; ; (do ((var init )))


; ; (define (eval-do exp)
; ;   ())

; (define x 1)
; (define (fx) (+ x 1))

; (define (y) 
;   (define x 2)
;   (fx))