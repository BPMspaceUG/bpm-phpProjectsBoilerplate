#!/bin/bash
# ============================================
# Generate secure passwords for .env files
# ============================================
# Generates random passwords and updates
# .env.DEV and .env.TEST files
# ============================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Generate random password (32 chars, alphanumeric)
generate_password() {
    tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32
}

echo -e "${CYAN}Generating secure passwords...${NC}"

# Generate passwords
MYSQL_ROOT_PASS=$(generate_password)
MYSQL_PASS=$(generate_password)
REDIS_ADMIN_PASS=$(generate_password)
APP_ADMIN_PASS=$(generate_password)
API_KEY=$(generate_password)

# Function to update passwords in .env file
update_env_file() {
    local ENV_FILE=$1
    local PROJECT_NAME=$2

    if [ ! -f "$ENV_FILE" ]; then
        echo -e "${YELLOW}Warning: $ENV_FILE not found, skipping${NC}"
        return
    fi

    echo -e "  Updating $ENV_FILE..."

    # Update MySQL passwords
    sed -i "s/MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASS/" "$ENV_FILE"
    sed -i "s/MYSQL_PASSWORD=.*/MYSQL_PASSWORD=$MYSQL_PASS/" "$ENV_FILE"

    # Update Redis admin password
    sed -i "s/REDIS_ADMIN_PASS=.*/REDIS_ADMIN_PASS=$REDIS_ADMIN_PASS/" "$ENV_FILE"

    # Update App admin password and API key
    sed -i "s/APP_ADMIN_PASS=.*/APP_ADMIN_PASS=$APP_ADMIN_PASS/" "$ENV_FILE"
    sed -i "s/API_KEY=.*/API_KEY=$API_KEY/" "$ENV_FILE"

    # Update MYSQL_DATABASE and MYSQL_USER to PROJECT_NAME (without bpm- prefix, lowercase)
    if [ -n "$PROJECT_NAME" ]; then
        # Remove bpm- prefix and convert to lowercase for DB name
        DB_NAME=$(echo "$PROJECT_NAME" | sed 's/^bpm-//' | tr '[:upper:]' '[:lower:]' | tr '-' '_')
        sed -i "s/MYSQL_DATABASE=.*/MYSQL_DATABASE=$DB_NAME/" "$ENV_FILE"
        sed -i "s/MYSQL_USER=.*/MYSQL_USER=$DB_NAME/" "$ENV_FILE"
    fi
}

# Get PROJECT_NAME from .env.DEV if exists
PROJECT_NAME=""
if [ -f ".env.DEV" ]; then
    PROJECT_NAME=$(grep "^PROJECT_NAME=" .env.DEV | cut -d'=' -f2)
elif [ -f ".env.TEST" ]; then
    PROJECT_NAME=$(grep "^PROJECT_NAME=" .env.TEST | cut -d'=' -f2)
fi

# Update both files
update_env_file ".env.DEV" "$PROJECT_NAME"
update_env_file ".env.TEST" "$PROJECT_NAME"

echo ""
echo -e "${GREEN}✅ Passwords generated successfully!${NC}"
echo ""
echo -e "${YELLOW}Generated credentials (save these somewhere safe!):${NC}"
echo ""
echo -e "  ${CYAN}MySQL Root Password:${NC} $MYSQL_ROOT_PASS"
echo -e "  ${CYAN}MySQL User Password:${NC} $MYSQL_PASS"
echo -e "  ${CYAN}Redis Admin Password:${NC} $REDIS_ADMIN_PASS"
echo -e "  ${CYAN}App Admin User:${NC} admin"
echo -e "  ${CYAN}App Admin Password:${NC} $APP_ADMIN_PASS"
echo -e "  ${CYAN}API Key:${NC} $API_KEY"
if [ -n "$PROJECT_NAME" ]; then
    DB_NAME=$(echo "$PROJECT_NAME" | sed 's/^bpm-//' | tr '[:upper:]' '[:lower:]' | tr '-' '_')
    echo -e "  ${CYAN}MySQL Database/User:${NC} $DB_NAME"
fi
echo ""
echo -e "${YELLOW}Note: Same passwords are used for DEV and TEST for convenience.${NC}"
echo -e "${YELLOW}      Change them individually if needed for security.${NC}"
echo ""
