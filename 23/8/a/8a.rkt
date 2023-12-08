#lang racket
(require parsack)

(define $string
  (parser-compose (letters <- (many $letter))
                  (return (list->string letters))))
(define $node
  (parser-compose (address <- $string)
                  (many $space)
                  (char #\=)
                  (many $space)
                  (char #\()
                  (l <- $string)
                  (char #\,)
                  (many $space)
                  (r <- $string)
                  (char #\))
                  (return (cons address (cons l r)))))

(define input (file->lines "input"))
(define parsed (map (λ (a) (parse-result $node a)) input)) ; this could be done in one line
(define instructions "LLRLLRLRLRRRLLRRRLRRLRLRLRLRLRLRRLRRRLRLLRRLRRLRRRLLRLLRRLLRRRLLLRLRRRLLLLRRRLLRRRLRRLRLLRLRLRRRLRRRLRRLRRLRRLRLLRRRLRRLRRRLLRRRLRLRRLLRRLLRLRLRRLRRLLRLLRRLRLLRRRLLRRRLRRLLRRLRRRLRLRRRLRRLLLRLLRLLRRRLRLRLRLRRLRRRLLLRRRLRRRLRRRLRRLRLRLRLRRRLRRLLRLRRRLRLRLRRLLLRRRR")

(define (navigate i address [acc 0])
  (if (equal? address "ZZZ")
      acc
      (let* ([idx (if (>= i (string-length instructions)) 0 i)]
            [cinstruction (string-ref instructions idx)]
            [node (findf (λ (node) (equal? address (car node))) parsed)]
            [next (cond
                    [(equal? cinstruction #\L) (cadr node)]
                    [(equal? cinstruction #\R) (cddr node)]
                    )])
        (printf "~a ~a: ~a ~a -> ~a\n" acc address node cinstruction next)
        (navigate (add1 idx) next (add1 acc)))))

(navigate 0 "AAA")