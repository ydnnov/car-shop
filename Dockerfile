FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    libpq-dev unzip curl netcat-openbsd \
    && docker-php-ext-install pdo pdo_pgsql

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

RUN groupadd -g 1000 appuser && useradd -m -u 1000 -g appuser appuser

RUN chown -R appuser:appuser /var/www

USER appuser

CMD ["php-fpm"]
