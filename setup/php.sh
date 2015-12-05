#!/bin/sh

curl -sS https://getcomposer.org/installer | php -d detect_unicode=Off -- --install-dir=$HOME/bin --filename=composer
composer global require fabpot/php-cs-fixer
