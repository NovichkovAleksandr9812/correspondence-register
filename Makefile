include .env
export

export PROJECT_ROOT=$(shell pwd)

env-up:
	@docker compose up -d corresp-postgres

env-down:
	@docker compose down corresp-postgres

env-cleanup:
	@read -p "Delete all environment volume files? [Y/N]: " ans; \
	if [ "$$ans" = "Y" ]; then \
		docker compose down corresp-postgres && \
		rm -rf out/pgdata && \
		echo "Environment files have been cleared"; \
	else \
		echo "Environment cleanup canceled"; \
	fi

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "seq parameter is not filled in"; \
		exit 1; \
	fi; \
	docker compose run --rm corresp-postgres-migrate \
		create \
		-ext sql \
		-dir //migrations \
		-seq "$(seq)"

migrate-up:
	@make migrate-action action=up

migrate-down:
	@make migrate-action action=down

migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "action parameter is not filled in"; \
		exit 1; \
	fi; \
	docker compose run --rm corresp-postgres-migrate \
		-path //migrations \
		-database postgres://$${POSTGRES_USER}:$${POSTGRES_PASSWORD}@corresp-postgres:5432/$${POSTGRES_DB}?sslmode=disable \
		"$(action)"

env-port-forward:
	@docker compose up -d port-forwarder

env-port-close:
	@docker compose down port-forwarder