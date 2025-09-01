up:
\tdocker compose -f docker/compose.yml up -d --build

down:
\tdocker compose -f docker/compose.yml down

logs:
\tdocker compose -f docker/compose.yml logs -f

lint:
\tbash scripts/lint.sh

test:
\tbash scripts/test.sh
