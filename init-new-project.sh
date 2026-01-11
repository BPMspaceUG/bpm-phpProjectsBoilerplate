#!/bin/bash
# ============================================
# Initialize New Project from Boilerplate
# ============================================
# This script is run FROM the boilerplate repo
# to create a NEW project in a separate directory
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if project name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Please provide a project name!${NC}"
    echo ""
    echo "Usage: ./init-new-project.sh <project-name>"
    echo "Example: ./init-new-project.sh bpm-MyAwesomeProject"
    exit 1
fi

PROJECT_NAME=$1
TARGET_DIR="../$PROJECT_NAME"

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Creating new project: $PROJECT_NAME${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

# Check if target directory already exists
if [ -d "$TARGET_DIR" ]; then
    echo -e "${RED}Error: Directory $TARGET_DIR already exists!${NC}"
    exit 1
fi

# Create target directory
echo "Creating project directory..."
mkdir -p "$TARGET_DIR"

# Copy all files (excluding .git)
echo "Copying boilerplate files..."
cp -r Dockerfile.Apache.DEV "$TARGET_DIR/"
cp -r Dockerfile.Apache.TEST.PROD "$TARGET_DIR/"
cp -r docker-compose.DEV.yml "$TARGET_DIR/"
cp -r docker-compose.TEST.yml "$TARGET_DIR/"
cp -r .env.DEV.template "$TARGET_DIR/"
cp -r .env.TEST.template "$TARGET_DIR/"
cp -r .env.PROD.template "$TARGET_DIR/"
cp -r .gitignore "$TARGET_DIR/"
cp -r integrate-flightphp-skeleton.sh "$TARGET_DIR/"
cp -r generate-passwords.sh "$TARGET_DIR/"
cp -r sync-claude-agents-skills.sh "$TARGET_DIR/"
cp -r Makefile "$TARGET_DIR/"
cp -r IMPORTANT-PROJECT-STRUCTURE.md "$TARGET_DIR/"
cp -r TECHNOLOGY-STANDARDS.md "$TARGET_DIR/"

# Copy directories if they exist
if [ -d "www" ]; then
    cp -r www "$TARGET_DIR/"
fi
if [ -d "scripts" ]; then
    cp -r scripts "$TARGET_DIR/"
fi
if [ -d ".claude" ]; then
    cp -r .claude "$TARGET_DIR/"
fi

# Create directories if they don't exist
mkdir -p "$TARGET_DIR/www/public"
mkdir -p "$TARGET_DIR/scripts"

# Create .env files from templates and set PROJECT_NAME
echo "Configuring environment files..."
cp "$TARGET_DIR/.env.DEV.template" "$TARGET_DIR/.env.DEV"
cp "$TARGET_DIR/.env.TEST.template" "$TARGET_DIR/.env.TEST"

# Replace PROJECT_NAME in .env files
sed -i "s/PROJECT_NAME=bpm-MyNewProject/PROJECT_NAME=$PROJECT_NAME/g" "$TARGET_DIR/.env.DEV"
sed -i "s/PROJECT_NAME=bpm-MyNewProject/PROJECT_NAME=$PROJECT_NAME/g" "$TARGET_DIR/.env.TEST"

# Set PROJECT_NAME_LOWER (Docker requires lowercase image names)
PROJECT_NAME_LOWER=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]')
sed -i "s/PROJECT_NAME_LOWER=bpm-mynewproject/PROJECT_NAME_LOWER=$PROJECT_NAME_LOWER/g" "$TARGET_DIR/.env.DEV"
sed -i "s/PROJECT_NAME_LOWER=bpm-mynewproject/PROJECT_NAME_LOWER=$PROJECT_NAME_LOWER/g" "$TARGET_DIR/.env.TEST"

# Extract app name from project name (remove bpm- prefix if present)
APP_NAME=$(echo "$PROJECT_NAME" | sed 's/^bpm-//')
sed -i "s/APP_NAME=MyNewProject/APP_NAME=$APP_NAME/g" "$TARGET_DIR/.env.DEV"
sed -i "s/APP_NAME=MyNewProject/APP_NAME=$APP_NAME/g" "$TARGET_DIR/.env.TEST"

# Create README for the new project
cat > "$TARGET_DIR/README.md" << EOF
# $PROJECT_NAME

Created from bpm-phpProjectsBoilerplate

## Quick Start

\`\`\`bash
# Integrate FlightPHP (optional but recommended)
./integrate-flightphp-skeleton.sh

# Start DEV environment
make dev
\`\`\`

## URLs

- App: https://$PROJECT_NAME.dev.bpmspace.net
- phpMyAdmin: https://pma-$PROJECT_NAME.dev.bpmspace.net
- Redis Admin: https://pmr-$PROJECT_NAME.dev.bpmspace.net

## Documentation

- See \`IMPORTANT-PROJECT-STRUCTURE.md\` for project structure
- See \`TECHNOLOGY-STANDARDS.md\` for coding standards
EOF

# Generate secure passwords
echo ""
echo -e "${CYAN}Generating secure passwords...${NC}"
cd "$TARGET_DIR"
./generate-passwords.sh

# Initialize new git repository
echo ""
echo "Initializing git repository..."
git init
git add .
git commit -m "Initial commit from bpm-phpProjectsBoilerplate

Generated with Claude Code"

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Project $PROJECT_NAME created!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "Location: $TARGET_DIR"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. cd $TARGET_DIR"
echo "  2. ./integrate-flightphp-skeleton.sh  # Optional: Add FlightPHP"
echo "  3. make dev  # or: sudo docker compose --env-file .env.DEV -f docker-compose.DEV.yml up -d --build"
echo ""
echo "  4. Create GitHub repo:"
echo "     gh repo create $PROJECT_NAME --private --source=. --remote=origin"
echo "     git push -u origin main"
echo ""
echo -e "${CYAN}URLs after start:${NC}"
echo "  App:        https://$PROJECT_NAME.dev.bpmspace.net"
echo "  phpMyAdmin: https://pma-$PROJECT_NAME.dev.bpmspace.net"
echo "  Redis:      https://pmr-$PROJECT_NAME.dev.bpmspace.net"
echo ""
