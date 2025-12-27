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
	sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml down
	sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml up -d --build

# Quick restart: down + up (no build, fast)
dev-up:
	sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml down
	sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml up -d

# Build only (no down first)
dev-build:
	sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml up -d --build

# Stop only
dev-down:
	sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml down

down: dev-down

logs:
	sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml logs -f

shell:
	@CONTAINER=$$(sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml ps -q | head -1) && \
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
	sudo docker compose --env-file .env.TEST -f docker-compose.TEST.yml down
	sudo docker compose --env-file .env.TEST -f docker-compose.TEST.yml up -d --build

# Quick restart: down + up (no build)
test-up:
	sudo docker compose --env-file .env.TEST -f docker-compose.TEST.yml down
	sudo docker compose --env-file .env.TEST -f docker-compose.TEST.yml up -d

# Build only
test-build:
	sudo docker compose --env-file .env.TEST -f docker-compose.TEST.yml up -d --build

test-down:
	sudo docker compose --env-file .env.TEST -f docker-compose.TEST.yml down

test-logs:
	sudo docker compose --env-file .env.TEST -f docker-compose.TEST.yml logs -f

# ============================================
# Utilities
# ============================================

ps:
	sudo docker ps --filter "name=$$(basename $$(pwd))"

passwords:
	./generate-passwords.sh

sync-claude:
	./sync_claude_agents_skills.sh
