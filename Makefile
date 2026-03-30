DOCKER_COMPOSE ?= docker compose

.PHONY: setup build up down restart logs artisan npm clean quality

setup:
	@echo "==> First-time setup: composer/npm install, key generation, sqlite creation, migrations, docker build"
	@cp -n .env.example .env
	composer install --prefer-dist --no-interaction
	npm install
	php artisan key:generate --ansi
	php -r "file_exists('database/database.sqlite') || touch('database/database.sqlite');"
	php artisan migrate --force
	$(DOCKER_COMPOSE) build

build:
	@echo "==> docker compose build"
	$(DOCKER_COMPOSE) build --parallel

up:
	@echo "==> docker compose up -d"
	$(DOCKER_COMPOSE) up -d --remove-orphans

down:
	@echo "==> docker compose down"
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

restart: down up

logs:
	@echo "==> docker compose logs --follow"
	$(DOCKER_COMPOSE) logs --follow

artisan:
	$(DOCKER_COMPOSE) exec app php artisan $(filter-out $@,$(MAKECMDGOALS))

npm:
	$(DOCKER_COMPOSE) exec frontend npm $(filter-out $@,$(MAKECMDGOALS))

clean:
	@echo "==> Removing node_modules and vendor"
	rm -rf node_modules vendor

quality:
	@echo "==> Running local quality checks (lint/audits/phpstan/pint/phpunit)"
	npm run lint
	npm audit --audit-level=moderate || true
	composer audit --no-interaction || true
	vendor/bin/phpstan analyse --memory-limit=512M --no-progress --debug
	vendor/bin/pint -- --no-progress
	vendor/bin/phpunit
