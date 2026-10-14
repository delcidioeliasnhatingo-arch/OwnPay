FROM php:8.3-cli

RUN apt-get update \
    && apt-get install -y --no-install-recommends libcurl4-openssl-dev libonig-dev libpng-dev libjpeg62-turbo-dev libfreetype6-dev unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install bcmath curl gd mbstring pdo_mysql \
    && php -m | grep -i '^gd$' \
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
