#!/usr/bin/env bash
php -S 0.0.0.0:8081 "$0"
exit
<?php
$body = json_decode(file_get_contents('php://input'), true);

error_log(var_export(apache_request_headers(), true));
error_log(var_export($body, true));
error_log("\n\n\n\n\n");
