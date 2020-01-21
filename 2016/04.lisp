(load "package.lisp")
(require "cl-ppcre")
(in-package :aoc2016)

(defun most-common-chars (hist)
  (map 'list #'car
       (sort (hash-table-alist hist)
             (lambda (l r) (or (> (cdr l) (cdr r))
                               (and (= (cdr l) (cdr r))
                                    (char< (car l) (car r))))))))

(defun real-room? (sector-name checksum)
  (starts-with-subseq checksum (most-common-chars
                                 (iter (for ch in-string sector-name)
                                       (when (alphanumericp ch)
                                         (collect-frequencies ch))))))

(defparameter *north-pole-rm-name*
  '(#\n #\o #\r #\t #\h #\p #\o #\l #\e #\o #\b #\j #\e #\c #\t
    #\s #\t #\o #\r #\a #\g #\e))

(defun north-pole-objs? (sector)
  (with (((sector-name sector-id) sector)
         (sid (parse-integer sector-id)))
    (iter (for ch in-string sector-name)
          (generating rm-ch in *north-pole-rm-name*)
          (when (alphanumericp ch)
            (always
              (char=
                (next rm-ch)
                (code-char (+ 97 (mod (+ sid (- (char-int ch) 97)) 26)))))))))

(defun main ()
  (princ
    (iter (for l in-stream *standard-input* using #'read-line)
          (cl-ppcre:register-groups-bind (sector-name sector-id checksum)
             ("((?:[a-z]+\\-)+)(\\d+)\\[([a-z]+)\\]" l)
             (when (real-room? sector-name checksum)
               (sum (parse-integer sector-id) into real-room-sid-sum)
               (finding-first (list sector-name sector-id)
                              such-that #'north-pole-objs? into npo))
             (finally (return (cons real-room-sid-sum npo)))))))
