# Project Setup Prompt for Claude

Copy and paste this prompt into your project (e.g., "drop forge") to have Claude set up the complete documentation system:

---

## The Prompt

```
I want to set up the complete documentation system from claude-skills-library in this project.

Please follow these steps exactly:

1. **Add claude-skills-library as a submodule:**
   - `git submodule add https://github.com/taihartman/claude-skills-library.git`
   - Initialize the submodule

2. **Create directory structure:**
   - `.claude/commands/`
   - `.claude/skills/`
   - `specs/`

3. **Symlink all commands:**
   - Symlink ALL files from `claude-skills-library/commands/` to `.claude/commands/`
   - Symlink ALL files from `claude-skills-library/speckit/` to `.claude/commands/` (with speckit. prefix)
   - Symlink ALL files from `claude-skills-library/generic/` to `.claude/skills/`
   - [If Flutter project] Symlink ALL files from `claude-skills-library/flutter/` to `.claude/skills/`

4. **Initialize root documentation using /docs.init:**
   - Create CLAUDE.md
   - Create PROJECT_KNOWLEDGE.md
   - Create DEVELOPMENT.md
   - Create FEATURES.md
   - Create CHANGELOG.md
   - Create CONTRIBUTING.md
   - Create TROUBLESHOOTING.md
   - Customize for THIS project (not generic templates)

5. **Verify setup:**
   - List all symlinked commands
   - List all symlinked skills
   - Verify all root docs exist
   - Test one command (e.g., `/docs.search`)

6. **Create .gitignore entries:**
   - Add `.claude/` entries if needed (but NOT the symlinks themselves)
   - Ensure submodule is tracked

7. **Commit the setup:**
   - Stage `.gitmodules`
   - Stage `.claude/` symlinks
   - Stage root documentation files
   - Create commit: "Initialize documentation system with claude-skills-library"

After completing setup, provide:
- ✅ Checklist of what was created
- 📁 Tree view of `.claude/` directory
- 📝 Summary of available commands
- 🎯 Next steps for starting first feature

Important:
- Use RELATIVE paths for symlinks (../../claude-skills-library/...)
- Don't copy files, SYMLINK them (so we get updates)
- Customize docs for THIS project, not generic
- Test that commands work by running `/docs.search "test"`
```

---

## What This Will Do

After running this prompt, your project will have:

```
drop-forge/
├── .gitmodules                    # Submodule configuration
├── claude-skills-library/         # Submodule (tracked)
│   ├── commands/
│   ├── speckit/
│   ├── generic/
│   ├── flutter/
│   └── templates/
├── .claude/
│   ├── commands/                  # Symlinked →
│   │   ├── docs.create.md        # ../../claude-skills-library/commands/docs.create.md
│   │   ├── docs.log.md          # ../../claude-skills-library/commands/docs.log.md
│   │   ├── docs.update.md       # ../../claude-skills-library/commands/docs.update.md
│   │   ├── docs.complete.md     # ../../claude-skills-library/commands/docs.complete.md
│   │   ├── docs.validate.md     # ../../claude-skills-library/commands/docs.validate.md
│   │   ├── docs.search.md       # ../../claude-skills-library/commands/docs.search.md
│   │   ├── docs.init.md         # ../../claude-skills-library/commands/docs.init.md
│   │   ├── docs.archive.md      # ../../claude-skills-library/commands/docs.archive.md
│   │   ├── speckit.specify.md   # ../../claude-skills-library/speckit/specify.md
│   │   ├── speckit.clarify.md   # ../../claude-skills-library/speckit/clarify.md
│   │   ├── speckit.plan.md      # ../../claude-skills-library/speckit/plan.md
│   │   ├── speckit.tasks.md     # ../../claude-skills-library/speckit/tasks.md
│   │   ├── speckit.analyze.md   # ../../claude-skills-library/speckit/analyze.md
│   │   ├── speckit.checklist.md # ../../claude-skills-library/speckit/checklist.md
│   │   └── speckit.implement.md # ../../claude-skills-library/speckit/implement.md
│   └── skills/                    # Symlinked →
│       ├── brainstorming.md      # ../../claude-skills-library/generic/brainstorming.md
│       ├── using-git-worktrees.md
│       ├── test-driven-development.md
│       ├── finishing-a-development-branch.md
│       └── read-with-context.md
├── specs/                         # Will hold feature specs
├── CLAUDE.md                      # Main project guide
├── PROJECT_KNOWLEDGE.md           # Architecture docs
├── DEVELOPMENT.md                 # Development workflows
├── FEATURES.md                    # Feature directory
├── CHANGELOG.md                   # Root changelog
├── CONTRIBUTING.md                # Contribution guide
└── TROUBLESHOOTING.md             # Common issues
```

## Verification Steps

After Claude completes setup, verify:

```bash
# 1. Check submodule
git submodule status
# Should show: claude-skills-library at a commit hash

# 2. Check symlinks
ls -la .claude/commands/
ls -la .claude/skills/
# Should show -> pointing to ../../claude-skills-library/...

# 3. Check root docs
ls -1 *.md
# Should show: CLAUDE.md, PROJECT_KNOWLEDGE.md, etc.

# 4. Test a command in Claude Code
/docs.search "test"
# Should work without errors

# 5. Check git status
git status
# Should show new files ready to commit
```

## Common Issues & Fixes

### "Command not found"
**Problem:** `/docs.log` or other commands don't work
**Fix:** Symlinks might be wrong. Check they point to correct relative path.

### "Submodule empty"
**Problem:** `claude-skills-library/` directory exists but is empty
**Fix:** Run `git submodule update --init --recursive`

### "Permission denied"
**Problem:** Can't create symlinks
**Fix:** Check file permissions, may need to use sudo on Linux

### "Symlinks show as modified in git"
**Problem:** Git shows symlinks as always modified
**Fix:** This is normal on some systems. They should still work.

## Next Steps After Setup

Once setup is complete:

1. **Read the docs:** Start with `CLAUDE.md`
2. **Start your first feature:** `/speckit.specify`
3. **Follow the REQUIRED workflow:**
   ```
   /speckit.specify
   /speckit.clarify     ⚠️ REQUIRED - Do NOT skip!
   /speckit.plan
   /speckit.tasks
   /speckit.analyze     ⚠️ REQUIRED - Do NOT skip!
   /speckit.checklist   ⚠️ REQUIRED - Do NOT skip!
   /speckit.implement
   ```
4. **Log as you go:** `/docs.log "description"` frequently
5. **Complete when done:** `/docs.complete`

### ⚠️ CRITICAL: Required Spec-Kit Checkpoints

**Three commands are mandatory quality gates:**

1. **`/speckit.clarify`** - Run AFTER /speckit.specify, BEFORE /speckit.plan
   - Identifies underspecified areas
   - Prevents wasted planning effort on incomplete specs
   - **Skipping this = building on shaky foundation**

2. **`/speckit.analyze`** - Run AFTER /speckit.tasks, BEFORE /speckit.implement
   - Cross-artifact consistency check
   - Catches misalignments before building
   - **Skipping this = implementing wrong requirements**

3. **`/speckit.checklist`** - Run AFTER /speckit.tasks
   - Generates quality validation checklist
   - "Unit tests for English" - validates completeness
   - **Skipping this = no acceptance criteria**

**These are not optional** - they catch issues early and save time!

---

**Ready?** Copy the prompt above and paste it into Claude Code in your drop forge project!
