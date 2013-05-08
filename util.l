; $Id: util.l 445 2005-11-26 09:48:11Z torihat $

(require "util")

(provide "sl/util")

(setq *util-name* "sl")
(setq *util-version* "0.0.0.1-2")

(setq *util-dev-dir*
  (merge-pathnames (concat "dev/" *util-name*) (si:system-root)))
(setq *util-targ-dir*
  (merge-pathnames (concat "site-lisp/" *util-name*) (si:system-root)))
(setq *util-archive-dir*
  (merge-pathnames "mirai/xyzzy/" (si:system-root)))

(setq *util-archive-file*
  (format nil "~A-~A.lzh"
	  *util-name*
	  *util-version*))

(setq *util-file-list* '(("sl.l"  . "site-lisp/sl.l")
			 ("sl.lc" . "site-lisp/sl.lc")
			 ("autoload.l" . "site-lisp/ni-autoload/JunkScripts/sl.l")
			 ))

(require "ni/local")

(defun util-ni-update ()
  (interactive)
  (let ((path (merge-pathnames *util-archive-file*
			       *util-archive-dir*)))
    (ni::local-app-add path *util-name*)))
