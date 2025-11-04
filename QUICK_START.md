# Quick Start Guide - Claude Skills Library

Get started with reusable Claude skills in 5 minutes!

## 🎯 What You'll Learn

- Copy skills to your project
- Use a skill to guide Claude
- Customize a template for your needs
- Create your first custom skill

## 📥 Step 1: Copy Skills to Your Project (1 minute)

### For Claude Code (VSCode Extension)

```bash
# Navigate to your project
cd your-project

# Create skills directory if it doesn't exist
mkdir -p .claude/skills

# Copy generic skills (work everywhere)
cp claude-skills-library/generic/*.md .claude/skills/

# Copy framework-specific skills (optional)
cp claude-skills-library/flutter/*.md .claude/skills/  # If using Flutter
```

### For Claude Chat / API

Simply keep the `claude-skills-library` folder handy and reference skills in your prompts.

## 🚀 Step 2: Use Your First Skill (2 minutes)

### Example: Test-Driven Development

**Scenario:** You need to implement a new feature.

**Option A: Let Claude decide (recommended)**
```
You: "Implement a user authentication feature"
Claude: I'm using the test-driven-development skill to guide this implementation...
Claude: Step 1 - RED: Writing failing test first...
```

**Option B: Explicit request**
```
You: "Use the test-driven-development skill to implement user authentication"
Claude: Following TDD workflow...
```

**What happens:**
1. Claude writes a failing test FIRST
2. Verifies the test fails correctly
3. Writes minimal code to pass
4. Refactors when needed
5. Repeats for next feature

**Result:** You get well-tested code that actually works!

### Example: Git Worktrees

**Scenario:** You want to work on a feature in isolation.

```
You: "Set up an isolated workspace for implementing the payment feature"
Claude: I'm using the using-git-worktrees skill...
Claude: Checking for existing worktree directory...
Claude: Creating worktree at .worktrees/payment-feature...
Claude: Running npm install...
Claude: Tests passing (42 tests). Ready to implement!
```

**What you get:**
- Isolated git workspace
- No need to stash current work
- Dependencies installed
- Tests verified
- Clean baseline

## 🎨 Step 3: Customize a Template (2 minutes)

### Example: Activity Logging

**Scenario:** You want to add audit logging to your app.

**1. Copy the template:**
```bash
cp claude-skills-library/templates/activity-logging-template.md \
   .claude/skills/activity-logging.md
```

**2. Customize for your project:**

Edit `.claude/skills/activity-logging.md`:

```markdown
## Step 1: Define Activity Types

In YOUR project, edit `src/types/ActivityType.ts`:

```typescript
export enum ActivityType {
  USER_CREATED = 'user_created',
  USER_UPDATED = 'user_updated',
  ORDER_PLACED = 'order_placed',
  PAYMENT_PROCESSED = 'payment_processed',
}
```

## Step 2: Create Activity Log Model

In YOUR project, create `src/models/ActivityLog.ts`:

```typescript
export interface ActivityLog {
  id: string;
  type: ActivityType;
  actorId: string;
  // ... (rest of your model)
}
```
```

**3. Use your customized skill:**
```
You: "Add activity logging to order creation"
Claude: Using activity-logging skill...
Claude: Following your project's pattern from activity-logging.md...
```

## ✍️ Step 4: Create Your First Custom Skill (5 minutes)

### Example: Your Code Review Checklist

**1. Create the file:**
```bash
touch .claude/skills/code-review-checklist.md
```

**2. Add content:**
```markdown
---
name: code-review-checklist
description: Our team's code review checklist - ensures consistent review quality
---

# Code Review Checklist

## Description
Systematic checklist for reviewing pull requests in our project.

## When to Use
- Reviewing pull requests
- Pre-commit self-review
- Pair programming sessions

## Checklist

### Code Quality
- [ ] No commented-out code
- [ ] No console.log/print statements
- [ ] Consistent naming conventions
- [ ] Functions are small and focused
- [ ] No duplicated code

### Testing
- [ ] All tests pass locally
- [ ] New code has tests
- [ ] Edge cases covered
- [ ] No skipped tests without reason

### Security
- [ ] No secrets in code
- [ ] Input validation present
- [ ] SQL injection prevention
- [ ] XSS prevention

### Performance
- [ ] No N+1 queries
- [ ] Large lists are paginated
- [ ] Images are optimized
- [ ] Database queries use indexes

### Documentation
- [ ] README updated if needed
- [ ] Complex logic has comments
- [ ] API changes documented
- [ ] Breaking changes noted

## Usage

Run through checklist, noting any issues found.
Provide constructive feedback with examples.
```

**3. Use it:**
```
You: "Review this pull request"
Claude: Using code-review-checklist skill...
Claude: Going through checklist systematically...
```

## 🎓 What to Try Next

### Beginner: Use More Generic Skills

```bash
# Brainstorming a feature design
"Use brainstorming skill to help me design a notification system"

# Finishing up work
"I'm done implementing. What should I do next?"
# → Claude uses finishing-a-development-branch skill automatically
```

### Intermediate: Combine Skills

```bash
# Start with brainstorming, then worktree, then TDD
"Help me design and implement a search feature"
# → Claude: brainstorming → git-worktrees → test-driven-development
```

### Advanced: Create Skill Chains

Create a "new feature workflow" skill that references other skills:

```markdown
---
name: new-feature-workflow
description: Our complete workflow for adding a new feature
---

# New Feature Workflow

## Step 1: Design Phase
Use the **brainstorming** skill to refine the feature design.

## Step 2: Setup Workspace
Use the **using-git-worktrees** skill to create isolated workspace.

## Step 3: Implementation
Use the **test-driven-development** skill for all code.

## Step 4: Review
Use the **code-review-checklist** skill before submitting PR.

## Step 5: Complete
Use the **finishing-a-development-branch** skill to merge/PR.
```

## 📚 Skill Reference

| When You Need... | Use This Skill |
|------------------|----------------|
| To design a feature | `brainstorming` |
| To work in isolation | `using-git-worktrees` |
| To implement with tests | `test-driven-development` |
| To finish your work | `finishing-a-development-branch` |
| Mobile-first Flutter UI | `mobile-first-design` |
| Test Flutter Cubits | `cubit-testing` |
| Add audit logging | `activity-logging` (template) |
| Add i18n/l10n | `localization-workflow` (template) |
| Specialized inputs | `specialized-input` (template) |
| Navigate codebase | `clean-architecture-navigation` (template) |

## 🐛 Troubleshooting

### "Claude isn't using my skill"

**Check:**
- Skill is in `.claude/skills/` directory
- File has `.md` extension
- YAML frontmatter is present
- `description` says when to use it

**Try:**
- Explicitly ask: "Use the [skill-name] skill"
- Restart VSCode/Claude Code

### "Skill has errors in my project"

**Templates need customization!**
- Replace example code with your project's code
- Update file paths
- Adapt to your architecture
- Test in a small area first

### "How do I share with my team?"

**Commit to git:**
```bash
git add .claude/skills/
git commit -m "Add Claude skills for team"
git push
```

Team members pull and automatically have access!

## 🎉 Success!

You now know how to:
- ✅ Copy and use skills
- ✅ Customize templates
- ✅ Create your own skills
- ✅ Combine skills into workflows

**Next Steps:**
- Browse all skills in `claude-skills-library/`
- Read [full documentation](README.md)
- Create project-specific skills
- Share with your team!

## 💡 Pro Tips

1. **Start small** - Use 1-2 skills first, add more as needed
2. **Customize gradually** - Templates work better when tailored
3. **Document patterns** - Turn repeated workflows into skills
4. **Share with team** - Skills = shared knowledge
5. **Iterate** - Refine skills as you use them

---

**Questions?** Check the [full README](README.md) or open an issue!

**Ready to level up?** Browse all skills and templates in the library.
