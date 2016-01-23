UNAME = ${shell uname}
SETUP_DIR = $(dir $(realpath Makefile))..
ifeq ($(UNAME),Darwin)
# for MacOSX

.PHONY: all
all: brew R

.PHONY: brew
brew:
	$(SETUP_DIR)/setup/brew.sh

.PHONY: R
R:
	R --vanilla --slave < $(SETUP_DIR)/setup/R-lang.R

endif

.PHONY: php
php:
	$(SETUP_DIR)/setup/php.sh
