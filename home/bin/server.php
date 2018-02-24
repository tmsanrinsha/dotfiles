#!/usr/bin/env bash
php -S 0.0.0.0:8081 "$0"
exit
<?php
$body = json_encode(file_get_contents('php:/input'), true);

error_log(var_export(get_headers(), true));
error_log(var_export($body, true));
error_log("\n\n\n\n\n");
