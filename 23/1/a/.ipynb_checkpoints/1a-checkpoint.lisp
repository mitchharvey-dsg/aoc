(defun tostring (symbol)
  (intern (string symbol)))

(defun getfirstlastint (string)
  ; (print string)
  (parse-integer (coerce
    (list (reduce (lambda (old new) (if (and (eq old nil) (digit-char-p new)) new old)) string :initial-value nil)
          (reduce (lambda (old new) (if (digit-char-p new) new old)) string))
    'string)))

(let ((ins (uiop:read-file-lines "1/a/input")))
  (apply '+ (map 'list 'getfirstlastint ins)))

; Misunderstood problem, saving for future reference
; This will output every found pair
; (let ((ins (uiop:read-file-lines "1/a/eginput")))
;   (with-open-file (stream "1/a/egoutput"
;                           :direction :output
;                           :if-exists :supersede
;                           :if-does-not-exist :create)
;     (loop for i in ins
;           do (format stream "~d~C" (getfirstlastint i) #\newline))))