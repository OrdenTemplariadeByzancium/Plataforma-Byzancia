up:
	docker compose -f docker/compose.yml up -d --build

down:
	docker compose -f docker/compose.yml down

logs:
	docker compose -f docker/compose.yml logs -f

lint:
	bash scripts/lint.sh

test:
	bash scripts/test.sh

