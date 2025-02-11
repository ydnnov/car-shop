#!/bin/sh

set -e

if [ ! -f ".env" ]; then
    cp .env.example .env
fi

if [ ! -d "vendor" ]; then
    composer install --optimize-autoloader
fi

chmod -R 777 storage bootstrap/cache

php artisan key:generate

php artisan storage:link

export $(grep -v '^#' .env | xargs)

until nc -z -v -w30 "$DB_HOST" "$DB_PORT"; do
  echo "Waiting for the database ($DB_HOST:$DB_PORT)..."
  sleep 2
done

php artisan migrate:fresh --seed

exec "$@"
