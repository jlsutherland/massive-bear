#! /bin/bash

mkdir site-lisp
git clone git@github.com:emacs-ess/ESS.git site-lisp/ESS
git clone git@github.com:magit/magit.git site-lisp/magit
git clone git@github.com:jwiegley/org-mode.git site-lisp/org-mode
git clone git@github.com:vspinu/polymode.git site-lisp/polymode
cd site-lisp/org-mode && make autoloads
