UNAME = ${shell uname}
ifeq ($(UNAME),Darwin)
# for MacOSX

.PHONY: all
all: brew R

.PHONY: brew
brew:
	$(dir $(realpath Makefile))../setup/brew.sh

.PHONY: R
R:
	R --vanilla --slave < $(dir $(realpath Makefile))../setup/R-lang.R

endif

.PHONY: php
php:
	$(dir $(realpath Makefile))../setup/php.sh
