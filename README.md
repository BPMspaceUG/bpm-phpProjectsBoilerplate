# bpm-phpProjectsBoilerplate

**Template Repository for PHP/Apache/Redis/MariaDB Projects with FlightPHP**

Uses **Alpine Linux** for minimal image size (~100MB vs ~500MB).

---

## Installation

### Into existing Git repo (uses folder name as project name)

```bash
cd my-project-folder
curl -fsSL https://raw.githubusercontent.com/BPMspaceUG/bpm-phpProjectsBoilerplate/main/install.sh | bash
```

### Into existing Git repo WITH FlightPHP Skeleton

```bash
cd my-project-folder
curl -fsSL https://raw.githubusercontent.com/BPMspaceUG/bpm-phpProjectsBoilerplate/main/install.sh | bash -s -- --skeleton
```

### Create new project

```bash
curl -fsSL https://raw.githubusercontent.com/BPMspaceUG/bpm-phpProjectsBoilerplate/main/install.sh | bash -s -- bpm-MyProject
```

### Create new project WITH FlightPHP Skeleton

```bash
curl -fsSL https://raw.githubusercontent.com/BPMspaceUG/bpm-phpProjectsBoilerplate/main/install.sh | bash -s -- bpm-MyProject --skeleton
```

### After Installation

```bash
# Start DEV environment
sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml up -d --build

# Create GitHub repo (optional)
gh repo create bpm-MyProject --private --source=. --remote=origin
git push -u origin master
```

> **Note:** Docker Compose requires `--env-file .env.DEV` to substitute `${PROJECT_NAME}` variables in the compose file. Without it, you'll get warnings about missing variables.

---

## Options

| Option | Description |
|--------|-------------|
| `--skeleton` or `-s` | Install FlightPHP Skeleton automatically |
| `<project-name>` | Set project name (optional in existing repo) |

---

## What's Included

### Services (Docker)
- **PHP/Apache** (Alpine) - Main application
- **MariaDB** (latest) - Database
- **Redis Stack** - Caching
- **phpMyAdmin** - Database admin UI
- **phpRedisAdmin** - Redis admin UI

### Scripts
- `install.sh` - One-line installer (curl)
- `init-new-project.sh` - Local project creation
- `integrate-flightphp-skeleton.sh` - Add FlightPHP
- `generate-passwords.sh` - Secure password generation
- `sync_claude_agents_skills.sh` - Update Claude AI agents/skills
- `Makefile` - Simplified docker commands (`make dev`, `make logs`, etc.)

### Claude AI Agents (.claude/agents/)
- `orchestrator.md` - Tech lead, task coordination, review gates
- `backend-architect.md` - FlightPHP architecture, API contracts
- `backend-developer.md` - PHP implementation, endpoints
- `frontend-expert.md` - Latte (deep) + DataTables (MANDATORY)
- `data-cache-engineer.md` - MariaDB + Redis specialist
- `devops-container.md` - Docker, Apache, Caddy
- `qa-security-reviewer.md` - Testing, security, release gate (HARD STOP authority)

### Claude AI Skills (.claude/skills/)
- `php-standards/` - PHP coding standards
- `testing-standards/` - Test guidelines
- `database-patterns/` - Query optimization
- `frontend-standards/` - UI/UX standards

### Configuration
- `.env.*.template` - Environment templates
- Fully parameterized with `${PROJECT_NAME}`
- Auto-generated secure passwords
- MYSQL_DATABASE/USER set to project name

---

## Technology Stack

| Component | Technology |
|-----------|------------|
| Framework | FlightPHP v3 |
| Templates | Latte (recommended) |
| Tables | DataTables (MANDATORY) |
| Database | MariaDB |
| Cache | Redis |
| Server | Apache (Alpine) |
| Container | Docker |
| Reverse Proxy | Caddy |

---

## URLs after Start

| Service | DEV | TEST |
|---------|-----|------|
| App | `${PROJECT_NAME}.dev.bpmspace.net` | `${PROJECT_NAME}.test.bpmspace.net` |
| phpMyAdmin | `pma-${PROJECT_NAME}.dev.bpmspace.net` | `pma-${PROJECT_NAME}.test.bpmspace.net` |
| Redis Admin | `pmr-${PROJECT_NAME}.dev.bpmspace.net` | `pmr-${PROJECT_NAME}.test.bpmspace.net` |

---

## Documentation Links

- **FlightPHP**: https://docs.flightphp.com/en/v3/
- **FlightPHP Skeleton**: https://github.com/flightphp/skeleton
- **FlightPHP Plugins**: https://docs.flightphp.com/en/v3/awesome-plugins
- **DataTables**: https://datatables.net
- **Latte Templates**: https://latte.nette.org/

---

## Directory Structure

```
project/
├── Dockerfile.Apache.DEV
├── Dockerfile.Apache.TEST.PROD
├── docker-compose.DEV.yml
├── docker-compose.TEST.yml
├── .env.DEV                    # Auto-generated passwords
├── .env.TEST                   # Auto-generated passwords
├── Makefile                    # Easy: make dev, make logs, etc.
├── generate-passwords.sh
├── integrate-flightphp-skeleton.sh
├── sync_claude_agents_skills.sh
├── IMPORTANT-PROJECT-STRUCTURE.md
├── TECHNOLOGY-STANDARDS.md
├── .claude/
│   ├── agents/                 # AI specialists (7 agents)
│   │   ├── orchestrator.md
│   │   ├── backend-architect.md
│   │   ├── backend-developer.md
│   │   ├── frontend-expert.md
│   │   ├── data-cache-engineer.md
│   │   ├── devops-container.md
│   │   └── qa-security-reviewer.md
│   └── skills/                 # Coding standards
│       ├── php-standards/
│       ├── testing-standards/
│       ├── database-patterns/
│       └── frontend-standards/
├── www/                        # Application code
│   ├── public/                 # Webroot
│   │   └── index.php
│   ├── app/                    # FlightPHP (if --skeleton)
│   └── composer.json
└── scripts/
    ├── cont_*.sh               # Run inside container
    └── ext_*.sh                # Run on host
```

---

## Quick Commands (Makefile)

| DEV | TEST | Description |
|-----|------|-------------|
| `make dev` | `make test` | Full restart (down + build + up) |
| `make dev-up` | `make test-up` | Quick restart (down + up, no build) |
| `make dev-build` | `make test-build` | Build only (no down) |
| `make dev-down` | `make test-down` | Stop environment |
| `make logs` | `make test-logs` | View logs (follow) |

**Utilities:**
| Command | Description |
|---------|-------------|
| `make shell` | Enter DEV container |
| `make ps` | List project containers |
| `make passwords` | Regenerate passwords |
| `make sync-claude` | Update Claude agents/skills |

<details>
<summary>Full Docker Commands (without Makefile)</summary>

```bash
# DEV
sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml up -d --build
sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml logs -f
sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml down

# TEST
sudo docker compose --env-file .env.TEST -f docker-compose.TEST.yml up -d --build

# Enter container
docker exec -it ${PROJECT_NAME}_DEV bash
```

> **Note:** `--env-file` is required to substitute `${PROJECT_NAME}` variables.

</details>
