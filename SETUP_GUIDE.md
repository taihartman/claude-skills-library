# Setup Guide - Git Submodule + Symlinks Pattern

This guide shows how to integrate the claude-skills-library into your project using **Git submodules and symlinks** for maximum reusability and maintainability.

## Why This Pattern?

**Traditional Approach (Copying):**
```bash
cp claude-skills-library/generic/*.md .claude/skills/
```

**Downsides:**
- ❌ Duplicate copies across projects
- ❌ Manual updates required
- ❌ No version tracking
- ❌ Divergence over time

**Git Submodule + Symlinks Approach:**
```bash
git submodule add https://github.com/taihartman/claude-skills-library.git .claude/claude-skills-library
ln -s ../claude-skills-library/generic/brainstorming.md .claude/skills/brainstorming.md
```

**Benefits:**
- ✅ Single source of truth
- ✅ Easy updates via `git submodule update`
- ✅ Version tracked in Git
- ✅ Consistent across projects
- ✅ No duplication

---

## Setup Instructions

### Step 1: Add Library as Git Submodule

```bash
# Navigate to your project root
cd /path/to/your/project

# Add library as submodule at .claude/claude-skills-library
git submodule add https://github.com/taihartman/claude-skills-library.git .claude/claude-skills-library

# Commit the submodule
git add .gitmodules .claude/claude-skills-library
git commit -m "Add claude-skills-library as submodule"
```

**What this does:**
- Creates `.claude/claude-skills-library/` directory
- Adds entry to `.gitmodules`
- Tracks library at specific commit

### Step 2: Create Symlinks to Skills

```bash
# Create .claude/skills directory if it doesn't exist
mkdir -p .claude/skills

# Symlink generic skills
ln -s ../claude-skills-library/generic/brainstorming.md .claude/skills/brainstorming.md
ln -s ../claude-skills-library/generic/using-git-worktrees.md .claude/skills/using-git-worktrees.md
ln -s ../claude-skills-library/generic/test-driven-development.md .claude/skills/test-driven-development.md
ln -s ../claude-skills-library/generic/finishing-a-development-branch.md .claude/skills/finishing-a-development-branch.md

# Symlink framework-specific skills (if needed)
# Example for Flutter projects:
ln -s ../claude-skills-library/flutter/mobile-first-design.md .claude/skills/mobile-first-design.md
ln -s ../claude-skills-library/flutter/cubit-testing.md .claude/skills/cubit-testing.md

# Commit symlinks
git add .claude/skills/
git commit -m "Add symlinks to claude-skills-library"
```

**What this does:**
- Creates symbolic links in `.claude/skills/` pointing to submodule files
- Claude Code automatically detects skills via symlinks
- Changes to library automatically reflected in project

### Step 3: Create Symlinks to Commands (Optional)

If the library includes commands (like spec-kit):

```bash
# Create .claude/commands directory if it doesn't exist
mkdir -p .claude/commands

# Symlink spec-kit commands
ln -s ../claude-skills-library/speckit/analyze.md .claude/commands/speckit.analyze.md
ln -s ../claude-skills-library/speckit/checklist.md .claude/commands/speckit.checklist.md
ln -s ../claude-skills-library/speckit/clarify.md .claude/commands/speckit.clarify.md
ln -s ../claude-skills-library/speckit/constitution.md .claude/commands/speckit.constitution.md
ln -s ../claude-skills-library/speckit/implement.md .claude/commands/speckit.implement.md
ln -s ../claude-skills-library/speckit/plan.md .claude/commands/speckit.plan.md
ln -s ../claude-skills-library/speckit/specify.md .claude/commands/speckit.specify.md
ln -s ../claude-skills-library/speckit/tasks.md .claude/commands/speckit.tasks.md

# Commit symlinks
git add .claude/commands/
git commit -m "Add symlinks to spec-kit commands"
```

### Step 4: Verify Setup

```bash
# Check submodule status
git submodule status

# Verify symlinks work
ls -la .claude/skills/
ls -la .claude/commands/  # If you added commands

# Test reading a skill file
cat .claude/skills/brainstorming.md
```

---

## Cloning a Project with Submodules

When teammates clone your project:

### Option 1: Clone with Submodules (Recommended)

```bash
git clone --recurse-submodules https://github.com/yourname/yourproject.git
cd yourproject

# Submodules are automatically initialized and checked out
```

### Option 2: Initialize Submodules After Clone

```bash
git clone https://github.com/yourname/yourproject.git
cd yourproject

# Initialize and fetch submodules
git submodule init
git submodule update
```

**Result:** `.claude/claude-skills-library/` is populated and symlinks work automatically.

---

## Updating the Library

When the claude-skills-library gets updates:

```bash
# Navigate to your project
cd /path/to/your/project

# Update submodule to latest version
cd .claude/claude-skills-library
git pull origin main
cd ../..

# Commit the updated submodule reference
git add .claude/claude-skills-library
git commit -m "Update claude-skills-library to latest version"
git push
```

**Alternative (from project root):**
```bash
git submodule update --remote .claude/claude-skills-library
git add .claude/claude-skills-library
git commit -m "Update claude-skills-library"
```

---

## Project Structure

After setup, your project looks like:

```
your-project/
├── .gitmodules                    # Git submodule config
├── .claude/
│   ├── claude-skills-library/     # Git submodule (library repo)
│   │   ├── generic/
│   │   │   ├── brainstorming.md
│   │   │   ├── test-driven-development.md
│   │   │   └── ...
│   │   ├── flutter/
│   │   ├── speckit/
│   │   │   ├── analyze.md
│   │   │   ├── specify.md
│   │   │   └── ...
│   │   └── README.md
│   ├── skills/                    # Symlinks to library
│   │   ├── brainstorming.md -> ../claude-skills-library/generic/brainstorming.md
│   │   ├── test-driven-development.md -> ../claude-skills-library/generic/test-driven-development.md
│   │   └── ...
│   └── commands/                  # Symlinks to spec-kit (if added)
│       ├── speckit.specify.md -> ../claude-skills-library/speckit/specify.md
│       ├── speckit.plan.md -> ../claude-skills-library/speckit/plan.md
│       └── ...
└── [your project files]
```

---

## Customization

### Adding Project-Specific Skills

Create custom skills directly in `.claude/skills/`:

```bash
# Create custom skill (not a symlink)
touch .claude/skills/our-deployment-workflow.md

# Edit with your project-specific workflow
# This lives in your project, not the library
```

**Result:**
- Library skills are symlinks (stay in sync)
- Custom skills are regular files (project-specific)

### Customizing Templates

Templates from the library should be copied and customized:

```bash
# Copy template to project (break the symlink)
cp .claude/claude-skills-library/templates/activity-logging-template.md \
   .claude/skills/activity-logging.md

# Now customize .claude/skills/activity-logging.md for your project
# This is a regular file, not a symlink
```

---

## Troubleshooting

### "Submodule directory is empty after clone"

**Problem:** Cloned project but `.claude/claude-skills-library/` is empty.

**Solution:**
```bash
git submodule init
git submodule update
```

### "Symlinks show as broken"

**Problem:** Running `ls -la .claude/skills/` shows broken symlinks.

**Solution:**
1. Check submodule is initialized: `git submodule status`
2. Update submodule: `git submodule update --init`
3. Verify symlink paths are correct (should be relative: `../claude-skills-library/...`)

### "Changes to library don't appear in project"

**Problem:** Library was updated but project still shows old version.

**Solution:**
```bash
# Update submodule to latest
cd .claude/claude-skills-library
git pull origin main
cd ../..

# Commit the update
git add .claude/claude-skills-library
git commit -m "Update library"
```

### "I want to pin library to specific version"

**Good practice!** Submodules track specific commits by default.

```bash
# Check current version
cd .claude/claude-skills-library
git log -1 --oneline

# To update to specific version
git checkout <commit-hash>
cd ../..
git add .claude/claude-skills-library
git commit -m "Pin library to version X"
```

---

## Comparison: Submodule vs. Copy

| Aspect | Git Submodule + Symlinks | Direct Copy |
|--------|--------------------------|-------------|
| **Setup Complexity** | Medium (one-time) | Easy |
| **Maintenance** | Easy (git submodule update) | Manual |
| **Version Control** | ✅ Tracked in Git | ❌ No version tracking |
| **Updates** | ✅ Single command | ❌ Re-copy files |
| **Consistency** | ✅ Same version across team | ⚠️ Can diverge |
| **Disk Space** | ✅ Shared across projects | ❌ Duplicated |
| **Customization** | ✅ Mix library + custom | ✅ Easy to modify |

---

## Best Practices

### DO:
- ✅ Use submodules for shared libraries across projects
- ✅ Create symlinks for skills you actually use (don't symlink everything)
- ✅ Keep project-specific customizations in regular files
- ✅ Pin submodule to specific versions for stability
- ✅ Document which skills are symlinked vs. custom

### DON'T:
- ❌ Modify files inside `.claude/claude-skills-library/` (changes will be lost)
- ❌ Symlink templates you plan to customize (copy instead)
- ❌ Mix library skills with project-specific skills in same directory (use clear naming)
- ❌ Forget to commit submodule updates (team needs to know about library changes)

---

## Alternative: Using Git Sparse-Checkout

If you only want specific skills from the library:

```bash
# Add submodule with sparse-checkout
git submodule add https://github.com/taihartman/claude-skills-library.git .claude/claude-skills-library
cd .claude/claude-skills-library

# Enable sparse-checkout
git config core.sparseCheckout true

# Specify which paths to include
echo "generic/brainstorming.md" >> .git/info/sparse-checkout
echo "generic/test-driven-development.md" >> .git/info/sparse-checkout
echo "flutter/" >> .git/info/sparse-checkout

# Apply sparse-checkout
git read-tree -mu HEAD

cd ../..
```

**Result:** Only specified files/folders are checked out from submodule.

---

## Quick Reference Commands

### Initial Setup
```bash
# Add submodule
git submodule add https://github.com/taihartman/claude-skills-library.git .claude/claude-skills-library

# Create symlinks
mkdir -p .claude/skills
ln -s ../claude-skills-library/generic/brainstorming.md .claude/skills/brainstorming.md
# ... (repeat for other skills)

# Commit
git add .gitmodules .claude/
git commit -m "Set up claude-skills-library"
```

### Clone Existing Project
```bash
# Clone with submodules
git clone --recurse-submodules <repo-url>

# OR initialize after clone
git submodule init
git submodule update
```

### Update Library
```bash
# Update to latest
git submodule update --remote .claude/claude-skills-library
git add .claude/claude-skills-library
git commit -m "Update library"
```

### Check Status
```bash
# View submodule status
git submodule status

# View current library version
cd .claude/claude-skills-library && git log -1 --oneline && cd ../..
```

---

## Next Steps

1. ✅ Set up submodule and symlinks (follow instructions above)
2. ✅ Verify skills are accessible to Claude Code
3. ✅ Test using a skill in a conversation
4. ✅ Share setup with team (commit to Git)
5. ✅ Create project-specific custom skills as needed

**Questions?** Open an issue at: https://github.com/taihartman/claude-skills-library/issues

---

**Last Updated:** 2025-11-05
**Pattern Status:** Production-ready, tested in real projects
