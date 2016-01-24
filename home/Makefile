UNAME = ${shell uname}
HOME_DIR = $(dir $(realpath Makefile))
SETUP_DIR = $(HOME_DIR)setup/
ifeq ($(UNAME),Darwin)
# for MacOSX

.PHONY: all
all: brew R

.PHONY: brew
brew:
	$(SETUP_DIR)brew.sh

.PHONY: R
R:
	R --vanilla --slave < $(SETUP_DIR)R-lang.R

endif

.PHONY: link
link:
	$(HOME_DIR)bin/makelink.sh $(HOME_DIR)

.PHONY: php
php:
	$(SETUP_DIR)php.sh
