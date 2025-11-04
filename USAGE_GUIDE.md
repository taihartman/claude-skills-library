# Claude Skills Library - Usage Guide

## 📖 Table of Contents

- [What Are Claude Skills?](#what-are-claude-skills)
- [Quick Start by Platform](#quick-start-by-platform)
- [Skill Types Explained](#skill-types-explained)
- [How to Use Skills](#how-to-use-skills)
- [Customizing Templates](#customizing-templates)
- [Creating Your Own Skills](#creating-your-own-skills)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## What Are Claude Skills?

Claude Skills are **structured markdown documents** that act as executable workflows for Claude. Think of them as:

- 📋 **Step-by-step playbooks** for common development tasks
- 🎯 **Decision frameworks** that ensure consistency
- 📚 **Knowledge repositories** that capture best practices
- 🤖 **Automation guides** that Claude can follow autonomously

### Why Use Skills?

**Without Skills:**
```
You: "Implement user authentication"
Claude: *implements directly, may miss best practices*
You: "Don't forget tests!"
Claude: *adds tests after the fact*
```

**With Skills:**
```
You: "Implement user authentication"
Claude: Following test-driven-development skill...
Claude: Writing failing test first...
Claude: Test fails correctly (expected). Now implementing...
Claude: All tests pass. Implementation complete.
```

---

## Quick Start by Platform

### Claude Code (VSCode Extension)

**Setup (30 seconds):**

```bash
# Navigate to your project
cd /path/to/your/project

# Create skills directory
mkdir -p .claude/skills

# Copy skills you want
cp /path/to/claude-skills-library/generic/*.md .claude/skills/
cp /path/to/claude-skills-library/flutter/*.md .claude/skills/  # If using Flutter
```

**That's it!** Claude Code automatically detects skills in `.claude/skills/`.

**Usage:**
- Claude will proactively use skills when tasks match
- You can explicitly ask: "Use the test-driven-development skill"
- Reference in memory: "Follow TDD workflow from now on"

### Claude Chat (claude.ai)

**Setup:**

1. **Copy skill content** from this library
2. **Paste into chat** with instruction:
   ```
   Here's a skill I want you to use. Follow this workflow when I ask:

   [Paste skill markdown here]
   ```
3. **Reference later**: "Use the TDD skill we discussed"

**Pro tip:** Use Projects feature to permanently attach skills.

### Claude API / Custom Apps

**Option 1: System Prompt**
```python
skill_content = open('path/to/skill.md').read()
messages = [{
    "role": "system",
    "content": f"You have access to this skill:\n\n{skill_content}"
}]
```

**Option 2: Few-Shot Examples**
```python
messages = [
    {"role": "user", "content": "Here's how to do X: [skill content]"},
    {"role": "assistant", "content": "I'll follow that workflow"},
    {"role": "user", "content": "Now do X for my project"}
]
```

### Claude Desktop App

**Setup:**

1. Create `~/.claude/skills/` directory
2. Copy skills to this directory
3. Reference in conversations

**Note:** Skill auto-detection varies by version. Explicitly reference skills if needed.

---

## Skill Types Explained

### 🌍 Generic Skills

**What:** Universal workflows that work across any language/framework
**Examples:** TDD, Git workflows, brainstorming
**Usage:** Copy directly, use as-is

**Files:**
- `generic/brainstorming.md`
- `generic/using-git-worktrees.md`
- `generic/test-driven-development.md`
- `generic/finishing-a-development-branch.md`

### 📱 Framework-Specific Skills

**What:** Workflows for specific tech stacks (Flutter, React, etc.)
**Examples:** Mobile-first Flutter design, BLoC testing
**Usage:** Copy if using that framework

**Files:**
- `flutter/mobile-first-design.md` - Flutter UI patterns
- `flutter/cubit-testing.md` - BLoC/Cubit testing

### 🔧 Adaptable Templates

**What:** Pattern templates requiring customization
**Examples:** Activity logging, i18n, clean architecture
**Usage:** Copy, rename, customize for your project

**Files:**
- `templates/activity-logging-template.md`
- `templates/localization-workflow-template.md`
- `templates/clean-architecture-navigation-template.md`

**Key Difference:**
- Generic/Framework skills → Use directly
- Templates → Customize first

---

## How to Use Skills

### Method 1: Proactive Use (Recommended)

Claude automatically uses skills when it detects matching work:

**Example:**
```
You: "I need to implement expense tracking with audit logging"
Claude: I'm using the activity-logging skill to guide this implementation.
Claude: Step 1: Defining activity types...
```

**How it works:**
- Claude reads skill descriptions (YAML frontmatter)
- Matches your request to skill's "When to Use" section
- Follows skill workflow autonomously

### Method 2: Explicit Reference

Directly ask Claude to use a specific skill:

```
You: "Use the test-driven-development skill to implement this"
Claude: Following TDD workflow from test-driven-development skill...
```

**When to use:**
- Claude doesn't auto-select the right skill
- You want to ensure a specific workflow
- Teaching Claude your preferences

### Method 3: Consultation Mode

Ask about skills without full execution:

```
You: "What's the TDD skill's approach to failing tests?"
Claude: According to the test-driven-development skill, if a test passes
        immediately, that means you're testing existing behavior. You should
        fix the test to fail correctly first.
```

**When to use:**
- Learning about workflows
- Checking specific steps
- Understanding best practices

---

## Customizing Templates

Templates require customization before use. Here's how:

### Step-by-Step Template Customization

**1. Copy Template**
```bash
cp claude-skills-library/templates/activity-logging-template.md \
   .claude/skills/activity-logging.md
```

**2. Remove "-template" from Filename**
- `activity-logging-template.md` → `activity-logging.md`
- Makes it a "real" skill that Claude will use

**3. Customize Content**

Find and replace placeholders:

**Example (Activity Logging):**

❌ **Before (Template):**
```markdown
## Step 1: Define Activity Types

Create an enum for your activity types:

```typescript
enum ActivityType {
  ENTITY_CREATED = 'entity_created',
  // ...
}
```

✅ **After (Customized for Your Project):**
```markdown
## Step 1: Define Activity Types

In `src/domain/activity/ActivityType.ts`:

```typescript
export enum ActivityType {
  ORDER_CREATED = 'order_created',
  ORDER_SHIPPED = 'order_shipped',
  ORDER_CANCELLED = 'order_cancelled',
  // Your actual activity types
}
```

**What to Customize:**
- [ ] File paths → Your project structure
- [ ] Code examples → Your language/framework
- [ ] Naming conventions → Your project standards
- [ ] Import statements → Your actual imports
- [ ] Comments → Remove "template" language

**4. Update "When to Use"**

Make it specific to your project:

❌ **Generic:** "Adding state-changing operations"
✅ **Specific:** "Creating/updating/deleting orders in our e-commerce system"

**5. Test the Skill**

Ask Claude to use it:
```
You: "Use the activity-logging skill to add audit logging to order creation"
Claude: Following activity-logging workflow...
[Should reference YOUR project specifics]
```

### Template Customization Checklist

For each template:

- [ ] Copy to `.claude/skills/` and remove `-template` suffix
- [ ] Replace file paths with your project's paths
- [ ] Update code examples to your language/framework
- [ ] Change naming conventions to match your project
- [ ] Customize "When to Use" section
- [ ] Update any project-specific references
- [ ] Test with Claude to verify it works

---

## Creating Your Own Skills

### Anatomy of a Great Skill

```markdown
---
name: my-skill-name
description: Short description triggering this skill (Claude reads this!)
category: generic|flutter|template
framework: any|flutter|react|etc (optional)
---

# Skill Title

## Description
2-3 sentences: what this does and why it's useful

## When to Use
- Specific trigger 1
- Specific trigger 2
- Specific trigger 3

## Core Philosophy
One guiding principle sentence

## Workflow

### Step 1: [Action Verb] [What]
Clear instructions with code examples

### Step 2: [Action Verb] [What]
More instructions...

## Best Practices
✅ DO: ...
❌ DON'T: ...

## Troubleshooting
Problem: ...
Solution: ...
```

### Writing Effective Skills

**✅ DO:**

1. **Use concrete examples:**
   ```typescript
   // ✅ Good
   const user = await authService.login(email, password);

   // ❌ Bad
   // Call the login method
   ```

2. **Include decision frameworks:**
   ```markdown
   **Choose validation strategy:**
   - Small forms (< 5 fields) → Inline validation
   - Large forms (> 5 fields) → Submit validation
   - Real-time needs → Debounced validation
   ```

3. **Add troubleshooting:**
   ```markdown
   **Problem:** Test passes immediately
   **Solution:** You're testing existing behavior. Modify test to fail first.
   ```

4. **Use checklists:**
   ```markdown
   Before marking complete:
   - [ ] All tests pass
   - [ ] Linting succeeds
   - [ ] Documentation updated
   ```

**❌ DON'T:**

1. **Be too abstract:**
   ```markdown
   ❌ Configure the system appropriately
   ✅ Add API_KEY to .env file:
      API_KEY=your_key_here
   ```

2. **Skip examples:**
   ```markdown
   ❌ Handle errors properly
   ✅ Wrap in try-catch:
      try {
        await operation();
      } catch (error) {
        logger.error(error);
        throw new CustomError(error.message);
      }
   ```

3. **Forget "When to Use":**
   ```markdown
   ❌ [No "When to Use" section]
   ✅ ## When to Use
      - Adding database migrations
      - Modifying table schemas
      - Rolling back failed deployments
   ```

### Skill Quality Checklist

Before sharing a skill:

- [ ] YAML frontmatter with `name` and `description`
- [ ] Clear "When to Use" section (3-5 specific triggers)
- [ ] Step-by-step workflow with numbered steps
- [ ] Concrete code examples (not pseudocode)
- [ ] Best practices section (DO/DON'T)
- [ ] Troubleshooting section
- [ ] Decision checklists where applicable
- [ ] Tested by using it in a real scenario
- [ ] No project-specific details (for generic skills)

---

## Best Practices

### Organizing Skills in Your Project

**Recommended Structure:**

```
.claude/
├── skills/
│   ├── README.md                    # Index of your skills
│   ├── brainstorming.md             # From library
│   ├── test-driven-development.md   # From library
│   ├── our-code-review.md           # Your custom skill
│   └── our-deployment.md            # Your custom skill
├── commands/
│   └── my-commands.md
└── memory/
    └── conversation-context.md
```

**Tips:**
- Keep library skills separate from custom skills
- Document which skills are custom vs. from library
- Version control your `.claude/` directory
- Share skills across team via Git

### Skill Maintenance

**Update Skills When:**
- Project architecture changes
- New tools/frameworks adopted
- Best practices evolve
- Team feedback identifies gaps

**Version Skills:**
```markdown
---
name: my-skill
version: 2.0.0  # Add version
last-updated: 2025-01-04
---
```

### Team Collaboration

**Share Skills:**
1. Commit `.claude/skills/` to Git
2. Add README explaining each skill
3. Include in onboarding docs
4. Review/update in team meetings

**Contribute Back:**
- Found a bug? Fix and PR to this library
- Created a great skill? Share it
- Improved a template? Contribute enhancement

---

## Troubleshooting

### "Claude isn't using my skill"

**Check:**
1. ✅ Skill is in `.claude/skills/` directory
2. ✅ YAML frontmatter is valid and present
3. ✅ `description` clearly indicates when to use
4. ✅ Task matches "When to Use" section

**Try:**
- Explicitly ask: "Use the [skill-name] skill"
- Check YAML syntax (indentation matters!)
- Restart Claude Code / reload window
- Verify file ends in `.md`

### "Skill doesn't match my project"

**For Generic Skills:**
- Should work as-is across projects
- If not, check if it's actually a template

**For Templates:**
- Templates MUST be customized first
- See "Customizing Templates" section above
- Replace all placeholders with your specifics

**For Framework Skills:**
- Ensure you're using the right framework
- Flutter skills need Flutter project
- May need adaptation for your version

### "Claude references wrong file paths"

**Cause:** Skill has project-specific paths

**Solution:**
1. Edit skill file
2. Replace specific paths with your paths:
   ```markdown
   ❌ lib/features/auth/  → src/auth/
   ✅ src/auth/ (your actual path)
   ```
3. Use relative paths: `src/` not `/home/user/project/src/`

### "I want to modify a library skill"

**Best Practice:**
1. Copy to new filename: `test-driven-development-custom.md`
2. Modify the copy
3. Keep original for reference
4. Update your project's skill index

**Why?**
- Preserves original for comparison
- Easy to update from library later
- Clear what's custom vs. standard

### "Skills conflict with each other"

**Example:** TDD skill says "write tests first" but your project skill says "prototype first"

**Solutions:**
1. **Remove conflicting skill** from `.claude/skills/`
2. **Merge into hybrid skill** combining both approaches
3. **Explicitly choose:** "Use TDD skill, ignore prototype-first"
4. **Context-specific:** Keep both, specify when to use each

---

## Advanced Usage

### Chaining Skills

Skills can reference other skills:

```markdown
## Step 5: Complete the Work

Use the finishing-a-development-branch skill to complete this work:
- Merge to main, or
- Create PR, or
- Keep branch as-is
```

**Enables:** Complex workflows built from simple skills

### Conditional Skills

Skills can have conditional logic:

```markdown
## Step 2: Choose Testing Strategy

**If unit test:** Follow unit-testing skill
**If integration test:** Follow integration-testing skill
**If E2E test:** Follow e2e-testing skill
```

### Skill Composition

Create "meta-skills" that orchestrate others:

```markdown
# Feature Implementation Meta-Skill

## Workflow

1. Use brainstorming skill to design
2. Use using-git-worktrees skill to create workspace
3. Use test-driven-development skill to implement
4. Use finishing-a-development-branch skill to complete
```

---

## Next Steps

1. **Browse the catalog** - See [README.md](README.md)
2. **Pick 2-3 skills** - Start with generic skills
3. **Copy to your project** - Set up `.claude/skills/`
4. **Try them out** - Ask Claude to use a skill
5. **Customize as needed** - Adapt templates for your project
6. **Create your own** - Capture your team's workflows
7. **Share back** - Contribute improvements via PR

---

## Resources

- **Main README**: [README.md](README.md) - Full catalog
- **GitHub**: [Link to repo] - Latest version
- **Issues**: [Link] - Report bugs or request skills
- **Discussions**: [Link] - Share your skills

---

**Questions?** Open an issue or start a discussion!
**Created a great skill?** Submit a PR!
**Found this useful?** Star the repo!
