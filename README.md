# Claude Skills Library

A curated collection of reusable workflow skills for Claude Code and other Claude-powered development tools. These skills provide systematic, step-by-step workflows for common development tasks, patterns, and best practices.

## 📚 What are Claude Skills?

Claude Skills are structured markdown documents that guide Claude through complex, multi-step workflows. They act as "mini-playbooks" that ensure consistency, best practices, and thoroughness when performing common development tasks.

**Benefits:**
- 🎯 **Consistency** - Same high-quality approach every time
- 📖 **Knowledge Transfer** - Encapsulate best practices and patterns
- 🚀 **Efficiency** - Skip explaining repeated workflows
- 🔄 **Reusability** - Share skills across projects and teams
- 🎓 **Learning** - Built-in documentation and decision frameworks

## 🗂️ Library Organization

```
claude-skills-library/
├── generic/          # Works with any programming language/framework
├── flutter/          # Flutter/Dart-specific workflows
├── hooks/            # Claude Code hooks for automatic quality checks
├── commands/         # Reusable documentation workflow commands
├── templates/        # Adaptable templates for common patterns
├── speckit/          # GitHub Spec-Kit commands (feature development)
└── README.md         # This file
```

## 📦 Skills Catalog

### 🌍 Generic Skills (Universal)

These skills work across any programming language, framework, or project type.

| Skill | Description | Use When |
|-------|-------------|----------|
| **[brainstorming](generic/brainstorming.md)** | Refine rough ideas into fully-formed designs through collaborative questioning | Before writing code or plans; exploring alternatives |
| **[using-git-worktrees](generic/using-git-worktrees.md)** | Create isolated git workspaces with smart directory selection | Starting feature work that needs isolation |
| **[test-driven-development](generic/test-driven-development.md)** | Red-Green-Refactor TDD discipline with iron law enforcement | Implementing any feature or bugfix |
| **[finishing-a-development-branch](generic/finishing-a-development-branch.md)** | Guide completion of work with structured options (merge/PR/keep/discard) | Implementation complete, all tests pass |
| **[read-with-context](generic/read-with-context.md)** | Systematic workflow for understanding code by reading related files with context | Understanding features, tracing data flow, debugging |

### 📱 Flutter-Specific Skills

Specialized workflows for Flutter/Dart development.

| Skill | Description | Use When |
|-------|-------------|----------|
| **[mobile-first-design](flutter/mobile-first-design.md)** | Mobile-first UI implementation with responsive patterns | Creating/refactoring Flutter UI |
| **[cubit-testing](flutter/cubit-testing.md)** | Systematic BLoC/Cubit testing with Mockito | Testing state management |

### 📝 Documentation Workflow Commands

Reusable slash commands for managing project documentation. Symlink these to `.claude/commands/` in your project.

| Command | Description | Use When |
|---------|-------------|----------|
| **[/docs.create](commands/docs.create.md)** | Initialize feature documentation (CLAUDE.md + CHANGELOG.md) | Starting new feature development |
| **[/docs.log](commands/docs.log.md)** | Log changes to feature CHANGELOG.md | After completing significant work |
| **[/docs.update](commands/docs.update.md)** | Update feature architecture documentation | After adding/changing components |
| **[/docs.complete](commands/docs.complete.md)** | Finalize feature and roll up to root CHANGELOG.md | Feature implementation complete |
| **[/docs.validate](commands/docs.validate.md)** | Check documentation quality and consistency | Before merging or periodically |
| **[/docs.search](commands/docs.search.md)** | Search across all project documentation | Finding information in docs |
| **[/docs.init](commands/docs.init.md)** | Initialize root documentation system for new project | Project setup |
| **[/docs.archive](commands/docs.archive.md)** | Archive completed or deprecated features | Cleanup and maintenance |

### 🎯 Productivity Commands

Workflow enhancement commands to improve development efficiency.

| Command | Description | Use When |
|---------|-------------|----------|
| **[/implement-with-speckit](commands/implement-with-speckit.md)** | Run complete SpecKit workflow with mandatory quality gates | Starting full feature implementation from scratch |
| **[/suggest-skills](commands/suggest-skills.md)** | Analyze current work and suggest relevant skills | Need guidance on which skills to use |

**Setup**: Symlink to your project:
```bash
ln -s ../claude-skills-library/commands/docs.create.md .claude/commands/docs.create.md
ln -s ../claude-skills-library/commands/implement-with-speckit.md .claude/commands/implement-with-speckit.md
ln -s ../claude-skills-library/commands/suggest-skills.md .claude/commands/suggest-skills.md
# ... (repeat for other commands)
```

### 📋 Spec-Kit Commands

Structured feature development workflow. **Symlink these to `.claude/commands/` in your project.**

| Command | Description | Use When |
|---------|-------------|----------|
| **[/speckit.specify](speckit/specify.md)** | Create feature specification | Starting new feature |
| **[/speckit.clarify](speckit/clarify.md)** | ⚠️ **REQUIRED BEFORE PLANNING** - Identify underspecified areas | After specify, before plan |
| **[/speckit.plan](speckit/plan.md)** | Generate implementation plan | After clarification |
| **[/speckit.tasks](speckit/tasks.md)** | Generate task breakdown | After plan |
| **[/speckit.analyze](speckit/analyze.md)** | ⚠️ **REQUIRED BEFORE IMPLEMENTING** - Cross-artifact consistency check | After tasks, before implement |
| **[/speckit.checklist](speckit/checklist.md)** | ⚠️ **REQUIRED** - Quality validation checklist ("unit tests for English") | After tasks |
| **[/speckit.implement](speckit/implement.md)** | Execute implementation | After analysis passes |
| **[/speckit.constitution](speckit/constitution.md)** | Define project principles | Project setup |

**⚠️ CRITICAL:** Three commands are **mandatory checkpoints** - do not skip:
1. **/speckit.clarify** - Run BEFORE /speckit.plan (prevents incomplete specs)
2. **/speckit.analyze** - Run AFTER /speckit.tasks, BEFORE /speckit.implement (catches inconsistencies)
3. **/speckit.checklist** - Run to validate completeness (acceptance criteria)

**Setup**: See [DOCUMENTATION_SYSTEM.md](DOCUMENTATION_SYSTEM.md) for complete workflow.

### 🔧 Adaptable Templates

These are pattern templates that need customization for your specific project.

| Template | Description | Frameworks |
|----------|-------------|------------|
| **[project-documentation-structure-template](templates/project-documentation-structure-template.md)** | Complete documentation system (CLAUDE.md, specs/, .claude/ structure) | Any |
| **[activity-logging-template](templates/activity-logging-template.md)** | Add audit trail/activity logging to operations | Any |
| **[localization-workflow-template](templates/localization-workflow-template.md)** | Internationalization (i18n) best practices | React, Vue, Angular, Flutter, etc. |

### 🎣 Claude Code Hooks

Automated quality checks that run at key moments during development. **These implement "automation over reminders" by proactively enforcing best practices.**

| Hook | Triggers | Purpose |
|------|----------|---------|
| **[user-prompt-submit](hooks/user-prompt-submit.md)** | Before Claude sees your message | Auto-injects relevant context based on request keywords (mobile-first, localization, testing, etc.) |
| **[stop-event](hooks/stop-event.md)** | After Claude finishes responding | Quality checks and pattern compliance verification (build errors, formatting, pattern adherence) |
| **[pre-commit](hooks/pre-commit.md)** | Before creating git commits | Final quality gate (analyze, format, tests, pattern warnings, documentation reminders) |

**Setup**: Symlink to your project:
```bash
ln -s ../claude-skills-library/hooks/user-prompt-submit.md .claude/hooks/user-prompt-submit.md
ln -s ../claude-skills-library/hooks/stop-event.md .claude/hooks/stop-event.md
ln -s ../claude-skills-library/hooks/pre-commit.md .claude/hooks/pre-commit.md
```

**For detailed information**: See [hooks/README.md](hooks/README.md) and [hooks/USAGE_GUIDE.md](hooks/USAGE_GUIDE.md)

**Why hooks matter**: Without hooks, skills sit unused, errors slip through, code is inconsistently formatted, and there are no automatic quality checks. Hooks tie everything together by making Claude autonomous in maintaining code quality.

## 🚀 Quick Start

### For Claude Code (VSCode Extension)

**Choose your setup method:**

**Option A: Simple Copy (Quick Start)**
```bash
cp -r claude-skills-library/.claude/skills/* .claude/skills/
```

**Option B: Git Submodule + Symlinks (Recommended for Multi-Project Use)**

For a maintainable setup that stays in sync across projects, see **[SETUP_GUIDE.md](SETUP_GUIDE.md)** for complete instructions on using Git submodules and symlinks.

**Benefits:** Automatic updates, no duplication, version-tracked, single source of truth.

---

**After setup:**

1. **Skills are automatically available** - Claude Code detects them from `.claude/skills/`

2. **Use a skill:**
   - Claude will proactively use skills when appropriate
   - You can reference them: "Use the brainstorming skill to help me design this"

### For Claude Chat / API

1. **Copy skill content** into your prompt
2. **Reference explicitly:** "Follow the test-driven-development workflow"
3. **Or paste inline:** Include the skill markdown in your conversation

### For Project-Specific Customization

**Using Templates:**

1. Copy template to your `.claude/skills/` folder
2. Remove `-template` from filename
3. Customize for your project:
   - Replace placeholder code examples
   - Adapt to your architecture/patterns
   - Update file paths and references
   - Add project-specific details

**Example: Adapting localization-workflow-template**
```bash
# Copy template
cp claude-skills-library/templates/localization-workflow-template.md \
   .claude/skills/localization-workflow.md

# Edit to customize:
# - Update file paths (locales/ → your l10n directory)
# - Change code examples to match your framework
# - Add your project's naming conventions
# - Reference your actual i18n library setup
```

## 📖 How to Use Skills

### Pattern 1: Proactive Use (Recommended)

Claude will automatically use skills when tasks match skill descriptions:

```
You: "I need to implement expense tracking with full audit logging"
Claude: I'm using the activity-logging skill to guide this implementation...
```

### Pattern 2: Explicit Reference

Ask Claude to use a specific skill:

```
You: "Use the test-driven-development skill to implement this feature"
Claude: Following TDD workflow: writing test first...
```

### Pattern 3: Consultation

Reference skills for guidance without full execution:

```
You: "What's the best practice for mobile-first design in Flutter?"
Claude: According to the mobile-first-design skill, you should...
```

## ✍️ Creating Your Own Skills

### Skill Structure

```markdown
---
name: my-skill-name
description: One-sentence description for when Claude should use this
category: generic|framework-specific|template
framework: any|react|flutter|etc (optional)
---

# Skill Title

## Description
Detailed description of what this skill does

## When to Use
- Specific trigger 1
- Specific trigger 2
- Specific trigger 3

## Core Philosophy
One-sentence guiding principle

## Workflow

### Step 1: First Step
Clear instructions with examples

### Step 2: Second Step
More instructions...

## Best Practices
✅ DO: ...
❌ DON'T: ...

## Troubleshooting
Common issues and solutions
```

### Skill Writing Guidelines

**✅ DO:**
- Write step-by-step workflows
- Include concrete code examples
- Provide decision frameworks
- Add troubleshooting sections
- Use clear, imperative language
- Include "When to Use" section
- Add best practices and anti-patterns

**❌ DON'T:**
- Make skills too abstract or vague
- Skip code examples
- Forget error handling
- Assume too much context
- Make steps too large (break them down)

### Good Skill Examples

**Good - Specific and Actionable:**
```markdown
### Step 2: Create Test File
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([MyRepository])
import 'my_test.mocks.dart';
```

Then run: `dart run build_runner build`
```

**Bad - Too Vague:**
```markdown
### Step 2: Set up testing
Create test file and configure mocks
```

## 🤝 Contributing Skills

Want to contribute? Great! Here's how:

1. **Fork this repository**
2. **Create a new skill** following the structure above
3. **Add to appropriate category:**
   - `generic/` - Universal workflows
   - Framework folders - Framework-specific
   - `templates/` - Adaptable patterns
4. **Update this README** with your skill in the catalog
5. **Submit a pull request**

### Skill Quality Checklist

Before submitting:

- [ ] Clear "When to Use" section with 3-5 specific triggers
- [ ] Step-by-step workflow with numbered steps
- [ ] Concrete code examples (not pseudocode)
- [ ] Best practices and anti-patterns section
- [ ] Troubleshooting section with common issues
- [ ] Decision checklists where applicable
- [ ] Tested by using it in a real project
- [ ] YAML frontmatter with name, description, category

## 📂 Skill Categories Explained

### Generic Skills
- Work across any language/framework
- Examples: Git workflows, TDD, brainstorming
- No code assumptions
- Universal best practices

### Framework-Specific Skills
- Tied to specific technology (React, Flutter, Django, etc.)
- Can include framework-specific code
- May reference framework conventions
- Still generalizable within that ecosystem

### Templates
- Patterns that apply broadly but need customization
- Provide structure + adaptation instructions
- Multiple framework examples
- "Fill in the blanks" approach

## 🎓 Learning Path

**New to Claude Skills?** Start here:

1. **Read**: [brainstorming](generic/brainstorming.md) - Understand the format
2. **Use**: [test-driven-development](generic/test-driven-development.md) - See skills in action
3. **Adapt**: Pick a template and customize for your project
4. **Create**: Write your first skill for a repeated workflow

## 🔗 Integration Examples

### VSCode Extension (.claude/skills/)
```bash
.claude/
├── skills/
│   ├── brainstorming.md
│   ├── test-driven-development.md
│   └── my-custom-skill.md
└── commands/
    └── my-commands.md
```

### Project Documentation (docs/)
```bash
docs/
├── workflows/
│   ├── tdd-workflow.md          # From generic/test-driven-development
│   ├── mobile-first.md          # From flutter/mobile-first-design
│   └── our-review-process.md   # Custom
└── patterns/
    └── activity-logging.md      # Adapted from template
```

### Team Knowledge Base
- Copy skills to Notion/Confluence
- Link to specific skills in PR templates
- Reference in onboarding docs
- Use as training materials

## 🆘 Troubleshooting

### "Claude isn't using my skill"

**Check:**
1. Skill file is in `.claude/skills/` directory
2. YAML frontmatter is present and valid
3. `description` field clearly indicates when to use
4. Task matches the "When to Use" section

**Try:**
- Explicitly ask: "Use the [skill-name] skill"
- Check frontmatter syntax (YAML is picky about indentation)
- Restart VSCode/Claude Code

### "Skill doesn't work for my project"

**Solutions:**
1. **Generic skills** should work as-is
2. **Framework skills** need matching framework
3. **Templates** MUST be customized first

Copy template → Remove `-template` suffix → Customize → Use

### "How do I share skills with my team?"

**Options:**
1. **Git repository**: Commit `.claude/skills/` to version control
2. **Documentation site**: Copy to team wiki/docs
3. **Snippet library**: Add to team snippet collection
4. **This repo**: Contribute back via PR!

## 🌟 Real-World Examples

### Example 1: TDD Workflow

**Before Skills:**
```
You: "Implement user authentication"
Claude: *writes implementation code directly*
You: "Wait, you forgot tests!"
Claude: *adds tests after the fact*
```

**With TDD Skill:**
```
You: "Implement user authentication"
Claude: Using test-driven-development skill...
Claude: Writing failing test first: test('should authenticate valid user')
Claude: Test fails correctly. Now implementing minimal code...
```

### Example 2: Mobile-First Design

**Before Skills:**
```
You: "Create expense form"
Claude: *creates form, keyboard hides fields*
You: "The keyboard covers my form fields"
Claude: *adds fixes after debugging*
```

**With Mobile-First Skill:**
```
You: "Create expense form"
Claude: Using mobile-first-design skill...
Claude: Wrapping form in SingleChildScrollView...
Claude: Testing on 375x667px viewport...
```

## 📊 Library Statistics

- **Total Skills**: 10 (5 generic, 2 Flutter, 3 templates)
- **Total Commands**: 8 (documentation workflow)
- **Total Hooks**: 3 (quality automation)
- **Lines of Documentation**: ~10,000+
- **Code Examples**: 100+
- **Workflows Covered**: Development, Testing, Design, Git, i18n, Auditing, Documentation Systems, Code Understanding, Quality Automation

## 🔮 Future Skills (Roadmap)

Considering adding:

- **Database migration workflow** (template)
- **API design and documentation** (generic)
- **Performance optimization** (framework-specific)
- **Security review checklist** (generic)
- **Accessibility testing** (framework-specific)
- **Error handling patterns** (template)
- **Code review guidelines** (generic)
- **Deployment workflow** (template)

Want one of these? Open an issue or PR!

## 📄 License

MIT License - Use freely in your projects, modify as needed, contribute back if you'd like!

## 🙏 Acknowledgments

These skills were developed through real-world usage in production projects. Special thanks to the Claude community for feedback and refinements.

---

**Questions? Issues? Contributions?**

- 📝 Open an issue on GitHub
- 💬 Start a discussion
- 🔧 Submit a PR with improvements
- ⭐ Star this repo if you find it useful!

---

**Version**: 1.0.0
**Last Updated**: 2025-01-04
**Maintained By**: Community-driven
