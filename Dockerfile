FROM php:8.3-cli

RUN apt-get update \
    && apt-get install -y --no-install-recommends libcurl4-openssl-dev libonig-dev unzip \
    && docker-php-ext-install bcmath curl mbstring pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/html
COPY . .

RUN composer install --no-dev --prefer-dist --no-interaction --no-progress --optimize-autoloader \
    && mkdir -p storage public/assets/uploads \
    && chown -R www-data:www-data storage public/assets/uploads \
    && chmod -R ug+rwX storage public/assets/uploads

EXPOSE 80
CMD ["php", "-S", "0.0.0.0:80", "-t", "public", "railway-router.php"]
