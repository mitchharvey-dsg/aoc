(defun tostring (symbol)
  (intern (string symbol)))

(defun map-range (lambda min max &optional (step 1))
  (loop for i from min upto max by step
     collect (funcall lambda i)))

(defun getdigitorwritten (ins)
  (cond ((str:digit? (str:s-first ins)) (parse-integer (str:s-first ins)))
        ((str:starts-with-p "one" ins) 1) ; could be done shorter by lookup if match array of words, return index
        ((str:starts-with-p "two" ins) 2)
        ((str:starts-with-p "three" ins) 3)
        ((str:starts-with-p "four" ins) 4)
        ((str:starts-with-p "five" ins) 5)
        ((str:starts-with-p "six" ins) 6)
        ((str:starts-with-p "seven" ins) 7)
        ((str:starts-with-p "eight" ins) 8)
        ((str:starts-with-p "nine" ins) 9)
        ((str:starts-with-p "zero" ins) 0)
        (t nil)))

(defun getfirstlastint (ins)
  ; (print string)
  (let ((numbers (map-range
    (lambda (i) (getdigitorwritten (str:substring i (length ins) ins)))
    0
    (length ins))))
  (+ 
      (* 10 (find-if-not 'null numbers))
      (find-if-not 'null numbers :from-end t)
  )))

(let ((ins (uiop:read-file-lines "1/b/input")))
  (apply '+ (map 'list 'getfirstlastint ins)))