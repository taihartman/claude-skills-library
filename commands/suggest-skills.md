---
description: Analyze current work and suggest relevant Claude skills with workflow recommendations
tags: [productivity, skills, guidance]
---

Analyze the current work context and recommend relevant Claude skills.

## Instructions

### Step 1: Gather Context

**Check active todos** (if TodoWrite has been used):
- Look for task descriptions
- Identify types of work (UI, testing, bug fixes, new features)
- Note file types mentioned (.dart, *_cubit.dart, *_test.dart, etc.)

**Analyze recent conversation** (last 5-10 messages):
- What is the user trying to accomplish?
- What keywords appear? (UI, form, test, localization, currency, activity, etc.)
- What files or components are being discussed?
- What problems are being solved?

### Step 2: Match Keywords to Skills

**IMPORTANT**: This command scans `.claude/skills/` for available skills. Customize the keyword mappings below based on which skills you've installed in your project.

#### Generic Skills (from library)

**read-with-context.md**:
- Keywords: understand, how does, investigate, explore, trace, bug, issue, unclear
- Tasks: "Understand X", "how does Y work", "investigate bug", "trace data flow"

**using-git-worktrees.md**:
- Keywords: feature, branch, isolation, workspace, new feature, parallel work
- Tasks: "Start new feature", "work on separate branch", "isolate work"

**test-driven-development.md**:
- Keywords: new feature, bug fix, TDD, red-green-refactor, test first, implement
- Tasks: "Implement X", "fix bug", "add feature", "refactor"

**finishing-a-development-branch.md**:
- Keywords: complete, done, merge, PR, pull request, finish, ready to merge
- Tasks: "Complete feature", "create PR", "merge branch", "ready to deploy"

**brainstorming.md**:
- Keywords: design, idea, explore, alternatives, refine, socratic
- Tasks: "Design X", "explore options", "refine idea", "need guidance"

#### Flutter Skills (if using Flutter)

**mobile-first-design.md**:
- Keywords: UI, form, layout, page, widget, responsive, mobile, keyboard, scroll, bottom sheet
- File patterns: *_page.dart, *_form*.dart, widgets/
- Tasks: "Create UI", "build form", "fix layout", "design screen"

**cubit-testing.md**:
- Keywords: test, cubit, bloc, mock, state, testing, coverage
- File patterns: *_cubit_test.dart, test/
- Tasks: "Write tests", "test cubit", "add coverage", "fix failing test"

#### Project-Specific Skills (customize this section)

**CUSTOMIZE**: Add your project-specific skills here. Examples:

**activity-logging.md** (if you have this skill):
- Keywords: activity, logging, audit, state change, create, update, delete
- Tasks: "Add logging", "track changes", "audit trail"

**localization-workflow.md** (if you have this skill):
- Keywords: string, text, label, message, localization, l10n, translation
- Tasks: "Add strings", "localize text", "fix hardcoded strings"

**currency-input.md** (if you have this skill):
- Keywords: currency, amount, money, price, payment, input
- Tasks: "Add amount field", "currency input", "monetary field"

### Step 3: Rank Skills by Relevance

Calculate relevance score (0-4 stars):

- **4 stars**: Multiple strong keyword matches + task directly relates to skill
- **3 stars**: Strong keyword match OR task clearly relates
- **2 stars**: Weak keyword match OR might be helpful
- **1 star**: Tangentially related
- **0 stars**: Not relevant

**Only show skills with 2+ stars**

### Step 4: Suggest Workflow Order

Based on typical development workflow:

**Investigation phase** (if understanding needed):
1. read-with-context
2. brainstorming (if designing new approach)

**Setup phase** (if starting new feature):
3. using-git-worktrees (for isolation)

**Development phase**:
4. test-driven-development (always recommended for new code)
5. mobile-first-design (if UI work in Flutter)
6. cubit-testing (if testing Flutter state management)
7. [project-specific skills as appropriate]

**Completion phase**:
8. finishing-a-development-branch (when done)

**Reorder based on what's detected** - put most relevant first.

### Step 5: Output Format

```
📋 Skill Recommendations for Current Work

[If todos exist, show brief summary of what you're working on]
[If no todos, show summary from conversation context]

## Highly Relevant (⭐⭐⭐⭐ or ⭐⭐⭐)

⭐⭐⭐⭐ **[Skill Name]** (`.claude/skills/[filename].md`)
→ [Why it's relevant - 1 line based on context]
→ [What it helps with - 1 line]

⭐⭐⭐ **[Skill Name]** (`.claude/skills/[filename].md`)
→ [Why it's relevant]
→ [What it helps with]

## Potentially Useful (⭐⭐)

⭐⭐ **[Skill Name]** (`.claude/skills/[filename].md`)
→ [Why it might help]

## Suggested Workflow Order

1. **[Skill]** - [Brief reason why first]
2. **[Skill]** - [Brief reason why second]
3. **[Skill]** - [Brief reason why third]
[etc.]

---
💡 **Tip**: Reference skills by saying "I'm using the [skill-name] skill" or "Let's follow the [skill-name] workflow"
```

### Step 6: Handle Edge Cases

**If no clear context** (no todos, unclear conversation):
```
📋 Skill Recommendations

I don't have enough context to suggest specific skills. Here's what I can recommend:

**Tell me what you're working on**, and I'll suggest relevant skills. For example:
- "I'm building a new form UI" → Mobile-First Design (Flutter), TDD
- "I'm fixing a bug" → Read With Context, TDD
- "I'm starting a new feature" → Using Git Worktrees, TDD
- "I need help designing" → Brainstorming

**Or browse all available skills in `.claude/skills/`**:
- brainstorming.md - Refine ideas through Socratic dialogue
- finishing-a-development-branch.md - Complete and merge work
- read-with-context.md - Understand code in context
- test-driven-development.md - TDD workflow
- using-git-worktrees.md - Set up isolated workspaces
- [Plus any Flutter or project-specific skills you've installed]
```

**If only 1-2 skills relevant**:
- Still show the full format
- Be specific about why those skills apply
- Suggest checking others if task changes

## Examples

### Example 1: Building UI Form (Flutter Project)

**Context**: Todos include "Create user form UI", "Add input validation"

**Output**:
```
📋 Skill Recommendations for Current Work

Working on: Creating user form UI with input validation

## Highly Relevant

⭐⭐⭐⭐ **Mobile-First Design** (`.claude/skills/mobile-first-design.md`)
→ You're creating a form UI - needs mobile-first approach
→ Ensures keyboard doesn't hide fields, proper scrolling, responsive layout

⭐⭐⭐⭐ **Test-Driven Development** (`.claude/skills/test-driven-development.md`)
→ New UI component - write tests first
→ Ensures validation logic works correctly

⭐⭐⭐ **Brainstorming** (`.claude/skills/brainstorming.md`)
→ Design the form structure and validation approach
→ Explore different UX patterns before implementing

## Suggested Workflow Order

1. **Brainstorming** - Design the form structure and validation approach
2. **Mobile-First Design** - Design the form layout properly first
3. **Test-Driven Development** - Write tests for form validation
```

### Example 2: Debugging Issue

**Context**: Conversation mentions "payment calculation is wrong"

**Output**:
```
📋 Skill Recommendations for Current Work

Working on: Debugging payment calculation issue

## Highly Relevant

⭐⭐⭐⭐ **Read With Context** (`.claude/skills/read-with-context.md`)
→ Need to understand how payment calculations work
→ Trace data flow and identify where calculation goes wrong

⭐⭐⭐⭐ **Test-Driven Development** (`.claude/skills/test-driven-development.md`)
→ Bug fixes start with failing test reproducing the issue
→ Ensures fix works and prevents regression

## Suggested Workflow Order

1. **Read With Context** - Understand existing payment calculation code
2. **Test-Driven Development** - Write failing test reproducing the bug, then fix
```

### Example 3: Starting New Feature

**Context**: Todo "Implement file upload feature"

**Output**:
```
📋 Skill Recommendations for Current Work

Working on: Implementing file upload feature

## Highly Relevant

⭐⭐⭐⭐ **Using Git Worktrees** (`.claude/skills/using-git-worktrees.md`)
→ New feature - work in isolated workspace
→ Keeps main branch clean while developing

⭐⭐⭐⭐ **Test-Driven Development** (`.claude/skills/test-driven-development.md`)
→ New feature - write tests before implementation
→ Ensures upload, storage, and retrieval work correctly

⭐⭐⭐ **Brainstorming** (`.claude/skills/brainstorming.md`)
→ Design the upload flow and error handling approach
→ Explore different implementation strategies

## Potentially Useful

⭐⭐ **Finishing a Development Branch** (`.claude/skills/finishing-a-development-branch.md`)
→ When feature complete - merge or create PR

## Suggested Workflow Order

1. **Using Git Worktrees** - Set up isolated workspace for this feature
2. **Brainstorming** - Design the upload flow and error handling
3. **Test-Driven Development** - Write tests then implement upload feature
4. **Finishing a Development Branch** - When ready, merge or create PR
```

## Best Practices

**✅ DO:**
- Be specific about why each skill is relevant to the current context
- Only suggest skills with clear applicability (2+ stars)
- Provide actionable workflow order
- Reference actual todo items or conversation context
- Keep descriptions concise (1-2 lines per skill)

**❌ DON'T:**
- Suggest all skills regardless of context
- Be vague ("this might help")
- Overwhelm with too many recommendations
- Ignore the actual work being done
- Suggest skills just to have more results
