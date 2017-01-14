; Exercise 4.16: In this exercise we implement the method just described for interpreting internal definitions. We assume that the evaluator supports let (see Exercise 4.6).

; Change lookup-variable-value (4.1.3) to signal an error if the value it finds is the symbol *unassigned*.
; Write a procedure scan-out-defines that takes a procedure body and returns an equivalent one that has no internal definitions, by making the transformation described above.
; Install scan-out-defines in the interpreter, either in make-procedure or in procedure-body (see 4.1.3). Which place is better? Why?

(load "/Users/soulomoon/git/SICP/Chapter4/Exercise4.06.scm")

; 1
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (if (eq? (car vals) '*unassigned*)
                 (error "unassigned" var)
                 (car vals)))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

; 2
(define (scan-out-defines body)
  (define (notdefinition? exp) (not (definition? exp)))
  (define (filter l predict?)
    (let ((returns '()))
         (define (iter l)
            (if (null? l)
                returns
                (if (predict? (car l))
                    (begin 
                      (set! returns (cons (car l) returns))                   (iter (cdr l)) )
                    (iter (cdr l)))))
          (iter l)))
  (define (make-the-let-body defines notdefines) 
    (if defines
        (make-the-let-body 
          (cdr defines) 
          (cons 
            (list 'set! 
                  (definition-variable (car defines)) 
                  (definition-value (car defines)))
            notdefines))
        notdefines))
  (define (defines) (filter body definition?))
  (define (notdefines) (filter body notdefinition?))
  (display (defines))(newline )
  (if (defines)
      body
      (make-let 
        (map 
          (lambda (exp) 
                  (list (definition-variable exp) '*unassigned*))
          (defines))
          (make-the-let-body (defines) (notdefines)))))

(define (make-procedure parameters body env)
  (list 'procedure parameters (scan-out-defines body) env))



; it is better to install in the make-procedure otherwise you have to do the transformation every time the procedure is called
(interpret 
'(begin
  (define (test)
  (define b 2)
  (define (c) 3)
  (+ b (c)))
(test))
)
; Welcome to DrRacket, version 6.7 [3m].
; Language: SICP (PLaneT 1.18); memory limit: 128 MB.
; 'ok
; ((define (c) 3) (define b 2))
; ()
; 5
; > 