# ============================================
# Docker Compose Makefile
# ============================================
# Simplifies docker compose commands with correct --env-file flags
#
# Common usage:
#   make dev      - Full restart: down + build + up (recommended)
#   make dev-up   - Quick restart: down + up (no build)
#   make logs     - View logs
#   make shell    - Enter container
# ============================================

# Docker Compose command shortcuts (reduces duplication)
DC_DEV  := sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml
DC_TEST := sudo docker compose --env-file .env.TEST -f docker-compose.TEST.yml

.PHONY: dev dev-up dev-build dev-down down test test-up test-build test-down logs shell ps help

# Default target
help:
	@echo "DEV Commands:"
	@echo "  make dev        - Full restart (down + build + up)"
	@echo "  make dev-up     - Quick restart (down + up, no build)"
	@echo "  make dev-build  - Build only (no down, just build + up)"
	@echo "  make dev-down   - Stop DEV"
	@echo ""
	@echo "TEST Commands:"
	@echo "  make test       - Full restart (down + build + up)"
	@echo "  make test-up    - Quick restart (down + up, no build)"
	@echo "  make test-build - Build only (no down, just build + up)"
	@echo "  make test-down  - Stop TEST"
	@echo ""
	@echo "Utilities:"
	@echo "  make logs       - View DEV logs (follow)"
	@echo "  make test-logs  - View TEST logs (follow)"
	@echo "  make shell      - Enter DEV container"
	@echo "  make ps         - List project containers"
	@echo "  make passwords  - Regenerate passwords"

# ============================================
# DEV Environment
# ============================================

# Full restart: down + build + up (most common)
dev:
	$(DC_DEV) down
	$(DC_DEV) up -d --build

# Quick restart: down + up (no build, fast)
dev-up:
	$(DC_DEV) down
	$(DC_DEV) up -d

# Build only (no down first)
dev-build:
	$(DC_DEV) up -d --build

# Stop only
dev-down:
	$(DC_DEV) down

down: dev-down

logs:
	$(DC_DEV) logs -f

shell:
	@CONTAINER=$$($(DC_DEV) ps -q | head -1) && \
	if [ -n "$$CONTAINER" ]; then \
		sudo docker exec -it $$CONTAINER bash; \
	else \
		echo "No DEV container running. Run 'make dev' first."; \
	fi

# ============================================
# TEST Environment
# ============================================

# Full restart: down + build + up
test:
	$(DC_TEST) down
	$(DC_TEST) up -d --build

# Quick restart: down + up (no build)
test-up:
	$(DC_TEST) down
	$(DC_TEST) up -d

# Build only
test-build:
	$(DC_TEST) up -d --build

test-down:
	$(DC_TEST) down

test-logs:
	$(DC_TEST) logs -f

# ============================================
# Utilities
# ============================================

ps:
	sudo docker ps --filter "name=$$(basename $$(pwd))"

passwords:
	./generate-passwords.sh

sync-claude:
	./sync_claude_agents_skills.sh
