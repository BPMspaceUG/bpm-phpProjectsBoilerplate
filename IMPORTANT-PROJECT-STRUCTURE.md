# IMPORTANT: Project Structure for AI Agents

## Overview
This project uses a **Dual-Environment Architecture** with separate Docker setups for DEV and TEST. Both environments can run **in parallel on the same server**.

**This document complements GLOBAL_INSTRUCTION_SYSTEM_RULES_ALL_PROJECTS.md**

---

## Technology Stack & Documentation

### Core Framework
- **FlightPHP v3**: https://docs.flightphp.com/en/v3/
- **FlightPHP Skeleton**: https://github.com/flightphp/skeleton
- **Awesome Plugins**: https://docs.flightphp.com/en/v3/awesome-plugins

### Required Plugins
- **Async**: https://docs.flightphp.com/en/v3/awesome-plugins/async
- **Permissions**: https://docs.flightphp.com/en/v3/awesome-plugins/permissions

### MANDATORY: DataTables
- **ALL tables MUST use DataTables**: https://datatables.net
- NO plain HTML tables allowed!

### Template Engine
- **DEPRECATED**: flightphp/core View (not recommended for projects with more than a couple pages)
- **RECOMMENDED**: Latte (latte/latte) - Full featured, PHP-like syntax, easy to extend
- **ALTERNATIVE**: CommentTemplate (knifelemon/comment-template) - Asset compilation, template inheritance

---

## Directory Structure

```
project-root/
├── Dockerfile.Apache.DEV           # Development Dockerfile (full tools)
├── Dockerfile.Apache.TEST.PROD     # TEST/PROD Dockerfile (minimal, baked-in code)
├── docker-compose.DEV.yml          # DEV compose (with volume mounts)
├── docker-compose.TEST.yml         # TEST compose (no mounts, code baked in)
├── .env.DEV                        # DEV environment (NEVER commit!)
├── .env.TEST                       # TEST environment (NEVER commit!)
├── .env.DEV.template               # Template for DEV env
├── .env.TEST.template              # Template for TEST env
├── .gitignore
├── IMPORTANT-PROJECT-STRUCTURE.md  # This file (for AI agents)
├── TECHNOLOGY-STANDARDS.md         # Coding standards
├── www/                            # Application code (mounted in DEV)
│   ├── public/                     # Webroot (Apache DocumentRoot)
│   │   └── index.php
│   ├── app/                        # FlightPHP application
│   │   ├── config/
│   │   ├── controllers/
│   │   ├── middlewares/
│   │   └── views/
│   ├── composer.json
│   └── vendor/                     # Dependencies (gitignored)
└── scripts/                        # Bash scripts (mounted in DEV)
    ├── cont_*.sh                   # Scripts that run INSIDE container
    └── ext_*.sh                    # Scripts that run on HOST
```

---

## Environment Differences

| Aspect | DEV | TEST |
|--------|-----|------|
| Dockerfile | Dockerfile.Apache.DEV | Dockerfile.Apache.TEST.PROD |
| Code | Volume mounted (live edit) | Baked into image |
| Dev Tools | vim, nano, jq, git, etc. | Minimal |
| Domain | *.dev.bpmspace.net | *.test.bpmspace.net |
| Container Suffix | _dev | _test |
| Network Suffix | _dev | _test |

---

## Critical Rules

### Script Naming Convention
- `cont_*.sh` - Runs INSIDE container (e.g., cont_install_deps.sh)
- `ext_*.sh` - Runs on HOST system (e.g., ext_deploy.sh)

### Mount Rules
- Only mount `./www` and `./scripts` folders
- NEVER mount repository root into container

### Sudo Policy
1. Try command WITHOUT sudo first
2. If permission denied, IMMEDIATELY retry WITH sudo
3. No questions asked

### Change Policy
- NO version zoo! (*_v2.sh, *_backup.sh, etc.)
- MODIFY existing files directly
- NO backup copies in working directory

### Test Scripts
- Use `.test.sh` suffix for test scripts
- Must be idempotent and non-destructive

### Ownership
- DEV: ubuntu:ubuntu (for easy editing)
- TEST/PROD: www-data:www-data (security)

---

## Deployment Commands

### DEV Environment
```bash
# Copy and configure environment
cp .env.DEV.template .env.DEV
nano .env.DEV  # Set passwords

# Start
sudo docker compose -f docker-compose.DEV.yml up -d --build

# View logs
sudo docker compose -f docker-compose.DEV.yml logs -f
```

### TEST Environment
```bash
# Copy and configure environment
cp .env.TEST.template .env.TEST
nano .env.TEST  # Set passwords

# Build and start (code is baked in!)
sudo docker compose -f docker-compose.TEST.yml up -d --build
```

---

## URLs

- DEV App: https://${PROJECT_NAME}.dev.bpmspace.net
- DEV Redis Admin: https://pmr-${PROJECT_NAME}.dev.bpmspace.net
- TEST App: https://${PROJECT_NAME}.test.bpmspace.net
- TEST Redis Admin: https://pmr-${PROJECT_NAME}.test.bpmspace.net

---

## GitHub Issue Template

All changes MUST follow this template:
```markdown
**Betreff:** [Komponente] Kurze Beschreibung

**Aktuelle Situation:** Was ist der aktuelle Zustand?

**Gewünschte Änderung:** Was soll geändert werden?

**Betroffene Dateien:**
- path/to/file1.php
- path/to/file2.php

**Akzeptanzkriterien:**
- [ ] Kriterium 1
- [ ] Kriterium 2
```
