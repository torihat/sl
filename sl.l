;;; -*- Mode: Lisp; Package: User -*-
;;; $Id: sl.l 445 2005-11-26 09:48:11Z torihat $
;
;  sl.l - sl(1) for xyzzy
;
;  by Masashi Hattori
;
;;; What's this?
;
;   豊田さんの sl(1) をxyzzy上で動くようにしたものです。
;   http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/
;
;;; Install
;
;   1. sl.l を site-lisp などに置く。
;   2. したければ byte compile する。
;   3. .xyzzy などに以下を追加する。
;      (auto-load 'sl "sl" t)
;   4. うっかり、"M-x sl" と打ってみる

(defvar *sl-speed* 0.05
  "SLの走るスピード")

(defvar *sl-buffer* " *SL*")

(defvar *sl-smoke*
  '((
     "                              ( )   ( )    (@)    ( )   ( )   (@)   ( )   ( )   (@)"
     "                  (@)                                                              "
     "            (  )                                                                   "
     "        (    )                                                                     "
     "                                                                                   "
     "     (@@@)                                                                         "
     )
    (
     "                              (@)   ( )    ( )    (@)   ( )   ( )   (@)   ( )   ( )"
     "                  ( )                                                              "
     "            (  )                                                                   "
     "        (@@@@)                                                                     "
     "                                                                                   "
     "     (   )                                                                         "
     )
    (
     "                              ( )   (@)    ( )    ( )   (@)   ( )   ( )   (@)   ( )"
     "                  ( )                                                              "
     "            (@@)                                                                   "
     "        (    )                                                                     "
     "                                                                                   "
     "     (   )                                                                         "
     )))

(defvar *sl-body*
  '(
    "      ====        ________                ___________"
    "  _D _|  |_______/        \\__I_I_____===__|_________|"
    "   |(_)---  |   H\\________/ |   |        =|___ ___|  "
    "   /     |  |   H  |  |     |   |         ||_| |_||  "
    "  |      |  |   H  |__--------------------| [___] |  "
    "  | ________|___H__/__|_____/[][]~\\_______|       |  "
    "  |/ |   |-----------I_____I [][] []  D   |=======|__"
    ))

(defvar *sl-wheel*
  '((
     "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__"
     " |/-=|___|=    ||    ||    ||    |_____/~\\___/       "
     "  \\_/      \\O=====O=====O=====O_/      \\_/           "
     )
    (
     "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__"
     " |/-=|___|=    ||    ||    ||    |_____/~\\___/       "
     "  \\_/      \\_O=====O=====O=====O/      \\_/           "
     )
    (
     "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__"
     " |/-=|___|=   O=====O=====O=====O|_____/~\\___/       "
     "  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/           "
     )
    (
     "__/ =| o |=-~O=====O=====O=====O\\ ____Y___________|__"
     " |/-=|___|=    ||    ||    ||    |_____/~\\___/       "
     "  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/           "
     )
    (
     "__/ =| o |=-O=====O=====O=====O \\ ____Y___________|__"
     " |/-=|___|=    ||    ||    ||    |_____/~\\___/       "
     "  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/           "
     )
    (
     "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__"
     " |/-=|___|=O=====O=====O=====O   |_____/~\\___/       "
     "  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/           "
     )
    ))

(defvar *sl-body-last*
  '(
    "                              "
    "                              "
    "    _________________         "
    "   _|                \\_____A "
    " =|                        |  "
    " -|                        |  "
    "__|________________________|_ "
    "|__________________________|_ "
    "   |_D__D__D_|  |_D__D__D_|   "
    "    \\_/   \\_/    \\_/   \\_/"
    ))


(defun sl-buffer ()
  (set-buffer (get-buffer-create *sl-buffer*))
  (setq need-not-save t)
  (set-local-window-flags (selected-buffer)
			  *window-flag-line-number* nil)
  (set-local-window-flags (selected-buffer)
			  *window-flag-newline* nil)
  (set-local-window-flags (selected-buffer)
			  *window-flag-half-width-space* nil)
  (set-local-window-flags (selected-buffer)
			  *window-flag-full-width-space* nil)
  (set-local-window-flags (selected-buffer)
			  *window-flag-eof* nil))

(defun sl-body-lines (space-width)
  (let (lines
	(body-line (list-length *sl-body*)))
    (dotimes (i body-line)
      (push (format nil "~VA~A~A~%"
		    (max 0 space-width)
		    ""
		    (nth i *sl-body*)
		    (nth i *sl-body-last*))
	    lines))
    (nreverse lines)))

(defvar *sl-smoke-speed* 2)

(defun sl-smoke-lines (i space-width)
  (let ((smoke (nth (mod (floor i *sl-smoke-speed*) (list-length *sl-smoke*)) *sl-smoke*)))
    (mapcar #'(lambda (x)
		(format nil "~VA~A~%"
			(max 0 space-width)
			""
			x))
	    smoke)))

(defun sl-wheel-lines (i space-width)
  (let* (lines
	 (wheel (nth i *sl-wheel*))
	 (body-line (list-length *sl-body*))
	 (wheel-line (list-length wheel)))
    (dotimes (i wheel-line)
      (push (format nil "~VA~A~A~%"
		    (max 0 space-width)
		    ""
		    (nth i wheel)
		    (nth (+ i body-line) *sl-body-last*))
	    lines))
    (nreverse lines)))

(defun sl-create-lines (pattern space-width)
  (let (lines
	(body (sl-body-lines space-width)))
    (dotimes (i pattern)
      (let ((smoke (sl-smoke-lines i space-width))
	    (wheel (sl-wheel-lines i space-width)))
	(push (append smoke body wheel) lines)))
    (nreverse lines)))

(defun sl-length (sl-lines)
  (let ((len 0))
    (mapc #'(lambda (x)
	      (mapc #'(lambda (y)
			(setq len (max len (length y))))
		    x))
	  sl-lines)
    len))

(defun sl-space-height (height)
  (let ((height 0)
	(rest (- (window-height) height)))
    (when (< 0 rest)
      (setq height (floor rest 2)))
    height))

(defun sl-height (sl-lines)
  (list-length (car sl-lines)))

(defun sl-print (lines cnt height)
  (erase-buffer (selected-buffer))
  (insert "\n" height)
  (mapc #'(lambda (x)
	    (let ((len (1- (length x))))
	      (insert (substring x (min len cnt)))))
	lines)
  (goto-char (point-min)))

(defun sl (&optional reverse)
  (interactive "p")
    (save-window-excursion
      (delete-other-windows)
      (sl-buffer)
      (refresh-screen)
      (let* ((pattern (list-length *sl-wheel*))
	     (space-width (window-width))
	     (sl-lines (sl-create-lines pattern space-width))
	     (line-length (sl-length sl-lines))
	     (line-height (sl-height sl-lines))
	     (space-height (sl-space-height line-height)))
	(dotimes (i line-length)
	  (let ((cnt (if reverse (- line-length i) i)))
	    (sl-print (nth (mod cnt pattern) sl-lines)
		      cnt
		      space-height)
	    (do-events)
	    (sit-for *sl-speed*)))
	(delete-buffer *sl-buffer*))))
