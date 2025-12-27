#!/bin/bash
# ============================================
# Install bpm-phpProjectsBoilerplate
# ============================================
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/BPMspaceUG/bpm-phpProjectsBoilerplate/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/BPMspaceUG/bpm-phpProjectsBoilerplate/main/install.sh | bash -s -- --skeleton
#   curl -fsSL https://raw.githubusercontent.com/BPMspaceUG/bpm-phpProjectsBoilerplate/main/install.sh | bash -s -- MyProjectName
#   curl -fsSL https://raw.githubusercontent.com/BPMspaceUG/bpm-phpProjectsBoilerplate/main/install.sh | bash -s -- MyProjectName --skeleton
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

RAW_URL="https://raw.githubusercontent.com/BPMspaceUG/bpm-phpProjectsBoilerplate/main"

# Parse arguments
PROJECT_NAME=""
INSTALL_SKELETON=false

for arg in "$@"; do
    case $arg in
        --skeleton|-s)
            INSTALL_SKELETON=true
            ;;
        *)
            if [ -z "$PROJECT_NAME" ]; then
                PROJECT_NAME="$arg"
            fi
            ;;
    esac
done

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  bpm-phpProjectsBoilerplate Installer${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

# Detect if we're in a git repo
if [ -d ".git" ]; then
    echo -e "${CYAN}Detected existing git repository${NC}"
    INSTALL_MODE="existing"

    # Use folder name as PROJECT_NAME if not provided
    if [ -z "$PROJECT_NAME" ]; then
        PROJECT_NAME=$(basename "$(pwd)")
        echo -e "Using folder name as project: ${YELLOW}$PROJECT_NAME${NC}"
    fi
else
    echo -e "${CYAN}No git repository detected - creating new project${NC}"
    INSTALL_MODE="new"

    if [ -z "$PROJECT_NAME" ]; then
        echo -e "${RED}Error: Please provide a project name!${NC}"
        echo ""
        echo "Usage:"
        echo "  curl -fsSL $RAW_URL/install.sh | bash -s -- MyProjectName"
        echo "  curl -fsSL $RAW_URL/install.sh | bash -s -- MyProjectName --skeleton"
        exit 1
    fi
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    git init
fi

echo -e "Project name: ${YELLOW}$PROJECT_NAME${NC}"
echo -e "Install FlightPHP Skeleton: ${YELLOW}$INSTALL_SKELETON${NC}"
echo ""

# Download files
echo -e "${CYAN}Downloading boilerplate files...${NC}"

# Create directories
mkdir -p www/public scripts

# Download Docker files
curl -fsSL "$RAW_URL/Dockerfile.Apache.DEV" -o Dockerfile.Apache.DEV
curl -fsSL "$RAW_URL/Dockerfile.Apache.TEST.PROD" -o Dockerfile.Apache.TEST.PROD
curl -fsSL "$RAW_URL/docker-compose.DEV.yml" -o docker-compose.DEV.yml
curl -fsSL "$RAW_URL/docker-compose.TEST.yml" -o docker-compose.TEST.yml

# Download env templates
curl -fsSL "$RAW_URL/.env.DEV.template" -o .env.DEV.template
curl -fsSL "$RAW_URL/.env.TEST.template" -o .env.TEST.template
curl -fsSL "$RAW_URL/.env.PROD.template" -o .env.PROD.template

# Download scripts
curl -fsSL "$RAW_URL/integrate-flightphp-skeleton.sh" -o integrate-flightphp-skeleton.sh
curl -fsSL "$RAW_URL/generate-passwords.sh" -o generate-passwords.sh
chmod +x integrate-flightphp-skeleton.sh generate-passwords.sh

# Download documentation
curl -fsSL "$RAW_URL/IMPORTANT-PROJECT-STRUCTURE.md" -o IMPORTANT-PROJECT-STRUCTURE.md
curl -fsSL "$RAW_URL/TECHNOLOGY-STANDARDS.md" -o TECHNOLOGY-STANDARDS.md

# Download gitignore (append if exists)
if [ -f ".gitignore" ]; then
    echo "" >> .gitignore
    echo "# === bpm-phpProjectsBoilerplate ===" >> .gitignore
    curl -fsSL "$RAW_URL/.gitignore" >> .gitignore
else
    curl -fsSL "$RAW_URL/.gitignore" -o .gitignore
fi

# Download placeholder files if directories are empty
if [ ! -f "www/public/index.php" ]; then
    curl -fsSL "$RAW_URL/www/public/index.php" -o www/public/index.php
fi
if [ ! -f "scripts/README.md" ]; then
    curl -fsSL "$RAW_URL/scripts/README.md" -o scripts/README.md
fi

# Create .env files from templates
echo -e "${CYAN}Creating environment files...${NC}"
cp .env.DEV.template .env.DEV
cp .env.TEST.template .env.TEST

# Set PROJECT_NAME in .env files
sed -i "s/PROJECT_NAME=bpm-MyNewProject/PROJECT_NAME=$PROJECT_NAME/g" .env.DEV
sed -i "s/PROJECT_NAME=bpm-MyNewProject/PROJECT_NAME=$PROJECT_NAME/g" .env.TEST

# Set APP_NAME (remove bpm- prefix)
APP_NAME=$(echo "$PROJECT_NAME" | sed 's/^bpm-//')
sed -i "s/APP_NAME=MyNewProject/APP_NAME=$APP_NAME/g" .env.DEV
sed -i "s/APP_NAME=MyNewProject/APP_NAME=$APP_NAME/g" .env.TEST

# Create README if doesn't exist
if [ ! -f "README.md" ]; then
    cat > README.md << EOF
# $PROJECT_NAME

Created with bpm-phpProjectsBoilerplate

## Quick Start

\`\`\`bash
# Optional: Add FlightPHP (if not installed with --skeleton)
./integrate-flightphp-skeleton.sh

# Start
sudo docker compose -f docker-compose.DEV.yml up -d --build
\`\`\`

## URLs
- App: https://$PROJECT_NAME.dev.bpmspace.net
- phpMyAdmin: https://pma-$PROJECT_NAME.dev.bpmspace.net
- Redis Admin: https://pmr-$PROJECT_NAME.dev.bpmspace.net
EOF
fi

# Generate secure passwords
echo ""
echo -e "${CYAN}Generating secure passwords...${NC}"
./generate-passwords.sh

# Install FlightPHP Skeleton if requested
if [ "$INSTALL_SKELETON" = true ]; then
    echo ""
    echo -e "${CYAN}Installing FlightPHP Skeleton...${NC}"
    ./integrate-flightphp-skeleton.sh
fi

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Installation complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "Project: ${YELLOW}$PROJECT_NAME${NC}"
echo ""
echo -e "${CYAN}Files created:${NC}"
echo "  - Dockerfile.Apache.DEV"
echo "  - Dockerfile.Apache.TEST.PROD"
echo "  - docker-compose.DEV.yml"
echo "  - docker-compose.TEST.yml"
echo "  - .env.DEV / .env.TEST (with generated passwords)"
echo "  - integrate-flightphp-skeleton.sh"
echo "  - generate-passwords.sh"
echo "  - IMPORTANT-PROJECT-STRUCTURE.md"
echo "  - TECHNOLOGY-STANDARDS.md"
if [ "$INSTALL_SKELETON" = true ]; then
    echo "  - www/app/ (FlightPHP structure)"
fi
echo ""
echo -e "${YELLOW}Next steps:${NC}"
if [ "$INSTALL_SKELETON" = false ]; then
    echo "  1. ./integrate-flightphp-skeleton.sh  # Optional: Add FlightPHP"
    echo "  2. sudo docker compose -f docker-compose.DEV.yml up -d --build"
else
    echo "  1. sudo docker compose -f docker-compose.DEV.yml up -d --build"
fi
echo ""
echo -e "${CYAN}URLs after start:${NC}"
echo "  App:        https://$PROJECT_NAME.dev.bpmspace.net"
echo "  phpMyAdmin: https://pma-$PROJECT_NAME.dev.bpmspace.net"
echo "  Redis:      https://pmr-$PROJECT_NAME.dev.bpmspace.net"
echo ""
