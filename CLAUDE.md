# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

FlightPHP v3 boilerplate for PHP/Apache/Redis/MariaDB projects using Debian-based Docker containers. Features dual-environment architecture (DEV/TEST running in parallel), one-line installation, and integrated Claude AI agent system with 7 specialized roles.

## Development Commands

```bash
# DEV environment (recommended workflow)
make dev              # Full restart: down + build + up
make dev-up           # Quick restart: down + up (no build)
make logs             # View logs (follow mode)
make shell            # Enter container bash
make ps               # List containers

# TEST environment
make test             # Full restart for TEST
make test-logs        # View TEST logs

# Utilities
make passwords        # Regenerate all passwords
make sync-claude      # Update Claude agents/skills from GitHub

# Direct Docker (requires --env-file for variable substitution)
sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml up -d --build
```

## Installation

```bash
# Into existing git repo
curl -fsSL https://raw.githubusercontent.com/BPMspaceUG/bpm-phpProjectsBoilerplate/main/install.sh | bash

# With FlightPHP Skeleton
curl -fsSL ... | bash -s -- --skeleton

# Create new project
curl -fsSL ... | bash -s -- bpm-MyProject
```

## Architecture

### Dual-Environment Docker Setup
- **DEV**: Volume-mounted code (`./www:/var/www/html`), includes dev tools (vim, git, jq), ownership: ubuntu:ubuntu
- **TEST**: Code baked into image, minimal footprint, ownership: www-data:www-data
- Both environments can run in parallel on the same server (different networks/suffixes)

### FlightPHP Structure (when skeleton installed)
```
www/
├── public/index.php          # Single entry point (Apache DocumentRoot)
├── app/
│   ├── config/
│   │   ├── config.php        # Main configuration
│   │   ├── routes.php        # Route definitions
│   │   └── services.php      # Service registration
│   ├── controllers/          # HTTP handlers (THIN)
│   ├── logic/                # Business logic/services (THICK)
│   ├── repositories/         # Database access layer
│   ├── middlewares/          # Request/response middleware
│   └── views/                # Latte templates (REQUIRED)
└── composer.json
```

### Script Naming Convention
```bash
scripts/cont_*.sh   # Runs INSIDE container
scripts/ext_*.sh    # Runs on HOST system
```

## Technology Constraints

### Mandatory
- **FlightPHP v3** with Skeleton structure
- **Latte** for templates (NOT flightphp/core View)
- **DataTables** for ALL tables (no plain HTML tables)
- **Redis** for session/cache
- **PSR-12** coding style with type hints

### Forbidden
- Inline SQL (use prepared statements)
- Hardcoded credentials (use .env files)
- Plain HTML tables (use DataTables)
- flightphp/core View templating
- Version zoo (*_v2.php, *_backup.php)

## Claude Agent System

Located in `.claude/agents/`:

| Agent | Role | Authority |
|-------|------|-----------|
| orchestrator | Task coordination, DoD enforcement | Review gates |
| backend-architect | FlightPHP design (no implementation) | Design only |
| backend-developer | PHP implementation | - |
| frontend-expert | Latte templates, DataTables | - |
| data-cache-engineer | MariaDB, Redis | - |
| devops-container | Docker, Apache, Debian | - |
| qa-security-reviewer | Tests, security | **HARD STOP / VETO** |

Skills in `.claude/skills/`: php-standards, testing-standards, database-patterns, frontend-standards.

## Environment Files

```bash
.env.DEV            # DEV credentials (never commit)
.env.TEST           # TEST credentials (never commit)
.env.DEV.template   # Template for DEV
.env.TEST.template  # Template for TEST
```

Key variables: `PROJECT_NAME`, `PROJECT_NAME_LOWER`, `MYSQL_*`, `REDIS_*`, `APP_ADMIN_*`, `API_KEY`

## URLs (when running)

- App: `https://${PROJECT_NAME}.dev.bpmspace.net`
- phpMyAdmin: `https://pma-${PROJECT_NAME}.dev.bpmspace.net`
- Redis Admin: `https://pmr-${PROJECT_NAME}.dev.bpmspace.net`

Requires Caddy reverse proxy on host with DNS for *.dev.bpmspace.net.

## Key Documentation

- `TECHNOLOGY-STANDARDS.md` - Required technologies and coding standards
- `IMPORTANT-PROJECT-STRUCTURE.md` - Directory structure and environment rules
