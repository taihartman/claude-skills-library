#!/usr/bin/env bash
# update-feature-docs.sh - Manage feature documentation (CHANGELOG.md and CLAUDE.md)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Usage information
usage() {
    echo "Usage: $0 <command> <feature-id> [message]"
    echo ""
    echo "Commands:"
    echo "  log <feature-id> <message>    - Add entry to feature CHANGELOG.md"
    echo "  create <feature-id>            - Create CHANGELOG.md and CLAUDE.md for feature"
    echo "  update <feature-id>            - Update feature CLAUDE.md"
    echo "  complete <feature-id>          - Mark feature complete and roll up to root CHANGELOG"
    echo ""
    echo "Examples:"
    echo "  $0 log 001-plinko-physics \"Implemented peg collision detection\""
    echo "  $0 create 001-plinko-physics"
    echo "  $0 update 001-plinko-physics"
    echo "  $0 complete 001-plinko-physics"
    exit 1
}

# Check arguments
if [ $# -lt 2 ]; then
    usage
fi

COMMAND="$1"
FEATURE_ID="$2"
MESSAGE="${3:-}"

FEATURE_DIR="$PROJECT_ROOT/specs/$FEATURE_ID"
CHANGELOG_FILE="$FEATURE_DIR/CHANGELOG.md"
CLAUDE_FILE="$FEATURE_DIR/CLAUDE.md"
ROOT_CHANGELOG="$PROJECT_ROOT/CHANGELOG.md"

# Ensure feature directory exists
if [ ! -d "$FEATURE_DIR" ]; then
    echo -e "${RED}Error: Feature directory not found: $FEATURE_DIR${NC}"
    exit 1
fi

# Get current timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")
DATE_ONLY=$(date "+%Y-%m-%d")

# Command: log - Add entry to CHANGELOG.md
cmd_log() {
    if [ -z "$MESSAGE" ]; then
        echo -e "${RED}Error: Message required for log command${NC}"
        usage
    fi

    # Create CHANGELOG.md if it doesn't exist
    if [ ! -f "$CHANGELOG_FILE" ]; then
        cmd_create
    fi

    # Check if there's already a section for today
    if ! grep -q "## $DATE_ONLY" "$CHANGELOG_FILE"; then
        # Add new date section after the format section
        awk -v date="## $DATE_ONLY" -v entry="### $TIMESTAMP - $MESSAGE" '
            /^---$/ && !inserted {
                print ""
                print date
                print ""
                print entry
                print ""
                inserted=1
                next
            }
            { print }
        ' "$CHANGELOG_FILE" > "$CHANGELOG_FILE.tmp"
        mv "$CHANGELOG_FILE.tmp" "$CHANGELOG_FILE"
    else
        # Add entry under existing date section
        awk -v date="## $DATE_ONLY" -v entry="### $TIMESTAMP - $MESSAGE" '
            $0 ~ date {
                print
                print ""
                print entry
                printed=1
                next
            }
            { print }
        ' "$CHANGELOG_FILE" > "$CHANGELOG_FILE.tmp"
        mv "$CHANGELOG_FILE.tmp" "$CHANGELOG_FILE"
    fi

    echo -e "${GREEN}✓${NC} Logged to $CHANGELOG_FILE"
    echo -e "  ${YELLOW}[$TIMESTAMP]${NC} $MESSAGE"
}

# Command: create - Initialize CHANGELOG.md and CLAUDE.md
cmd_create() {
    # Create CHANGELOG.md
    if [ ! -f "$CHANGELOG_FILE" ]; then
        cat > "$CHANGELOG_FILE" << EOF
# Feature $FEATURE_ID - Development Changelog

This changelog tracks all development activities for this feature.

## Format
- Each entry includes: \`[YYYY-MM-DD HH:MM]\` timestamp
- Use \`/docs.log "message"\` to add entries automatically
- Entries are chronological (newest at top)

---

## $DATE_ONLY

### $TIMESTAMP - Initialized Feature Documentation
- Created CHANGELOG.md and CLAUDE.md
- Documentation system active for this feature

EOF
        echo -e "${GREEN}✓${NC} Created $CHANGELOG_FILE"
    else
        echo -e "${YELLOW}⚠${NC}  CHANGELOG.md already exists"
    fi

    # Create CLAUDE.md
    if [ ! -f "$CLAUDE_FILE" ]; then
        FEATURE_NAME=$(echo "$FEATURE_ID" | sed 's/^[0-9]*-//' | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')

        cat > "$CLAUDE_FILE" << EOF
# Feature $FEATURE_ID: $FEATURE_NAME

**Status**: 🟡 In Progress
**Started**: $DATE_ONLY

## Overview

Brief description of this feature.

## Important Files

### Created
- \`path/to/new/file.gd\` - Description

### Modified
- \`path/to/modified/file.gd\` - What changed

## Architecture

### Resources
- Resource files used by this feature

### Scenes
- Scene files created/modified

### Scripts
- Script files and their purpose

## Dependencies

- Any new dependencies or packages added

## Implementation Notes

- Key decisions made during implementation
- Gotchas or things to watch out for
- Performance considerations

## Testing

- Test files created
- Test coverage areas
- Manual testing procedures

## Next Steps

- [ ] Remaining tasks
- [ ] Future improvements

EOF
        echo -e "${GREEN}✓${NC} Created $CLAUDE_FILE"
    else
        echo -e "${YELLOW}⚠${NC}  CLAUDE.md already exists"
    fi
}

# Command: update - Update CLAUDE.md (manual prompt for now)
cmd_update() {
    if [ ! -f "$CLAUDE_FILE" ]; then
        echo -e "${RED}Error: CLAUDE.md not found. Run 'create' first.${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓${NC} CLAUDE.md ready for updates at:"
    echo -e "  $CLAUDE_FILE"
    echo -e ""
    echo -e "Update sections based on recent changes:"
    echo -e "  - Important Files"
    echo -e "  - Architecture"
    echo -e "  - Dependencies"
    echo -e "  - Implementation Notes"
}

# Command: complete - Mark feature complete and roll up to root CHANGELOG
cmd_complete() {
    if [ ! -f "$CHANGELOG_FILE" ]; then
        echo -e "${RED}Error: Feature CHANGELOG.md not found${NC}"
        exit 1
    fi

    # Update CLAUDE.md status
    if [ -f "$CLAUDE_FILE" ]; then
        sed -i.bak 's/Status.*:/Status**: ✅ Complete  /' "$CLAUDE_FILE"
        sed -i.bak "/Status/a\\
**Completed**: $DATE_ONLY" "$CLAUDE_FILE"
        rm "$CLAUDE_FILE.bak"
        echo -e "${GREEN}✓${NC} Updated CLAUDE.md status to Complete"
    fi

    # Roll up to root CHANGELOG
    if [ -f "$ROOT_CHANGELOG" ]; then
        echo -e "\n## Feature $FEATURE_ID - Completed $DATE_ONLY\n" >> "$ROOT_CHANGELOG"
        # Extract all date sections from feature changelog
        sed -n '/^## [0-9]/,/^## [0-9]/p' "$CHANGELOG_FILE" | sed '$d' >> "$ROOT_CHANGELOG"
        echo "" >> "$ROOT_CHANGELOG"
        echo -e "${GREEN}✓${NC} Rolled up changes to root CHANGELOG.md"
    else
        echo -e "${YELLOW}⚠${NC}  No root CHANGELOG.md found"
    fi

    echo -e "${GREEN}✓${NC} Feature $FEATURE_ID marked complete!"
}

# Execute command
case "$COMMAND" in
    log)
        cmd_log
        ;;
    create)
        cmd_create
        ;;
    update)
        cmd_update
        ;;
    complete)
        cmd_complete
        ;;
    *)
        echo -e "${RED}Error: Unknown command '$COMMAND'${NC}"
        usage
        ;;
esac
