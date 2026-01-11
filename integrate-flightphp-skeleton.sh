#!/bin/bash
# ============================================
# Integrate FlightPHP Skeleton
# ============================================
# Downloads FlightPHP skeleton and integrates
# it into the www/ directory
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Integrating FlightPHP Skeleton${NC}"
echo ""

# Check if www directory exists
if [ ! -d "www" ]; then
    mkdir -p www
fi

# Check if www already has content
if [ -f "www/composer.json" ]; then
    echo -e "${YELLOW}⚠️  Warning: www/composer.json already exists!${NC}"
    read -p "Overwrite? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "Aborted."
        exit 0
    fi
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
echo "📥 Downloading FlightPHP skeleton..."

# Clone FlightPHP skeleton
git clone --depth 1 https://github.com/flightphp/skeleton.git "$TEMP_DIR/skeleton" 2>/dev/null

# Copy relevant files to www/
echo "📋 Copying files to www/..."

# Copy main files
cp -r "$TEMP_DIR/skeleton/app" www/ 2>/dev/null || true
cp -r "$TEMP_DIR/skeleton/public" www/ 2>/dev/null || true
cp "$TEMP_DIR/skeleton/composer.json" www/ 2>/dev/null || true
cp "$TEMP_DIR/skeleton/runway" www/ 2>/dev/null || true
cp "$TEMP_DIR/skeleton/.htaccess" www/public/ 2>/dev/null || true

# Don't copy docker-compose.yml (we have our own!)
# Don't copy Dockerfile (we have our own!)

# Cleanup
rm -rf "$TEMP_DIR"

# Update composer.json to add recommended packages
echo "📦 Updating composer.json with recommended packages..."

cd www

# Check if composer.json exists
if [ -f "composer.json" ]; then
    # Add recommended packages using composer
    echo ""
    echo -e "${CYAN}Installing FlightPHP core packages...${NC}"

    # Check if composer is available
    if command -v composer &> /dev/null; then
        composer require flightphp/core --no-interaction 2>/dev/null || true
        composer require latte/latte --no-interaction 2>/dev/null || true

        echo ""
        echo -e "${CYAN}Installing recommended plugins...${NC}"
        echo -e "${YELLOW}(If running in container, run these manually after startup)${NC}"

        # These might fail if running outside container
        composer require flightphp/permissions --no-interaction 2>/dev/null || echo "Note: flightphp/permissions - install manually in container"
    else
        echo -e "${YELLOW}Composer not found locally. Install packages in container:${NC}"
        echo "  docker exec -it <container_name> bash"
        echo "  cd /var/www/html && composer install"
    fi
fi

cd ..

echo ""
echo -e "${GREEN}✅ FlightPHP skeleton integrated!${NC}"
echo ""
echo "📁 Structure created:"
echo "  www/"
echo "  ├── app/"
echo "  │   ├── config/"
echo "  │   ├── controllers/"
echo "  │   ├── middlewares/"
echo "  │   └── views/"
echo "  ├── public/"
echo "  │   └── index.php  (webroot)"
echo "  ├── composer.json"
echo "  └── runway"
echo ""
echo -e "${CYAN}📚 Documentation:${NC}"
echo "  FlightPHP Docs: https://docs.flightphp.com/en/v3/"
echo "  Skeleton: https://github.com/flightphp/skeleton"
echo "  Plugins: https://docs.flightphp.com/en/v3/awesome-plugins"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT REMINDERS:${NC}"
echo "  1. Use Latte for templates (NOT flightphp/core View)"
echo "  2. Use DataTables for ALL tables: https://datatables.net"
echo "  3. See TECHNOLOGY-STANDARDS.md for coding standards"
echo ""
echo "Next steps:"
echo "  1. Start container: make dev"
echo "  2. Install dependencies in container:"
echo "     make shell"
echo "     composer install"
echo ""
