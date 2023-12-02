(in-package :2023)

(defun keys (plist res)
  (if (eq plist '()) res (keys (cddr plist) (cons (string-downcase (car plist)) res))))

(defparameter *number-plist* (list 'one "1" 'two "2" 'three "3" 'four "4" 'five "5" 'six "6" 'seven "7" 'eight "8" 'nine "9"))
(defparameter *backward-regex* (format nil "(~{~A|~}[0-9])" (mapcar #'reverse (keys *number-plist* '()))))
(defparameter *forward-regex* (format nil "(~{~A|~}[0-9])" (keys *number-plist* '())))

(defun run-day1 (lines)
  (list (solve #'part1 lines 0) (solve #'part2 lines 0)))

(defun solve (fn lines total)
  (if (eq lines '())
      total
      (solve fn (rest lines) (+ (* 10 (funcall fn (first lines))) (funcall fn (first lines) :from-end t) total))))

(defun part1 (line &key from-end)
  (digit-char-p (find-if #'digit-char-p line :from-end from-end)))

(defun part2 (line &key from-end)
  (let ((result (if (eq from-end t)
                    (reverse (ppcre:scan-to-strings *backward-regex* (reverse line)))
                    (ppcre:scan-to-strings *forward-regex* line))))
    (parse-integer (getf *number-plist* (read-from-string (format nil "2023::~A" result)) result))))