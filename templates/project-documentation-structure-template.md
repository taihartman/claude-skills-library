# Project Documentation Structure Template

A comprehensive, battle-tested documentation system for Claude Code projects. This template documents the evolved structure used in production projects for maximum maintainability and team collaboration.

## 📋 Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Directory Structure](#directory-structure)
- [Root-Level Documentation](#root-level-documentation)
- [.claude Directory](#claude-directory)
- [Feature Specs Structure](#feature-specs-structure)
- [Documentation Workflows](#documentation-workflows)
- [Best Practices](#best-practices)
- [Customization Guide](#customization-guide)

---

## Overview

This documentation structure provides:

- ✅ **Multi-document system** - Specialized docs instead of one massive README
- ✅ **Feature tracking** - Complete feature directory with status
- ✅ **Development workflows** - Automated documentation commands
- ✅ **Spec-Kit integration** - Structured feature development
- ✅ **Reusable skills** - Common workflows captured as skills
- ✅ **Team onboarding** - Clear entry points for new contributors

**Origin**: Evolved from multiple production projects, refined through real-world use.

---

## Quick Start

### Step 1: Create Base Documentation Files

```bash
# Navigate to project root
cd your-project

# Create root documentation files
touch CLAUDE.md
touch PROJECT_KNOWLEDGE.md
touch DEVELOPMENT.md
touch MOBILE.md  # If mobile project
touch TROUBLESHOOTING.md
touch FEATURES.md
touch CHANGELOG.md
touch CONTRIBUTING.md
touch GETTING_STARTED.md
```

### Step 2: Set Up .claude Directory

```bash
# Create .claude structure
mkdir -p .claude/skills
mkdir -p .claude/commands
mkdir -p .claude/memory
mkdir -p .claude/hooks

# Add as Git submodule (recommended)
git submodule add https://github.com/taihartman/claude-skills-library.git .claude/claude-skills-library

# Create symlinks to skills you need
ln -s ../claude-skills-library/generic/brainstorming.md .claude/skills/brainstorming.md
ln -s ../claude-skills-library/generic/test-driven-development.md .claude/skills/test-driven-development.md
# ... (add more as needed)

# Create symlinks to spec-kit commands
ln -s ../claude-skills-library/speckit/specify.md .claude/commands/speckit.specify.md
ln -s ../claude-skills-library/speckit/plan.md .claude/commands/speckit.plan.md
# ... (add remaining spec-kit commands)
```

### Step 3: Create Documentation Commands

Create custom documentation commands in `.claude/commands/`:

```bash
touch .claude/commands/docs.create.md
touch .claude/commands/docs.log.md
touch .claude/commands/docs.update.md
touch .claude/commands/docs.complete.md
```

(See [Documentation Commands](#documentation-commands) section for templates)

### Step 4: Create Specs Directory

```bash
# Create specs directory
mkdir -p specs

# Features will be added as: specs/{id}-{name}/
```

### Step 5: Populate Template Content

Use the templates provided in this document to populate each file with your project-specific content.

---

## Directory Structure

Complete project structure after setup:

```
your-project/
├── .claude/                           # Claude Code configuration
│   ├── claude-skills-library/         # Git submodule (shared library)
│   │   ├── generic/                   # Universal skills
│   │   ├── flutter/                   # Framework skills
│   │   ├── speckit/                   # Spec-Kit commands
│   │   └── templates/                 # Adaptable templates
│   ├── skills/                        # Symlinks to library + custom skills
│   │   ├── brainstorming.md -> ../claude-skills-library/generic/brainstorming.md
│   │   ├── test-driven-development.md -> ../claude-skills-library/generic/test-driven-development.md
│   │   └── my-custom-skill.md         # Project-specific skill (regular file)
│   ├── commands/                      # Slash commands
│   │   ├── speckit.*.md -> ../claude-skills-library/speckit/*.md  # Symlinks
│   │   ├── docs.create.md             # Custom command
│   │   ├── docs.log.md                # Custom command
│   │   ├── docs.update.md             # Custom command
│   │   └── docs.complete.md           # Custom command
│   ├── memory/                        # Session memory files
│   │   └── feature-context.md
│   ├── hooks/                         # Git hooks and event handlers
│   │   ├── pre-commit.md
│   │   └── user-prompt-submit.md
│   └── permissions.json               # Tool permissions
│
├── specs/                             # Feature specifications
│   ├── 001-feature-name/
│   │   ├── spec.md                    # Feature specification
│   │   ├── plan.md                    # Implementation plan
│   │   ├── tasks.md                   # Task breakdown
│   │   ├── CLAUDE.md                  # Feature architecture
│   │   └── CHANGELOG.md               # Feature development log
│   ├── 002-another-feature/
│   └── ...
│
├── CLAUDE.md                          # Quick reference hub
├── PROJECT_KNOWLEDGE.md               # Architecture & patterns
├── DEVELOPMENT.md                     # Development workflows
├── MOBILE.md                          # Mobile-specific guidelines (if applicable)
├── TROUBLESHOOTING.md                 # Common issues
├── FEATURES.md                        # Feature directory
├── CHANGELOG.md                       # Root changelog
├── CONTRIBUTING.md                    # Contribution guide
├── GETTING_STARTED.md                 # New contributor onboarding
├── README.md                          # Public-facing README
│
└── [your source code...]
```

---

## Root-Level Documentation

### CLAUDE.md (Hub Document)

**Purpose**: Main entry point for Claude Code. Quick reference with links to specialized docs.

**Template**:

```markdown
# CLAUDE.md - [Project Name] Quick Reference

This is the main entry point for understanding and working with the [project name] codebase.

## 📚 Documentation Structure

- **[PROJECT_KNOWLEDGE.md](PROJECT_KNOWLEDGE.md)** - Architecture, design patterns, data flow
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - Development workflows and systems
- **[MOBILE.md](MOBILE.md)** - Mobile-first design guidelines (if applicable)
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues and solutions
- **[FEATURES.md](FEATURES.md)** - Feature directory with status
- **[GETTING_STARTED.md](GETTING_STARTED.md)** - New contributor onboarding
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines
- **This file (CLAUDE.md)** - Quick reference hub

## 🎯 Quick Start

### Essential Commands

```bash
# Development commands
[your commands here]
```

### Before Every Commit

```bash
[your pre-commit checklist]
```

## 🛠️ Claude Code Skills System

This project includes reusable workflow skills in `.claude/skills/`:

| Skill | Purpose | Use When |
|-------|---------|----------|
| **brainstorming.md** | Design refinement | Exploring features |
| **test-driven-development.md** | TDD workflow | Implementing features |
| [add your skills] | | |

## 📋 Development Workflow Instructions

### Workflow Commands

- **`/docs.create`** - Create feature documentation
- **`/docs.log "description"`** - Log changes (use frequently!)
- **`/docs.update`** - Update feature architecture docs
- **`/docs.complete`** - Mark feature complete

### When to Document

**Use `/docs.log` after:**
- Completing significant todo items
- Creating new files
- Fixing bugs

**Use `/docs.update` after:**
- Adding models, repositories, business logic
- Changing design patterns
- Modifying core data structures

## 🏗️ Project Architecture

[Brief architecture overview - link to PROJECT_KNOWLEDGE.md for details]

## 🔧 Common Tasks

### [Common Task 1]
[Quick how-to with link to detailed docs]

### [Common Task 2]
[Quick how-to with link to detailed docs]

## 📦 Spec-Driven Development

This project uses **GitHub Spec-Kit** for structured feature development.

### Required Spec-Kit Workflow

1. **`/speckit.specify`** - Create/update feature specification
2. **`/speckit.clarify`** - Clarify underspecified areas
3. **`/speckit.plan`** - Generate implementation plan
4. **`/speckit.tasks`** - Generate task breakdown
5. **`/speckit.analyze`** - Consistency analysis
6. **`/speckit.implement`** - Execute implementation

## 📂 Feature Directory

See [FEATURES.md](FEATURES.md) for complete feature list.

## 🆘 Troubleshooting

[Quick troubleshooting tips - link to TROUBLESHOOTING.md]

## 📖 Documentation Index

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **CLAUDE.md** | Quick reference | Start here |
| **PROJECT_KNOWLEDGE.md** | Architecture | Understanding structure |
| **DEVELOPMENT.md** | Workflows | Using systems |
| **TROUBLESHOOTING.md** | Issues | Debugging |

---

**Last Updated**: [date]
**Documentation Structure**: Multi-document system
```

---

### PROJECT_KNOWLEDGE.md

**Purpose**: Deep dive into architecture, design patterns, data flow, and technical decisions.

**Structure**:

```markdown
# Project Knowledge - [Project Name]

## Architecture Overview

### Clean Architecture Layers

[Your architecture diagram/explanation]

### Key Patterns

[Design patterns used]

## Data Flow

[How data flows through the system]

## Technical Decisions

### Decision Log

| Date | Decision | Rationale |
|------|----------|-----------|
| [date] | [decision] | [why] |

## Core Systems

### System 1: [Name]

**Purpose**: [what it does]

**Components**:
- Component A: [description]
- Component B: [description]

**Data Flow**: [how data flows]

**Examples**: [code examples]

---

**Last Updated**: [date]
```

---

### DEVELOPMENT.md

**Purpose**: Development workflows, systems, and how-to guides.

**Structure**:

```markdown
# Development Guide - [Project Name]

## Development Workflows

### Feature Development Workflow

1. Create feature branch
2. Run `/speckit.specify` to create spec
3. [rest of workflow]

### Documentation Workflow

**Use `/docs.log` after:**
- [trigger 1]
- [trigger 2]

## System Guides

### [System 1]: How to Use

**Pattern**: [explanation]

**Example**:
```[language]
[code example]
```

**Troubleshooting**: [common issues]

---

**Last Updated**: [date]
```

---

### FEATURES.md

**Purpose**: Complete feature directory with status and descriptions.

**Template**:

```markdown
# Features Directory - [Project Name]

## Overview

This project has **[X] completed features**. Each feature has full documentation in `specs/{id}-{name}/`.

## Feature Status Legend

- ✅ **Complete** - Fully implemented and shipped
- 🚧 **In Progress** - Currently being developed
- 📋 **Planned** - Spec complete, not started
- ❌ **Deprecated** - No longer maintained

---

## Feature List

### ✅ 001 - [Feature Name]

**Status**: Complete | **Version**: v1.0.0 | **Date**: [date]

**Description**: [1-2 sentence description]

**Key Components**:
- Component A
- Component B

**Documentation**: [specs/001-feature-name/](specs/001-feature-name/)

---

### 🚧 002 - [Feature Name]

[Repeat structure]

---

## Feature Dependencies

```
001 (Core) → 002 (Depends on 001)
001 (Core) → 003 (Depends on 001)
002 + 003 → 004 (Depends on both)
```

## Adding New Features

1. Create new spec: `/speckit.specify`
2. Generate plan: `/speckit.plan`
3. Create tasks: `/speckit.tasks`
4. Initialize docs: `/docs.create`
5. Update this file with new feature entry

---

**Last Updated**: [date]
**Total Features**: [X]
```

---

### TROUBLESHOOTING.md

**Purpose**: Common issues, solutions, and debugging guides.

**Template**:

```markdown
# Troubleshooting Guide - [Project Name]

## Common Issues

### Issue 1: [Problem]

**Symptoms**: [what user sees]

**Cause**: [why it happens]

**Solution**:
1. Step 1
2. Step 2

**Example**:
```bash
[command]
```

---

### Issue 2: [Problem]

[Repeat structure]

---

## Debugging Workflows

### Debug Workflow 1: [Scenario]

**When to use**: [situation]

**Steps**:
1. [step]
2. [step]

---

## Error Reference

| Error Message | Cause | Solution |
|---------------|-------|----------|
| [error] | [cause] | [fix] |

---

**Last Updated**: [date]
```

---

## .claude Directory

### Skills (.claude/skills/)

**Purpose**: Reusable workflow skills that guide Claude through complex tasks.

**Setup**:
- Symlink shared skills from claude-skills-library
- Create project-specific skills as regular files

**Example custom skill**:

```markdown
---
name: my-project-workflow
description: Our standard workflow for [specific task]
category: template
---

# [Task] Workflow

## When to Use

- [trigger 1]
- [trigger 2]

## Workflow

### Step 1: [Action]
[Instructions]

### Step 2: [Action]
[Instructions]

## Best Practices

✅ DO: [guideline]
❌ DON'T: [anti-pattern]
```

---

### Commands (.claude/commands/)

**Purpose**: Slash commands for common operations.

#### Documentation Commands

**docs.create.md**:

```markdown
---
name: docs.create
description: Create feature documentation (CLAUDE.md + CHANGELOG.md)
---

# Create Feature Documentation

Create CLAUDE.md and CHANGELOG.md for the current feature in specs/{id}-{name}/.

## Usage

```
/docs.create
```

## Workflow

1. Detect current feature directory from context
2. Create CLAUDE.md with architecture template
3. Create CHANGELOG.md with initial entry
4. Report success to user

## Templates

### CLAUDE.md Template

```markdown
# Feature: [Name]

## Overview

[Description]

## Architecture

[Components and structure]

---

**Created**: [date]
```

### CHANGELOG.md Template

```markdown
# Changelog - [Feature Name]

## [Date] - Feature initialized

- Created feature specification
- Initialized documentation
```

---

```

**docs.log.md**:

```markdown
---
name: docs.log
description: Log changes to feature CHANGELOG.md
---

# Log Feature Change

Add entry to current feature's CHANGELOG.md.

## Usage

```
/docs.log "description of change"
```

## Workflow

1. Detect current feature from context
2. Find CHANGELOG.md in specs/{id}-{name}/
3. Add new entry with timestamp:
   ```
   ## [date] - [description]

   - [details from recent work]
   ```
4. Commit change
```

**docs.update.md**:

```markdown
---
name: docs.update
description: Update feature CLAUDE.md with architecture changes
---

# Update Feature Documentation

Update CLAUDE.md when architecture or components change.

## Usage

```
/docs.update
```

## Workflow

1. Analyze recent changes (new files, models, components)
2. Update CLAUDE.md sections:
   - Components list
   - Data flow
   - Dependencies
3. Add update entry to CHANGELOG.md
```

**docs.complete.md**:

```markdown
---
name: docs.complete
description: Mark feature complete and roll up to root CHANGELOG.md
---

# Complete Feature Documentation

Finalize feature docs and update root CHANGELOG.md.

## Usage

```
/docs.complete
```

## Workflow

1. Verify feature is complete (all tests pass, docs updated)
2. Mark feature status in FEATURES.md
3. Add feature summary to root CHANGELOG.md
4. Update feature count in FEATURES.md
```

---

## Feature Specs Structure

Each feature lives in `specs/{id}-{name}/` with standardized files.

### Directory Structure

```
specs/001-feature-name/
├── spec.md           # Feature specification (from /speckit.specify)
├── plan.md           # Implementation plan (from /speckit.plan)
├── tasks.md          # Task breakdown (from /speckit.tasks)
├── CLAUDE.md         # Feature architecture (from /docs.create)
├── CHANGELOG.md      # Development log (from /docs.log)
├── checklists/       # Quality checklists (from /speckit.checklist)
├── contracts/        # API contracts (optional)
├── data-model.md     # Data structures (optional)
└── research.md       # Research notes (optional)
```

### File Purposes

**spec.md** - What to build
- User stories
- Requirements
- Acceptance criteria

**plan.md** - How to build it
- Architecture decisions
- Implementation steps
- Technology choices

**tasks.md** - Actionable breakdown
- Specific tasks
- Dependencies
- Estimates

**CLAUDE.md** - Architecture reference
- Components built
- Data flow
- Integration points

**CHANGELOG.md** - Development history
- Daily progress
- Key decisions
- Bug fixes

---

## Documentation Workflows

### Workflow 1: Starting New Feature

```bash
# 1. Create feature branch
git checkout -b feature/005-new-feature

# 2. Create specification
/speckit.specify

# 3. Clarify underspecified areas
/speckit.clarify

# 4. Generate plan
/speckit.plan

# 5. Generate tasks
/speckit.tasks

# 6. Analyze consistency
/speckit.analyze

# 7. Initialize feature docs
/docs.create

# 8. Begin implementation
/speckit.implement
```

### Workflow 2: During Development

```bash
# Log significant changes frequently
/docs.log "Added user authentication model"
/docs.log "Implemented login endpoint"
/docs.log "Fixed token refresh bug"

# Update architecture when structure changes
/docs.update
```

### Workflow 3: Completing Feature

```bash
# 1. Verify all tasks done
# 2. Run tests
# 3. Update docs one final time
/docs.update

# 4. Mark complete and roll up
/docs.complete

# 5. Update FEATURES.md with new feature
# (edit manually or automate)
```

---

## Best Practices

### DO

✅ **Keep CLAUDE.md current** - Main entry point should always be accurate
✅ **Log frequently** - Use `/docs.log` after every significant change
✅ **Update FEATURES.md** - Keep feature directory in sync
✅ **Use symlinks for shared skills** - Single source of truth
✅ **Version control .claude/** - Team needs access to commands
✅ **Cross-reference docs** - Link between related documents
✅ **Use spec-kit workflow** - Structured development prevents issues

### DON'T

❌ **Don't skip documentation** - Future you will thank present you
❌ **Don't create massive README** - Use multi-document system
❌ **Don't hardcode in commands** - Use variables and detection
❌ **Don't forget to commit docs** - Docs are as important as code
❌ **Don't modify library skills** - Create custom versions instead
❌ **Don't skip `/docs.complete`** - Root changelog needs updates

---

## Customization Guide

### Adapting for Your Project

**Step 1: Choose Relevant Documents**

Not every project needs every document. Start with:
- Required: CLAUDE.md, PROJECT_KNOWLEDGE.md, FEATURES.md
- Recommended: DEVELOPMENT.md, TROUBLESHOOTING.md
- Optional: MOBILE.md (if mobile), CONTRIBUTING.md (if open source)

**Step 2: Customize Templates**

Replace placeholders:
- `[Project Name]` → Your project name
- `[your commands here]` → Your actual commands
- `[System 1]` → Your actual systems

**Step 3: Adjust Structure**

Modify to fit your needs:
- Add language-specific sections
- Remove irrelevant sections
- Add project-specific workflows

**Step 4: Create Custom Commands**

Build documentation commands that fit your workflow:
- Copy templates from this guide
- Adapt to your directory structure
- Test thoroughly

**Step 5: Document Your Customizations**

Update CLAUDE.md to reflect:
- What you changed
- Why you changed it
- How your structure differs

---

## Example Implementations

### Example 1: Flutter Mobile App

```
flutter-app/
├── .claude/
│   ├── skills/
│   │   ├── mobile-first-design.md
│   │   ├── cubit-testing.md
│   │   └── flutter-workflow.md
│   └── commands/ [standard commands]
├── CLAUDE.md
├── PROJECT_KNOWLEDGE.md
├── MOBILE.md                    # ✅ Included (mobile project)
├── DEVELOPMENT.md
├── TROUBLESHOOTING.md
└── specs/ [feature specs]
```

### Example 2: Backend API

```
backend-api/
├── .claude/
│   ├── skills/
│   │   ├── api-design.md
│   │   ├── database-migration.md
│   │   └── security-review.md
│   └── commands/ [standard commands]
├── CLAUDE.md
├── PROJECT_KNOWLEDGE.md
├── API_DOCUMENTATION.md         # ✅ Custom doc
├── DEVELOPMENT.md
└── specs/ [feature specs]
```

### Example 3: Game Project

```
game-project/
├── .claude/
│   ├── skills/
│   │   ├── game-design-workflow.md
│   │   ├── playtesting-workflow.md
│   │   └── balancing-workflow.md
│   └── commands/ [standard + custom]
├── CLAUDE.md
├── DESIGN_DOCUMENTS.md          # ✅ Game-specific
├── BALANCING.md                 # ✅ Game-specific
├── DEVELOPMENT.md
└── specs/ [feature specs]
```

---

## Migration from Existing Projects

### Migrating to This Structure

**If you have a massive README**:

1. Create empty docs: `CLAUDE.md`, `PROJECT_KNOWLEDGE.md`, etc.
2. Split README content into appropriate docs
3. Update CLAUDE.md as hub with links
4. Keep old README for reference until confident

**If you have no documentation**:

1. Start with CLAUDE.md (quick wins)
2. Add PROJECT_KNOWLEDGE.md next
3. Create FEATURES.md (forces you to inventory)
4. Add remaining docs as needed

**If you have scattered docs**:

1. Create `.claude/` structure
2. Consolidate existing docs into standard names
3. Create index in CLAUDE.md
4. Archive old docs (don't delete yet)

---

## Maintenance

### Regular Updates

**Weekly**:
- Review FEATURES.md for accuracy
- Update CHANGELOG.md with merged work

**Monthly**:
- Review all root docs for accuracy
- Update troubleshooting with new solutions
- Prune obsolete memory files

**Per Feature**:
- Initialize with `/docs.create`
- Log frequently with `/docs.log`
- Update architecture with `/docs.update`
- Finalize with `/docs.complete`

### Team Collaboration

**Onboarding New Developers**:
1. Start with GETTING_STARTED.md
2. Read CLAUDE.md for overview
3. Read PROJECT_KNOWLEDGE.md for architecture
4. Reference DEVELOPMENT.md during work

**Code Reviews**:
- Verify docs updated alongside code
- Check `/docs.log` entries exist
- Confirm FEATURES.md updated for new features

---

## Troubleshooting This System

### "Too many docs to maintain"

**Solution**: Start with core 3: CLAUDE.md, PROJECT_KNOWLEDGE.md, FEATURES.md. Add others only when needed.

### "Commands don't work"

**Check**:
- Files in `.claude/commands/` have `.md` extension
- YAML frontmatter is valid
- Paths in commands match your structure

### "Team not using documentation"

**Solutions**:
- Make docs helpful, not burdensome
- Automate with commands
- Reference docs in PRs
- Lead by example

---

## Resources

- **Claude Skills Library**: https://github.com/taihartman/claude-skills-library
- **GitHub Spec-Kit**: https://github.com/github/spec-kit
- **Setup Guide**: [SETUP_GUIDE.md](../SETUP_GUIDE.md)

---

**Version**: 1.0.0
**Last Updated**: 2025-11-05
**Origin**: Evolved from production projects (expense_tracker, DropForge)
**Status**: Production-ready

---

## Quick Reference Checklist

Setting up a new project:

- [ ] Create root docs (CLAUDE.md, PROJECT_KNOWLEDGE.md, etc.)
- [ ] Set up `.claude/` directory structure
- [ ] Add claude-skills-library as submodule
- [ ] Create symlinks to shared skills
- [ ] Create symlinks to spec-kit commands
- [ ] Create custom documentation commands
- [ ] Initialize FEATURES.md
- [ ] Create first feature with spec-kit
- [ ] Test documentation workflow
- [ ] Commit everything to version control

---

**Questions? Issues? Improvements?**

- Open an issue: https://github.com/taihartman/claude-skills-library/issues
- Start a discussion: https://github.com/taihartman/claude-skills-library/discussions
- Submit a PR with your customizations!
