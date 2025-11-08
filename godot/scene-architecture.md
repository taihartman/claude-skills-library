---
name: godot-scene-architecture
description: Scene composition and organization patterns for scalable Godot projects
category: godot
framework: godot
---

# Godot Scene Architecture Workflow

## Description

Systematic approach to organizing Godot scenes using composition, inheritance, and instancing patterns for maintainable, reusable game architecture.

## When to Use

- Starting a new Godot project
- Creating new game entities (characters, enemies, items)
- Refactoring monolithic scenes
- Building reusable components
- Designing UI systems
- Organizing project structure

## Core Philosophy

**Scene composition over hierarchy depth.** Build complex scenes from small, focused, reusable scenes rather than deep node trees.

## Workflow

### Step 1: Define Scene Root Node Type

Choose the correct root node based on behavior:

```
# Physics-based entities (can move, affected by forces)
RigidBody2D
├── Example: Plinko character, dropped items, projectiles
└── Use when: Object needs physics simulation

# Pathfinding entities (AI-controlled movement)
CharacterBody2D
├── Example: Combat units, NPCs, player (keyboard control)
└── Use when: Object needs controlled movement with collision

# Static physics (doesn't move, but has collision)
StaticBody2D
├── Example: Pegs, walls, platforms, obstacles
└── Use when: Object is physical but stationary

# Triggers and detection zones (no collision, just detection)
Area2D
├── Example: Drop zones, triggers, proximity detection
└── Use when: Need to detect overlapping bodies

# Non-physical scenes (UI, managers, data)
Node2D (for game world positioning)
Control (for UI elements)
Node (for logic/managers)
```

**Decision Framework:**

| Behavior | Root Node |
|----------|-----------|
| Falls with gravity | RigidBody2D |
| Player/AI controlled movement | CharacterBody2D |
| Stationary with collision | StaticBody2D |
| Detection zone | Area2D |
| UI element | Control |
| Logic only | Node |

### Step 2: Build Scene Hierarchy

**Good hierarchy** (flat, focused):

```
Character (RigidBody2D)
├── Sprite2D
├── CollisionShape2D
├── AnimationPlayer
└── Components (Node)
    ├── HealthComponent
    ├── DamageComponent
    └── AbilityComponent
```

**Bad hierarchy** (too deep, monolithic):

```
Character (RigidBody2D)
├── Body (Node2D)
│   ├── Head (Node2D)
│   │   ├── Eyes (Node2D)
│   │   │   ├── LeftEye (Sprite2D)
│   │   │   └── RightEye (Sprite2D)
│   │   └── Mouth (Sprite2D)
│   └── Torso (Sprite2D)
├── Health (Node)
│   ├── CurrentHP (Node)
│   ├── MaxHP (Node)
│   └── Regeneration (Node)
└── ...
```

**Hierarchy Principles:**
- ✅ Keep hierarchy flat (max 3-4 levels deep)
- ✅ Group related logic in component nodes
- ✅ One visual node per visual element (Sprite2D, AnimatedSprite2D)
- ✅ Collision shapes as direct children of physics body
- ❌ Don't nest for organization (use components)
- ❌ Don't create unnecessary container nodes

### Step 3: Component-Based Architecture

Break down functionality into reusable components:

```gdscript
# health_component.gd
class_name HealthComponent
extends Node

signal health_changed(old_health: int, new_health: int)
signal died()

@export var max_health: int = 100
var current_health: int

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	var old = current_health
	current_health = max(0, current_health - amount)
	emit_signal("health_changed", old, current_health)

	if current_health == 0:
		emit_signal("died")

func heal(amount: int) -> void:
	var old = current_health
	current_health = min(max_health, current_health + amount)
	emit_signal("health_changed", old, current_health)
```

**Usage:**

```gdscript
# character.gd
extends RigidBody2D

@onready var health: HealthComponent = $Components/HealthComponent

func _ready() -> void:
	health.died.connect(_on_died)

func hit_by_enemy(damage: int) -> void:
	health.take_damage(damage)

func _on_died() -> void:
	queue_free()
```

**Component Design Principles:**
- ✅ One component = one responsibility
- ✅ Communicate via signals
- ✅ Export configuration variables
- ✅ Can be reused across different entity types
- ❌ Don't reference parent directly (use signals)
- ❌ Don't mix multiple responsibilities

### Step 4: Scene Instancing and Composition

**Build complex scenes from simple scenes:**

```
# Project structure (co-located: scene + script + data together):
main.tscn                        # Entry point (root level)

game/                            # Game systems
├── plinko_board/
│   ├── plinko_board.tscn       # Scene
│   ├── plinko_board.gd         # Script
│   └── drop_zone.gd            # Related script
└── combat_arena/
    ├── combat_arena.tscn
    └── combat_arena.gd

characters/                      # Playable heroes (co-located)
├── rookie/
│   ├── rookie.tscn
│   ├── rookie.gd
│   └── rookie.tres             # Hero data
├── bouncer/
│   ├── bouncer.tscn
│   ├── bouncer.gd
│   └── bouncer.tres
└── lodestone/
    ├── lodestone.tscn
    ├── lodestone.gd
    └── lodestone.tres

entities/                        # Game entities (co-located)
└── peg/
    ├── peg.tscn
    ├── peg.gd
    └── peg.tres (optional data)

ui/                              # UI scenes (co-located when complex)
├── hud/
│   ├── hud.tscn
│   └── hud.gd
└── menu/
    ├── menu.tscn
    └── menu.gd
```

**PlinkoBoard scene (composed):**

```
PlinkoBoard (Node2D)
├── Walls (StaticBody2D) [scene instance]
├── PegGrid (Node2D)
│   ├── WeaponPeg [instance] x10
│   ├── ArmorPeg [instance] x10
│   ├── CompanionPeg [instance] x10
│   └── BuffPeg [instance] x10
├── DropZones (Node2D)
│   ├── DropZone1 [instance]
│   ├── DropZone2 [instance]
│   └── ...
└── BottomZones (Node2D)
    ├── BottomZone1 [instance]
    └── ...
```

**Instancing in code:**

```gdscript
# game/plinko_board/plinko_board.gd
extends Node2D

# Co-located structure paths
const PEG_SCENE: PackedScene = preload("res://entities/peg/peg.tscn")
const CHARACTER: PackedScene = preload("res://characters/rookie/rookie.tscn")

func spawn_pegs() -> void:
	for i in range(10):
		var peg = PEG_SCENE.instantiate()
		peg.position = Vector2(i * 50, 100)
		$PegGrid.add_child(peg)

func spawn_character(pos: Vector2) -> void:
	var char = CHARACTER.instantiate()
	char.position = pos
	add_child(char)
```

**Instancing Principles:**
- ✅ Create reusable scenes for repeated entities
- ✅ Use `preload()` for scenes used frequently
- ✅ Instance with `instantiate()`, add with `add_child()`
- ✅ Configure instance properties after instantiation
- ❌ Don't create everything in one monolithic scene
- ❌ Don't duplicate logic across similar scenes

### Step 5: Scene Inheritance

**Use inheritance for variants:**

```
# Base scene: characters/hero_base/hero_base.tscn (or just use composition)
HeroBase (CharacterBody2D)
├── Sprite2D
├── CollisionShape2D
└── Components (Node)
    └── HealthComponent

# Co-located variant: characters/rookie/rookie.tscn
Rookie (CharacterBody2D) [can inherit hero_base or use composition]
├── Sprite2D (rookie sprite)
├── CollisionShape2D
└── Components (Node)
    ├── HealthComponent
    └── AbilityComponent

# Co-located variant: characters/bouncer/bouncer.tscn
Bouncer (CharacterBody2D)
├── Sprite2D (bouncer sprite)
├── CollisionShape2D
└── Components (Node)
    ├── HealthComponent
    └── NudgeAbility
```

**When to use inheritance:**
- ✅ Multiple variants of same base entity
- ✅ Shared structure with different visuals/stats
- ✅ Progressive enhancement (base + additions)

**When NOT to use inheritance:**
- ❌ Entities are fundamentally different
- ❌ Would need to override too much
- ❌ Simpler to use composition with components

### Step 6: Project Organization

**Recommended folder structure (CO-LOCATED):**

```
project_root/
├── main.tscn                     # Entry point (root level)
│
├── game/                         # Game systems (co-located: scene + script)
│   ├── plinko_board/
│   │   ├── plinko_board.tscn
│   │   ├── plinko_board.gd
│   │   └── drop_zone.gd         # Related scripts
│   └── combat_arena/
│       ├── combat_arena.tscn
│       └── combat_arena.gd
│
├── characters/                   # Heroes (co-located: scene + script + data)
│   ├── rookie/
│   │   ├── rookie.tscn          # Scene
│   │   ├── rookie.gd            # Script
│   │   └── rookie.tres          # Hero data
│   ├── bouncer/
│   │   ├── bouncer.tscn
│   │   ├── bouncer.gd
│   │   └── bouncer.tres
│   ├── lodestone/
│   │   ├── lodestone.tscn
│   │   ├── lodestone.gd
│   │   └── lodestone.tres
│   └── hero_base.gd             # Shared base class (if using inheritance)
│
├── entities/                     # Game entities (co-located: scene + script)
│   ├── peg/
│   │   ├── peg.tscn
│   │   └── peg.gd
│   ├── companion_unit.gd        # Combat companions
│   └── enemy_unit.gd            # Combat enemies
│
├── ui/                           # UI scenes (co-located when complex)
│   ├── hud/
│   │   ├── hud.tscn
│   │   └── hud.gd
│   └── menu/
│       ├── menu.tscn
│       └── menu.gd
│
├── components/                   # Shared reusable components
│   ├── health_component.gd
│   ├── movement_component.gd
│   └── ability_component.gd
│
├── autoload/                     # Global singletons
│   ├── strings.gd               # String constants & paths
│   ├── game_manager.gd          # Game state management
│   ├── events.gd                # Event bus
│   └── database.gd              # Resource caching
│
├── resources/                    # Shared Resource class definitions + data
│   ├── hero.gd                  # Hero Resource class
│   ├── card.gd                  # Card Resource class
│   ├── companion.gd             # Companion Resource class
│   └── configs/                 # Game configuration .tres files
│       └── game_config.tres
│
├── assets/                       # Game assets
│   ├── sprites/
│   │   ├── characters/
│   │   └── entities/
│   ├── audio/
│   │   ├── sfx/
│   │   └── music/
│   └── fonts/
│
└── test/                         # Test scenes and scripts
    ├── test_plinko/
    │   ├── test_plinko.tscn
    │   └── test_plinko.gd
    └── test_ball/
        ├── test_ball.tscn
        └── test_ball.gd
```

**Organization Principles (CO-LOCATED ARCHITECTURE):**
- ✅ Co-locate: Scene, script, and data for each entity live together
- ✅ Shared code: Components and autoloads are separate (used by many entities)
- ✅ Resource classes: Shared Resource class definitions in resources/ directory
- ✅ Clear ownership: Easy to find all files related to a specific entity
- ✅ Scales well: Structure grows cleanly as features are added

### Step 7: Autoload Singletons for Global Systems

**Use autoloads for:**
- Game state management
- Event buses
- Audio management
- Save/load systems

```gdscript
# autoload/game_manager.gd (co-located in autoload directory)
extends Node

signal score_changed(new_score: int)
signal level_completed(level: int)

var score: int = 0
var current_level: int = 1

func add_score(points: int) -> void:
	score += points
	emit_signal("score_changed", score)

func complete_level() -> void:
	current_level += 1
	emit_signal("level_completed", current_level)

# Access anywhere: GameManager.add_score(10)
```

**Setup autoload:**
1. Project > Project Settings > Autoload
2. Add script with name "GameManager"
3. Enable "Global" checkbox
4. Access via `GameManager.method()`

**Autoload Best Practices:**
- ✅ Use for truly global systems
- ✅ Communicate via signals
- ✅ Don't store scene-specific state
- ❌ Don't overuse (causes tight coupling)
- ❌ Don't reference scenes directly

### Step 8: Signal-Based Communication

**Decouple scenes with signals:**

```gdscript
# Bad (tight coupling)
# peg.gd
extends StaticBody2D

func _on_body_entered(body):
	# Directly calls parent's method
	get_parent().get_parent().get_node("ScoreManager").add_score(10)
	# Brittle! Breaks if hierarchy changes
```

```gdscript
# Good (signal-based)
# peg.gd
class_name Peg
extends StaticBody2D

signal peg_hit(peg_type: PegType, position: Vector2)

func _on_body_entered(body):
	emit_signal("peg_hit", peg_type, global_position)

# plinko_board.gd
func _ready():
	for peg in $PegGrid.get_children():
		peg.peg_hit.connect(_on_peg_hit)

func _on_peg_hit(type: PegType, pos: Vector2):
	GameManager.add_score(get_peg_score(type))
	spawn_score_popup(pos)
```

**Signal Architecture:**
- ✅ Child emits signal (doesn't know about parent)
- ✅ Parent connects to signal (knows about child)
- ✅ Allows scene reuse in different contexts
- ❌ Don't use `get_parent()` chains
- ❌ Don't have bidirectional coupling

### Step 9: Resource Files for Data

**Use .tres files for configuration:**

```gdscript
# character_stats.gd (Resource script)
class_name CharacterStats
extends Resource

@export var max_health: int = 100
@export var speed: float = 200.0
@export var damage: int = 10
@export var defense: int = 5
```

**Save as .tres in Godot Editor:**
1. Right-click in FileSystem
2. New Resource
3. Select CharacterStats
4. Save as `characters/rookie/rookie.tres` (co-located with scene and script)

**Use in scene:**

```gdscript
# characters/rookie/rookie.gd
extends CharacterBody2D

@export var stats: CharacterStats

func _ready():
	if stats:
		print("Max health: ", stats.max_health)
		print("Speed: ", stats.speed)
```

**Assign in Inspector:**
- Select Rookie scene
- Drag `characters/rookie/rookie.tres` to "Stats" property (co-located)

**Resource Benefits:**
- ✅ Editable in Inspector without code changes
- ✅ Can be shared across multiple scenes
- ✅ Version controlled (text format)
- ✅ Hot-reload (changes apply immediately)

### Step 10: Testing Scenes in Isolation

**Test scenes independently before integration:**

```gdscript
# In any scene, add test code:
# test/test_character/test_character.gd
extends Node2D

const CHARACTER: PackedScene = preload("res://characters/rookie/rookie.tscn")

func _ready():
	# Spawn test instance
	var char = CHARACTER.instantiate()
	char.position = Vector2(200, 200)
	add_child(char)

	# Connect to signals for testing
	char.died.connect(_on_character_died)

	# Run test scenario
	await get_tree().create_timer(2.0).timeout
	char.take_damage(50)

func _on_character_died():
	print("✅ Character died signal received")
```

**Or use F6 (Run Scene):**
1. Open scene in editor
2. Press F6 (or right-click > Run Scene)
3. Scene runs in isolation
4. Test functionality without full game

**Testing Checklist:**
- ✅ Test scene in isolation (F6)
- ✅ Verify signals emit correctly
- ✅ Check collision shapes (Debug > Shapes)
- ✅ Test with different configurations
- ✅ Integrate into main game only after isolated testing

**Note on Co-location:**
- Test files can be co-located in `test/test_{feature}/` directories
- Each test has its own folder with scene and script together

## Best Practices Summary

**✅ DO:**
- Choose correct root node type for behavior
- Keep hierarchy flat (3-4 levels max)
- Use component-based architecture
- Build complex scenes from simple scenes
- Use scene instancing for repeated entities
- Use scene inheritance for variants
- Organize by feature/entity type
- Use autoloads for global systems
- Communicate via signals
- Use Resources (.tres) for configuration data
- Test scenes in isolation (F6)

**❌ DON'T:**
- Create deep node hierarchies
- Mix multiple responsibilities in one node
- Reference parent with `get_parent()` chains
- Duplicate logic across similar scenes
- Create everything in one monolithic scene
- Overuse autoload singletons
- Reference scenes directly (use signals)
- Skip isolated testing

## Scene Architecture Patterns

### Pattern 1: Component-Based Entity

```
Entity (CharacterBody2D)
├── Visual (Sprite2D/AnimatedSprite2D)
├── Collision (CollisionShape2D)
└── Components (Node)
    ├── HealthComponent
    ├── MovementComponent
    ├── AbilityComponent
    └── InventoryComponent
```

**When:** Complex entities with multiple systems

### Pattern 2: Manager Scene

```
LevelManager (Node)
├── Entities (Node2D)
│   ├── Player [instance]
│   └── Enemies [instances]
├── Environment (Node2D)
│   ├── Terrain [instance]
│   └── Obstacles [instances]
└── UI (CanvasLayer)
    └── HUD [instance]
```

**When:** Need to coordinate multiple systems

### Pattern 3: Pooled Objects

```
ProjectilePool (Node2D)
├── Projectile [instance] x20 (pre-created)
├── Projectile [instance] x20
└── ...
```

**When:** Frequent spawn/destroy (projectiles, particles, damage numbers)

### Pattern 4: UI Composition

```
MainMenu (Control)
├── Background (TextureRect)
├── ButtonContainer (VBoxContainer)
│   ├── PlayButton [instance]
│   ├── SettingsButton [instance]
│   └── QuitButton [instance]
└── VersionLabel (Label)
```

**When:** Complex UI with reusable elements

## Troubleshooting

### Problem: Scenes too complex, hard to maintain

**Solution:**
1. Identify distinct responsibilities
2. Extract components (one responsibility each)
3. Use scene instancing for repeated elements
4. Test components in isolation

### Problem: Tight coupling between scenes

**Solution:**
1. Replace direct references with signals
2. Use autoload for truly global state
3. Pass data via function parameters, not globals

### Problem: Difficult to reuse scenes

**Solution:**
1. Remove parent dependencies (no `get_parent()`)
2. Emit signals instead of calling parent methods
3. Make configuration exportable (@export)
4. Test scene in isolation (F6)

## Example: Complete Scene Architecture

**Game flow (CO-LOCATED STRUCTURE):**

```
main.tscn (Node)
└── [Loads] PlinkoBoard or CombatArena based on game state

game/plinko_board/plinko_board.tscn (Node2D)
├── [Instances] Pegs (entities/peg/peg.tscn)
├── [Instances] DropZones
└── [Instances] BottomZones

characters/ (co-located: scene + script + data together)
├── rookie/
│   ├── rookie.tscn (CharacterBody2D)
│   ├── rookie.gd
│   └── rookie.tres
├── bouncer/
│   ├── bouncer.tscn
│   ├── bouncer.gd
│   └── bouncer.tres
└── lodestone/
    ├── lodestone.tscn
    ├── lodestone.gd
    └── lodestone.tres

components/ (shared reusable code)
├── health_component.gd
├── movement_component.gd
├── ability_component.gd
└── navigation_component.gd

autoload/ (global singletons)
├── game_manager.gd (score, level, state)
├── events.gd (event bus)
└── database.gd (resource caching)
```

## Summary

Godot scene architecture principles:
1. **Right root node** - Choose based on behavior
2. **Flat hierarchy** - Avoid deep nesting
3. **Component-based** - One responsibility per component
4. **Scene composition** - Build complex from simple
5. **Scene instancing** - Reuse repeated elements
6. **Scene inheritance** - Variants of base scenes
7. **Signal-driven** - Decouple with signals
8. **Resource data** - Use .tres for configuration
9. **Autoload sparingly** - Only for global systems
10. **Test in isolation** - F6 individual scenes

Build maintainable, scalable Godot projects with proper scene architecture.
