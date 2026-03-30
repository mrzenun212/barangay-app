DOCKER_COMPOSE ?= docker compose

.PHONY: setup build up down restart logs artisan npm clean quality

setup:
	@echo "==> First-time setup: building and starting containers"
	@[ -f .env ] || cp .env.example .env
	$(MAKE) build
	$(MAKE) up
	$(DOCKER_COMPOSE) exec app composer install --no-interaction
	$(DOCKER_COMPOSE) exec app php artisan key:generate --no-interaction
	$(DOCKER_COMPOSE) exec app php artisan migrate --no-interaction
	$(DOCKER_COMPOSE) exec frontend npm install
	$(DOCKER_COMPOSE) exec frontend npm run build
	@echo ""
	@echo "Setup complete! App running at http://localhost:$${APP_PORT:-8001}"
	@echo "Mailpit UI at http://localhost:$${FORWARD_MAILPIT_PORT:-8025}"

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
