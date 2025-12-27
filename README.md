# bpm-phpProjectsBoilerplate

**Template Repository for PHP/Apache/Redis Projects with FlightPHP**

Uses **Alpine Linux** for minimal image size (~100MB vs ~500MB).

---

## Installation Methods

### Method 1: One-Line Install (into existing or new repo)

```bash
# Into EXISTING git repo (run from repo root)
curl -fsSL https://raw.githubusercontent.com/BPMspaceUG/bpm-phpProjectsBoilerplate/main/install.sh | bash

# Create NEW project
curl -fsSL https://raw.githubusercontent.com/BPMspaceUG/bpm-phpProjectsBoilerplate/main/install.sh | bash -s -- bpm-MyNewProject
```

### Method 2: Clone and Create Project

```bash
# Clone boilerplate (once)
git clone git@github.com:BPMspaceUG/bpm-phpProjectsBoilerplate.git
cd bpm-phpProjectsBoilerplate

# Create new project
./init-new-project.sh bpm-MyNewProject
cd ../bpm-MyNewProject
```

### After Installation

```bash
# Set passwords
nano .env.DEV

# Optional: Add FlightPHP
./integrate-flightphp-skeleton.sh

# Start
sudo docker compose -f docker-compose.DEV.yml up -d --build

# Create GitHub repo
gh repo create bpm-MyNewProject --private --source=. --remote=origin
git push -u origin master
```

---

## What's Included

### Docker Setup
- `Dockerfile.Apache.DEV` - Full dev tools (vim, nano, jq, git, etc.)
- `Dockerfile.Apache.TEST.PROD` - Minimal, code baked in
- `docker-compose.DEV.yml` - With volume mounts for live editing
- `docker-compose.TEST.yml` - No mounts, for testing

### Services
- **PHP/Apache** - Main application
- **Redis Stack** - Caching and data storage
- **PHPRedisAdmin** - Redis web interface

### Configuration
- `.env.*.template` - Environment templates
- Fully parameterized with `${PROJECT_NAME}`

### Scripts
- `init-new-project.sh` - Create new project from boilerplate
- `integrate-flightphp-skeleton.sh` - Add FlightPHP to project

### Documentation
- `IMPORTANT-PROJECT-STRUCTURE.md` - For AI agents
- `TECHNOLOGY-STANDARDS.md` - Coding standards

---

## Technology Stack

| Component | Technology |
|-----------|------------|
| Framework | FlightPHP v3 |
| Templates | Latte (recommended) |
| Tables | DataTables (MANDATORY) |
| Cache | Redis |
| Server | Apache |
| Container | Docker |
| Reverse Proxy | Caddy |

---

## Documentation Links

- **FlightPHP**: https://docs.flightphp.com/en/v3/
- **FlightPHP Skeleton**: https://github.com/flightphp/skeleton
- **FlightPHP Plugins**: https://docs.flightphp.com/en/v3/awesome-plugins
- **DataTables**: https://datatables.net
- **Latte Templates**: https://latte.nette.org/

---

## Directory Structure (New Project)

```
my-project/
├── Dockerfile.Apache.DEV
├── Dockerfile.Apache.TEST.PROD
├── docker-compose.DEV.yml
├── docker-compose.TEST.yml
├── .env.DEV                    # Created from template
├── .env.TEST                   # Created from template
├── integrate-flightphp-skeleton.sh
├── IMPORTANT-PROJECT-STRUCTURE.md
├── TECHNOLOGY-STANDARDS.md
├── www/                        # Application code
│   ├── public/                 # Webroot
│   │   └── index.php
│   ├── app/                    # FlightPHP app
│   └── composer.json
└── scripts/                    # Bash scripts
    ├── cont_*.sh               # Run inside container
    └── ext_*.sh                # Run on host
```

---

## Quick Commands

```bash
# DEV: Start
sudo docker compose -f docker-compose.DEV.yml up -d --build

# DEV: Logs
sudo docker compose -f docker-compose.DEV.yml logs -f

# DEV: Stop
sudo docker compose -f docker-compose.DEV.yml down

# TEST: Build and start
sudo docker compose -f docker-compose.TEST.yml up -d --build

# Enter container
docker exec -it ${PROJECT_NAME}_DEV bash

# Install composer dependencies
docker exec -it ${PROJECT_NAME}_DEV bash -c 'cd /var/www/html && composer install'
```

---

## License

MIT
