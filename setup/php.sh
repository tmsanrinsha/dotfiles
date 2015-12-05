#!/bin/sh

curl -sS https://getcomposer.org/installer | php -- --install-dir=bin --filename=composer
composr global require fabpot/php-cs-fixer
