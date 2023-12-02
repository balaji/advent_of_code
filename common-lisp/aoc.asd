(in-package :asdf-user)

(defsystem "aoc"
  :author "Balaji Damodaran <damodaran.balaji@gmail.com>"
  :version "0.0.1"
  :license "MIT"
  :description "advent of code solutions"
  :homepage ""
  :bug-tracker ""
  :source-control (:git "")

  ;; Dependencies.
  :depends-on (:cl-ppcre)

  ;; Project stucture.
  :serial t
  :components ((:module "src"
                        :serial t
                        :components ((:module "2023"
                                              :serial t
                                              :components ((:file "package")
                                                           (:file "day01")))
                                     (:file "packages")
                                     (:file "aoc"))))

  ;; Build a binary:
  ;; don't change this line.
  :build-operation "program-op"
  ;; binary name: adapt.
  :build-pathname "aoc"
  ;; entry point: here "main" is an exported symbol. Otherwise, use a double ::
  :entry-point "aoc:main")
