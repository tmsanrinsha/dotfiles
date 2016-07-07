UNAME = ${shell uname}
HOME_DIR = $(dir $(realpath Makefile))
SETUP_DIR = $(HOME_DIR)../setup/

.PHONY: all
ifeq ($(UNAME),Darwin)
all: brew R
else
all: setup
endif

.PHONY: setup
setup:
	$(SETUP_DIR)setup.sh

.PHONY: link
link:
	$(HOME_DIR)bin/makelink.sh $(HOME_DIR)

.PHONY: brew
brew:
	$(SETUP_DIR)brew.sh

.PHONY: php
php:
	$(SETUP_DIR)php.sh

.PHONY: R
R:
	R --vanilla --slave < $(SETUP_DIR)R-lang.R

.PHONY: ruby
ruby:
	$(SETUP_DIR)ruby.sh
