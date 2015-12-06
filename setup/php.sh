#!/bin/sh

which composer || curl -sS https://getcomposer.org/installer | php -d detect_unicode=Off -- --install-dir=$HOME/bin --filename=composer
which php-cs-fixer  || composer global require fabpot/php-cs-fixer
which sql-formatter || composer global require jdorn/sql-formatter:dev-master
