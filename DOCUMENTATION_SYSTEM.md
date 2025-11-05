# Complete Documentation System Guide

This guide explains how to use the **commands/** and **speckit/** directories together with the project documentation template to create a comprehensive, maintainable documentation system.

## 🎯 What This System Provides

- ✅ **Feature-driven development** - Each feature has its own spec, plan, tasks, docs, and changelog
- ✅ **Automated workflows** - Slash commands for documentation tasks
- ✅ **Spec-Kit integration** - Structured feature development methodology
- ✅ **Living documentation** - Docs that evolve with the code
- ✅ **Team collaboration** - Clear structure for multiple developers

## 📦 Three Components Working Together

### 1. Documentation Template (`templates/project-documentation-structure-template.md`)
- **What**: Complete guide to the documentation structure
- **When**: Setting up a new project or reorganizing docs
- **Output**: Root-level documentation files (CLAUDE.md, FEATURES.md, etc.)

### 2. Documentation Commands (`commands/`)
- **What**: Slash commands for managing feature docs
- **When**: Day-to-day development (logging changes, updating docs)
- **Output**: Feature CLAUDE.md and CHANGELOG.md files

### 3. Spec-Kit Commands (`speckit/`)
- **What**: Structured feature development workflow
- **When**: Designing and implementing new features
- **Output**: spec.md, plan.md, tasks.md per feature

## 🏗️ Complete Workflow Example

### Phase 1: Project Setup (Once per project)

**Step 1: Set up the library as a submodule**
```bash
cd your-project
git submodule add https://github.com/taihartman/claude-skills-library.git
```

**Step 2: Symlink commands and skills**
```bash
mkdir -p .claude/commands .claude/skills

# Symlink documentation commands
ln -s ../../claude-skills-library/commands/* .claude/commands/

# Symlink Spec-Kit commands
ln -s ../../claude-skills-library/speckit/speckit.specify.md .claude/commands/speckit.specify.md
ln -s ../../claude-skills-library/speckit/speckit.clarify.md .claude/commands/speckit.clarify.md
ln -s ../../claude-skills-library/speckit/speckit.plan.md .claude/commands/speckit.plan.md
ln -s ../../claude-skills-library/speckit/speckit.tasks.md .claude/commands/speckit.tasks.md
ln -s ../../claude-skills-library/speckit/speckit.analyze.md .claude/commands/speckit.analyze.md
ln -s ../../claude-skills-library/speckit/speckit.checklist.md .claude/commands/speckit.checklist.md
ln -s ../../claude-skills-library/speckit/speckit.implement.md .claude/commands/speckit.implement.md

# Symlink generic skills
ln -s ../../claude-skills-library/generic/* .claude/skills/

# Symlink Flutter skills (if Flutter project)
ln -s ../../claude-skills-library/flutter/* .claude/skills/
```

**Step 3: Initialize root documentation**
```bash
# In Claude Code:
/docs.init
```

**Output:**
```
your-project/
├── CLAUDE.md
├── PROJECT_KNOWLEDGE.md
├── DEVELOPMENT.md
├── FEATURES.md
├── CHANGELOG.md
├── CONTRIBUTING.md
└── specs/
```

### Phase 2: Feature Development (Per feature)

**Example: Adding a "Dark Mode" feature**

#### Step 1: Specify the feature
```bash
/speckit.specify

# Claude will guide you through:
# - Feature description
# - User stories
# - Acceptance criteria
# - Technical requirements
```

**Output:** `specs/012-dark-mode/spec.md`

#### Step 2: Clarify underspecified areas
```bash
/speckit.clarify

# Claude identifies gaps and asks targeted questions:
# - "Should dark mode persist across sessions?"
# - "Which components need dark variants?"
# - "Should there be an auto/system mode?"
```

**Updates:** `specs/012-dark-mode/spec.md` (with clarifications added)

#### Step 3: Generate implementation plan
```bash
/speckit.plan

# Claude creates detailed design:
# - Architecture decisions
# - Component structure
# - Data flow
# - Dependencies
```

**Output:** `specs/012-dark-mode/plan.md`

#### Step 4: Generate task breakdown
```bash
/speckit.tasks

# Claude breaks plan into actionable tasks:
# - Create ThemeProvider
# - Add dark color palette
# - Update all components
# - Add settings toggle
# - Write tests
```

**Output:** `specs/012-dark-mode/tasks.md`

#### Step 5: Analyze consistency
```bash
/speckit.analyze

# Claude checks:
# - spec.md ↔ plan.md alignment
# - plan.md ↔ tasks.md completeness
# - Missing requirements
# - Inconsistencies
```

**Output:** Analysis report with any issues found

#### Step 6: Generate quality checklist
```bash
/speckit.checklist

# Claude creates custom validation checklist:
# - [ ] Theme persists on refresh
# - [ ] All components have dark variants
# - [ ] Settings toggle works
# - [ ] Tests cover theme switching
```

**Output:** Quality checklist for verification

#### Step 7: Initialize feature documentation
```bash
/docs.create

# Claude creates feature docs:
# - CLAUDE.md (architecture)
# - CHANGELOG.md (development log)
```

**Output:**
```
specs/012-dark-mode/
├── spec.md
├── plan.md
├── tasks.md
├── CLAUDE.md        ← New
└── CHANGELOG.md     ← New
```

#### Step 8: Implement the feature
```bash
/speckit.implement

# Claude executes the plan:
# - Works through tasks.md systematically
# - Creates/modifies files
# - Writes tests
# - Logs progress
```

**During implementation, log frequently:**
```bash
/docs.log "Created ThemeProvider with dark/light modes"
/docs.log "Added dark variants for all components"
/docs.log "Implemented settings toggle UI"
```

**This updates:** `specs/012-dark-mode/CHANGELOG.md`

#### Step 9: Update architecture docs
```bash
/docs.update

# After adding significant components:
# - New ThemeProvider
# - New ThemeSettings model
# - Updated routes
```

**This updates:** `specs/012-dark-mode/CLAUDE.md`

#### Step 10: Complete the feature
```bash
/docs.complete

# When feature is done and tested:
# - Marks feature as complete
# - Rolls up changelog to root
# - Updates root FEATURES.md
```

**Updates:**
- `FEATURES.md` - Feature marked ✅ complete
- `CHANGELOG.md` - Entries added to root
- `specs/012-dark-mode/CLAUDE.md` - Status: Complete

### Phase 3: Maintenance (Ongoing)

**Search documentation:**
```bash
/docs.search "theme"
# Finds all references to theme across all docs
```

**Validate documentation:**
```bash
/docs.validate
# Checks for:
# - Missing CLAUDE.md or CHANGELOG.md
# - Incomplete features
# - Stale docs
# - Broken links
```

**Archive old features:**
```bash
/docs.archive

# Move completed/deprecated features to archive
```

## 📁 Resulting Structure

After following this workflow for multiple features:

```
your-project/
├── CLAUDE.md                      # Project entry point
├── PROJECT_KNOWLEDGE.md           # Architecture knowledge
├── DEVELOPMENT.md                 # Development workflows
├── FEATURES.md                    # Feature directory (status tracking)
├── CHANGELOG.md                   # Root changelog (rolled up)
├── CONTRIBUTING.md                # Contribution guide
├── .claude/
│   ├── commands/                  # Symlinked commands
│   │   ├── docs.create.md
│   │   ├── docs.log.md
│   │   ├── docs.update.md
│   │   ├── docs.complete.md
│   │   ├── docs.validate.md
│   │   ├── docs.search.md
│   │   ├── speckit.specify.md
│   │   ├── speckit.clarify.md
│   │   ├── speckit.plan.md
│   │   ├── speckit.tasks.md
│   │   ├── speckit.analyze.md
│   │   ├── speckit.checklist.md
│   │   └── speckit.implement.md
│   └── skills/                    # Symlinked skills
│       ├── brainstorming.md
│       ├── test-driven-development.md
│       ├── using-git-worktrees.md
│       └── ...
└── specs/
    ├── 001-initial-feature/
    │   ├── spec.md
    │   ├── plan.md
    │   ├── tasks.md
    │   ├── CLAUDE.md
    │   └── CHANGELOG.md
    ├── 002-another-feature/
    │   ├── spec.md
    │   ├── plan.md
    │   ├── tasks.md
    │   ├── CLAUDE.md
    │   └── CHANGELOG.md
    └── 012-dark-mode/
        ├── spec.md            # What we're building
        ├── plan.md            # How we'll build it
        ├── tasks.md           # Step-by-step tasks
        ├── CLAUDE.md          # Architecture documentation
        └── CHANGELOG.md       # Development history
```

## 🔄 Daily Development Workflow

**Starting a new feature:**
```bash
1. /speckit.specify       # Define what
2. /speckit.clarify       # Clarify gaps
3. /speckit.plan          # Design how
4. /speckit.tasks         # Break down steps
5. /speckit.analyze       # Verify consistency
6. /docs.create           # Initialize docs
7. /speckit.implement     # Build it
```

**During implementation:**
```bash
# After completing a significant task:
/docs.log "Implemented dark theme provider"

# After adding new components:
/docs.update

# Frequently check progress:
/docs.search "ThemeProvider"
```

**Finishing a feature:**
```bash
1. /docs.complete         # Mark complete
2. /docs.validate         # Final check
3. Create PR with link to specs/{feature}/
```

## 🎯 Benefits of This System

### For Solo Developers
- **Context switching** - Pick up where you left off easily
- **Decision tracking** - Remember why you made choices
- **Progress visibility** - See what's done vs. todo
- **Future you** - Document for yourself 6 months later

### For Teams
- **Onboarding** - New developers understand project structure
- **Code reviews** - Reviewers see the full context (spec → implementation)
- **Knowledge sharing** - Decisions and patterns are documented
- **Consistency** - Everyone follows the same workflow

### For AI Collaboration (Claude Code)
- **Context preservation** - Claude can read your specs and plans
- **Systematic execution** - Claude follows documented workflows
- **Quality assurance** - Claude uses checklists to validate
- **Living documentation** - Docs stay in sync with code

## 📚 Documentation Philosophy

### Multi-Document System
**Don't** put everything in one massive README.

**Do** split into specialized documents:
- `CLAUDE.md` - Quick reference hub
- `PROJECT_KNOWLEDGE.md` - Deep architecture knowledge
- `DEVELOPMENT.md` - Development workflows
- `FEATURES.md` - Feature directory
- Per-feature docs in `specs/`

### Living Documentation
**Don't** write docs once and forget.

**Do** update docs as you develop:
- `/docs.log` after significant changes
- `/docs.update` after architectural changes
- `/docs.complete` when feature is done

### Feature-Centric Organization
**Don't** organize by file type (all specs together, all docs together).

**Do** organize by feature (everything related to a feature together):
```
specs/012-dark-mode/
├── spec.md          # All dark mode docs
├── plan.md          # in one place
├── tasks.md
├── CLAUDE.md
└── CHANGELOG.md
```

## 🔧 Customization

### Adjust for Your Project

**If you don't need Spec-Kit:**
- Skip `/speckit.*` commands
- Just use `/docs.*` commands
- Manually create specs/plans

**If you have different doc needs:**
- Edit command templates
- Add custom fields to CLAUDE.md
- Modify FEATURES.md structure

**If you have different workflows:**
- Create custom commands in `.claude/commands/`
- Reference library commands as examples
- Mix and match as needed

## ✅ Quick Reference

| Task | Command |
|------|---------|
| Start new feature | `/speckit.specify` |
| Design feature | `/speckit.plan` |
| Break into tasks | `/speckit.tasks` |
| Check consistency | `/speckit.analyze` |
| Init feature docs | `/docs.create` |
| Log a change | `/docs.log "description"` |
| Update architecture | `/docs.update` |
| Complete feature | `/docs.complete` |
| Search all docs | `/docs.search "query"` |
| Validate docs | `/docs.validate` |

## 🎓 Learning Path

1. **Read** - [project-documentation-structure-template](templates/project-documentation-structure-template.md)
2. **Set up** - Initialize docs with `/docs.init`
3. **Try Spec-Kit** - Create a small feature following the workflow
4. **Use docs commands** - Log changes as you develop
5. **Refine** - Adjust templates and workflow to your needs

---

**This system is battle-tested** - it evolved from real production projects and has been refined through actual use. Start with the basics, adopt what works, and customize as needed!

**Next Steps:**
1. Read the [project-documentation-structure-template](templates/project-documentation-structure-template.md)
2. Initialize your project: `/docs.init`
3. Start your first feature: `/speckit.specify`
