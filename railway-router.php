<?php
declare(strict_types=1);

/**
 * Railway router for PHP's built-in HTTP server.
 * Serve real static files directly and route all other requests through OwnPay.
 */
$path = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH);
if (PHP_SAPI === 'cli-server' && is_string($path) && $path !== '/') {
    $file = __DIR__ . '/public' . $path;
    if (is_file($file)) {
        return false;
    }
}
require __DIR__ . '/public/index.php';
