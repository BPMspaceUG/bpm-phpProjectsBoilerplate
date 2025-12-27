#!/bin/bash
# ============================================
# Sync Claude Agents and Skills
# ============================================
# Downloads/updates .claude/agents and .claude/skills
# from the boilerplate repository
# ============================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

RAW_URL="https://raw.githubusercontent.com/BPMspaceUG/bpm-phpProjectsBoilerplate/main"

echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  Syncing Claude Agents & Skills${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# Create directories
mkdir -p .claude/agents
mkdir -p .claude/skills/php-standards
mkdir -p .claude/skills/testing-standards
mkdir -p .claude/skills/database-patterns
mkdir -p .claude/skills/frontend-standards

# Download Agents
echo -e "${CYAN}Downloading agents...${NC}"

AGENTS=(
    "php-specialist"
    "test-specialist"
    "frontend-developer"
    "database-specialist"
    "latte-specialist"
    "code-reviewer"
)

for agent in "${AGENTS[@]}"; do
    echo "  - $agent.md"
    curl -fsSL "$RAW_URL/.claude/agents/$agent.md" -o ".claude/agents/$agent.md"
done

# Download Skills
echo ""
echo -e "${CYAN}Downloading skills...${NC}"

SKILLS=(
    "php-standards"
    "testing-standards"
    "database-patterns"
    "frontend-standards"
)

for skill in "${SKILLS[@]}"; do
    echo "  - $skill/SKILL.md"
    curl -fsSL "$RAW_URL/.claude/skills/$skill/SKILL.md" -o ".claude/skills/$skill/SKILL.md"
done

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Sync complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${CYAN}Agents installed:${NC}"
for agent in "${AGENTS[@]}"; do
    echo "  - .claude/agents/$agent.md"
done
echo ""
echo -e "${CYAN}Skills installed:${NC}"
for skill in "${SKILLS[@]}"; do
    echo "  - .claude/skills/$skill/SKILL.md"
done
echo ""
echo -e "${YELLOW}Usage:${NC}"
echo "  Agents are auto-invoked by Claude based on task context"
echo "  Skills provide guidance when Claude detects relevant work"
echo ""
echo -e "${YELLOW}Re-sync anytime:${NC}"
echo "  ./sync_claude_agents_skills.sh"
echo ""
