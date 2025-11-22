---
description: Run complete SpecKit workflow with mandatory quality gates (clarify, analyze, checklist)
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Goal: Execute the complete SpecKit implementation workflow with all mandatory quality gates to ensure specification clarity, consistency, and completeness before implementation.

**⚠️ MANDATORY WORKFLOW - ALL STEPS REQUIRED**

This workflow enforces the three mandatory quality gates:
1. **`/speckit.clarify`** - Identify and resolve underspecified areas
2. **`/speckit.analyze`** - Cross-artifact consistency & coverage analysis
3. **`/speckit.checklist`** - Generate custom quality validation checklist

**📋 EXPLICIT PROGRESS TRACKING**

This workflow uses **explicit progress marking** via `.speckit-progress.json`:
- Progress is tracked by Claude explicitly marking phases complete via `update-progress.sh`
- Phase completion is NOT inferred from file existence (spec.md, plan.md, etc.)
- Rationale: Files may exist from partial/abandoned work - explicit marking ensures Claude completed the phase
- Each phase MUST call `update-progress.sh` after successful completion
- Phase 0 detection reads ONLY from `.speckit-progress.json`, never from directory checks

## Execution Steps

**Phase 0: Progress Detection (Auto-Resume)**

1. Get feature directory and read progress tracking file:
   - Run `.specify/scripts/bash/check-prerequisites.sh --json --paths-only` from repo root
   - Parse JSON output to get paths: `FEATURE_DIR`, `FEATURE_SPEC`, `IMPL_PLAN`, `TASKS`
   - Check if `$FEATURE_DIR/.speckit-progress.json` exists
   - If progress file exists, read it to get phase completion status
   - If progress file doesn't exist, create it with all phases marked incomplete using `update-progress.sh`

2. **IMPORTANT**: Progress detection MUST read ONLY from `.speckit-progress.json`:
   - DO NOT infer completion from file existence (spec.md, plan.md, etc.)
   - DO NOT check directories (contracts/, checklists/, etc.)
   - ONLY trust `phases.<phase_name>.completed` boolean in progress file
   - Rationale: Files may exist from partial work, but completion requires explicit marking by Claude

3. Display progress status based SOLELY on progress file:
   ```
   📊 SpecKit Progress Detection

   Reading from: specs/008-combat-system/.speckit-progress.json

   Phase Status (from progress file):
   ├─ [✅/❌] Specification
   │  └─ Completed: <true/false> at <timestamp or "not started">
   ├─ [✅/❌] Clarification
   │  └─ Completed: <true/false> at <timestamp or "not started">
   ├─ [✅/❌] Planning
   │  └─ Completed: <true/false> at <timestamp or "not started">
   ├─ [✅/❌] Tasks
   │  └─ Completed: <true/false> at <timestamp or "not started">
   ├─ [✅/❌] Analysis (MANDATORY)
   │  └─ Completed: <true/false> at <timestamp or "not started">
   ├─ [✅/❌] Checklist (MANDATORY)
   │  └─ Completed: <true/false> at <timestamp or "not started">
   └─ [✅/❌] Implementation
      └─ Completed: <true/false> at <timestamp or "not started">

   Resume from: [First phase with completed=false]
   ```

4. Skip completed phases and proceed to first incomplete phase

**Phase 1: Specification (if needed)**

1. Check progress file `phases.specification.completed`:
   - If true, display: "✅ Specification already complete - skipping"
   - Otherwise, run `/speckit.specify $ARGUMENTS`
   - **AFTER COMPLETION**: Update progress file:
     ```bash
     .specify/scripts/bash/update-progress.sh specification
     ```

**Phase 2: Clarification (MANDATORY - Skip if already done)**

2. Check progress file `phases.clarification.completed`:
   - If true, display: "✅ Clarification already complete - skipping"
   - Otherwise, run **`/speckit.clarify`**:
     - This is a MANDATORY step - DO NOT SKIP
     - Resolve all critical ambiguities before planning
     - Up to 5 targeted questions to eliminate underspecified areas
     - Questions must be high-impact (affecting architecture, data model, UX, etc.)
     - Each answer immediately integrated into spec
     - If user tries to skip, warn: "Skipping clarification increases rework risk. Proceed anyway? (yes/no)"
   - **AFTER COMPLETION**: Update progress file:
     ```bash
     .specify/scripts/bash/update-progress.sh clarification questions_asked=<N> questions_answered=<N>
     ```

**Phase 3: Planning (Skip if already done)**

3. Check progress file `phases.planning.completed`:
   - If true, display: "✅ Planning already complete - skipping"
   - Otherwise, run **`/speckit.plan`**:
     - Generate implementation plan from clarified specification
     - Creates plan.md with architecture, patterns, and design decisions
     - Establishes technical approach and component breakdown
   - **AFTER COMPLETION**: Update progress file:
     ```bash
     .specify/scripts/bash/update-progress.sh planning
     ```

**Phase 4: Task Generation (Skip if already done)**

4. Check progress file `phases.tasks.completed`:
   - If true, display: "✅ Tasks already generated - skipping"
   - Otherwise, run **`/speckit.tasks`**:
     - Generate actionable, dependency-ordered tasks.md
     - Each task specific, measurable, and implementable
     - Includes acceptance criteria and validation steps
   - **AFTER COMPLETION**: Update progress file:
     ```bash
     .specify/scripts/bash/update-progress.sh tasks task_count=<N>
     ```

**Phase 5: Analysis (MANDATORY - Skip if already done)**

5. Check progress file `phases.analysis.completed`:
   - If true, display: "✅ Analysis already complete - skipping"
   - Otherwise, run **`/speckit.analyze`**:
     - This is a MANDATORY step - DO NOT SKIP
     - Cross-artifact consistency check across spec.md, plan.md, and tasks.md
     - Coverage analysis to ensure all requirements addressed
     - Identifies gaps, contradictions, and missing elements
     - Must pass before proceeding to checklist phase
     - If critical issues found, must resolve before continuing
   - **AFTER COMPLETION**: Update progress file:
     ```bash
     .specify/scripts/bash/update-progress.sh analysis
     ```

**Phase 6: Quality Checklist (MANDATORY - Skip if already done)**

6. Check progress file `phases.checklist.completed`:
   - If true, display: "✅ Checklist already complete - skipping"
   - Otherwise, run **`/speckit.checklist`**:
     - This is a MANDATORY step - DO NOT SKIP
     - Generate custom validation checklist (like "unit tests for English")
     - Validates requirements completeness, clarity, and consistency
     - Each checklist item must be verifiable
     - Review checklist with user before proceeding to implementation
   - **AFTER COMPLETION**: Update progress file:
     ```bash
     .specify/scripts/bash/update-progress.sh checklist 'artifacts=["checklists/requirements.md"]'
     ```

**Phase 7: Implementation**

7. Run **`/speckit.implement`**:
   - Execute implementation based on validated tasks.md
   - All quality gates passed - ready for development
   - Follow task order, mark progress, update docs
   - **MANDATORY**: Include tests for all new functionality
     - Every new component/feature must have corresponding test suite
     - Use appropriate testing framework for your language/platform:
       - **Godot/GDScript**: gdUnit4 tests extending `GdUnitTestSuite`
       - **Flutter/Dart**: Widget tests with `flutter_test` package
       - **JavaScript/TypeScript**: Jest, Vitest, or framework-specific test runners
       - **Python**: pytest or unittest
       - **Other**: Follow project testing conventions
     - Test file location: Follow project testing conventions (e.g., `test/`, `__tests__/`, etc.)
     - Verify tests pass before marking implementation complete
   - **AFTER COMPLETION**: Update progress file:
     ```bash
     .specify/scripts/bash/update-progress.sh implementation
     ```

## Quality Gate Enforcement

**CRITICAL**: The following steps CANNOT be skipped:

- ❌ **Cannot skip `/speckit.clarify`** - Prevents misaligned implementations
- ❌ **Cannot skip `/speckit.analyze`** - Ensures artifact consistency
- ❌ **Cannot skip `/speckit.checklist`** - Validates completeness

If user attempts to skip any mandatory step, respond:

```
⚠️ MANDATORY QUALITY GATE

This step cannot be skipped. It prevents:
- [clarify] Ambiguous requirements leading to rework
- [analyze] Inconsistent artifacts and missing coverage
- [checklist] Incomplete or unclear specifications

Skipping this gate historically increases implementation time by 2-3x.
Proceed with this mandatory step? (Will take ~5 minutes)
```

## Behavior Rules

- **Never skip mandatory steps** - clarify, analyze, checklist are non-negotiable
- **Stop and fix** if analyze phase reveals critical issues
- **User approval required** before proceeding to implementation phase
- **Early termination allowed** only before implementation phase
- **Document all decisions** made during clarification phase
- **Track progress** through each phase for visibility
- **Report completion** with summary of coverage, decisions, and next steps

## Success Criteria

Workflow complete when:
- ✅ Specification clarified (all critical ambiguities resolved)
- ✅ Plan generated (architecture and approach defined)
- ✅ Tasks created (actionable, dependency-ordered)
- ✅ Analysis passed (no critical consistency issues)
- ✅ Checklist validated (completeness confirmed)
- ✅ Tests written and passing (mandatory for all new functionality)
- ✅ Ready for implementation (all quality gates passed)

## Output Format

**At start (Phase 0), always display detection results:**

```
📊 SpecKit Progress Detection

Completed Steps:
├─ ✅ Specification (spec.md found)
├─ ✅ Clarification (clarification section found)
├─ ✅ Planning (plan.md found)
├─ ✅ Tasks (tasks.md found)
├─ ❌ Analysis (contracts/ not found) ← NEXT
└─ ✅ Checklist (checklists/requirements.md found)

Resuming from: Phase 5 (Analysis)
```

**After completion, provide:**

```
🎯 SpecKit Workflow Complete

Phase Results:
├─ Specification: ✅ [path/to/spec.md] (existing/new)
├─ Clarification: ✅ [skipped/N questions answered]
├─ Planning: ✅ [path/to/plan.md] (existing/new)
├─ Tasks: ✅ [path/to/tasks.md] (existing/new)
├─ Analysis: ✅ [skipped/PASSED - no critical issues]
└─ Checklist: ✅ [skipped/N validation items]

Ready for implementation: YES

Next: Run individual implementation tasks or let /speckit.implement handle execution.
```

If any phase fails, report:

```
⚠️ Quality Gate Failed: [Phase Name]

Issue: [Description of failure]
Impact: [What this means for implementation]
Action Required: [How to resolve]

Workflow paused - resolve issue before proceeding.
```

## Context

User context/arguments: $ARGUMENTS

**Remember**: This workflow enforces quality through mandatory gates. Do not compromise on clarify, analyze, or checklist steps - they save significantly more time than they cost.
