LISP ?= sbcl

run:
	rlwrap $(LISP) --load run.lisp

build:
	$(LISP)	--non-interactive \
		--load aoc.asd \
		--eval '(ql:quickload :aoc)' \
		--eval '(asdf:make :aoc)'
