(require :asdf)
(asdf:load-system :clingon)

(defpackage #:foo
  (:use #:cl)
  (:export #:toplevel #:greet #:main))

(in-package #:foo)

(defun greet ()
  (write-line "teto speaking, hi master !"))

(defun handle-command (command)
  (let ((config (clingon:getopt command :config))
        (verbose (clingon:getopt command :verbose))
        (branch (clingon:getopt command :branch))
        (files (clingon:command-arguments command)))
    (format t "Config:  ~a~%" config)
    (format t "Verbose: ~a~%" verbose)
    (format t "Branch:  ~a~%" branch)
    (format t "Files:   ~s~%" files)))

(defun start-check (command)
  (let* ((branch (clingon:getopt command :branch))
         (reference (format nil "refs/heads/~a" branch)))
    (multiple-value-bind (stdout stderr exit-code)
        (uiop:run-program
         (list "git" "ls-remote"
               "https://github.com/NixOS/nixpkgs.git"
               reference)
         :output :string
         :error-output :string
         :ignore-error-status t)
      (format t "stdout: ~a~%" stdout)
      (unless (uiop:emptyp stderr)
        (format *error-output* "stderr: ~a~%" stderr))
      (unless (zerop exit-code)
        (error "git ls-remote failed with status ~d" exit-code)))))

;; Clingon example: https://github.com/dnaeon/clingon
(defun make-app ()
  (clingon:make-command
   :name "nixpkgs-monitor"
   :version "0.1.0"
   :authors '("John Doe <john.doe@example.org>")
   :license "GPL-3"
   :description "Monitor nixos-unstable"
   :handler #'start-check
   :options
   (list
    (clingon:make-option
     :string
     :short-name #\c
     :long-name "config"
     :description "JSON configuration file"
     :initial-value "config.json"
     :key :config)
    (clingon:make-option
     :string
     :short-name #\b
     :long-name "branch"
     :initial-value "nixos-unstable"
     :env-vars '("NIXOS_BRANCH")
     :description "Branch name"
     :key :branch)
    (clingon:make-option
     :flag
     :short-name #\v
     :long-name "verbose"
     :description "Enable verbose output"
     :key :verbose))))

(defun main ()
  (clingon:run (make-app)))
