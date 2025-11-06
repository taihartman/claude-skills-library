---
name: gdscript-best-practices
description: GDScript coding standards and patterns for clean, performant Godot code
category: godot
framework: godot
---

# GDScript Best Practices Workflow

## Description

Systematic workflow for writing clean, performant, and maintainable GDScript code following Godot 4 conventions.

## When to Use

- Writing any new GDScript code
- Reviewing existing GDScript code
- Refactoring legacy code
- Optimizing performance-critical code
- Establishing coding standards for a team

## Core Philosophy

**Type-safe, signal-driven, performance-conscious.** Write code that fails fast, communicates through signals, and runs efficiently on mobile devices.

## Workflow

### Step 1: File and Class Naming

```gdscript
# File names: snake_case
# rookie_character.gd
# plinko_board.gd
# weapon_peg.gd

# Class names: PascalCase
class_name RookieCharacter
extends CharacterBody2D

class_name PlinkoBoard
extends Node2D

class_name WeaponPeg
extends StaticBody2D
```

**✅ DO:**
- Use `snake_case` for file names
- Use `PascalCase` for class names
- Match file name to primary class (rookie_character.gd → RookieCharacter)

**❌ DON'T:**
- Mix naming conventions (RookieCharacter.gd)
- Use spaces in file names
- Use generic names (manager.gd, controller.gd)

### Step 2: Variable Declaration with Type Hints

**Always use explicit type hints:**

```gdscript
# Good (explicit types)
var speed: float = 100.0
var max_health: int = 100
var player_name: String = "Hero"
var is_jumping: bool = false
var sprite: Sprite2D
var velocity: Vector2 = Vector2.ZERO

# Arrays with type hints (Godot 4)
var enemies: Array[Enemy] = []
var positions: Array[Vector2] = []

# Dictionaries (no generic type hint, but document)
var stats: Dictionary = {
	"health": 100,
	"damage": 10
}  # Dictionary<String, int>

# Bad (no type hints)
var speed = 100.0
var sprite
var enemies = []
```

**Why:**
- Catches type errors at compile time
- Better autocomplete in editor
- ~10-15% performance improvement
- Self-documenting code

### Step 3: Function Declaration with Type Hints

```gdscript
# Good (fully typed)
func calculate_damage(base: int, multiplier: float) -> int:
	return int(base * multiplier)

func get_nearest_enemy(position: Vector2) -> Enemy:
	var nearest: Enemy = null
	var min_distance: float = INF

	for enemy in enemies:
		var dist = position.distance_to(enemy.position)
		if dist < min_distance:
			min_distance = dist
			nearest = enemy

	return nearest

func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		die()

# Bad (missing types)
func calculate_damage(base, multiplier):
	return int(base * multiplier)

func get_nearest_enemy(position):
	# ...
```

**Function Naming:**
- Use `snake_case` for all functions
- Use verbs for actions: `calculate_damage`, `spawn_enemy`, `update_health_bar`
- Use `get_` prefix for getters: `get_health`, `get_position`
- Use `is_` or `has_` prefix for boolean checks: `is_alive`, `has_ammo`

### Step 4: Constants and Enums

```gdscript
# Constants: UPPER_SNAKE_CASE
const MAX_SPEED: float = 300.0
const GRAVITY: float = 980.0
const JUMP_FORCE: float = -400.0

# Enums for related constants
enum Team {
	PLAYER,
	ENEMY,
	NEUTRAL
}

enum PegType {
	WEAPON,
	ARMOR,
	COMPANION,
	BUFF,
	GOLD
}

# Usage
var current_team: Team = Team.PLAYER
var peg_type: PegType = PegType.WEAPON
```

**✅ DO:**
- Use `const` for unchanging values
- Use `enum` for related constants
- Use descriptive names

**❌ DON'T:**
- Use magic numbers inline (use named constants)
- Mix casing conventions

### Step 5: Signal Declaration and Usage

```gdscript
# Declare signals at top of script
class_name CombatUnit
extends CharacterBody2D

# Signals with type hints (Godot 4)
signal health_changed(old_health: int, new_health: int)
signal died()
signal ability_used(ability_name: String, target: CombatUnit)

var health: int = 100

# Connect signals in _ready
func _ready():
	health_changed.connect(_on_health_changed)

# Emit signals
func take_damage(amount: int) -> void:
	var old_health = health
	health -= amount
	emit_signal("health_changed", old_health, health)

	if health <= 0:
		emit_signal("died")
		die()

# Signal handler naming: _on_<signal_name>
func _on_health_changed(old: int, new: int) -> void:
	print("Health: ", old, " -> ", new)
```

**Signal Best Practices:**
- ✅ Name signals in past tense (they describe events that happened)
- ✅ Use type hints for signal parameters
- ✅ Prefix handlers with `_on_`
- ✅ Document signal parameters
- ❌ Don't use string-based connections (Godot 3 style)

### Step 6: Node References with @onready

```gdscript
# Good (use @onready)
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var health_bar: ProgressBar = $UI/HealthBar

func _ready():
	# Nodes already available
	sprite.visible = true
	health_bar.value = 100

# Bad (get nodes in _ready)
var sprite: Sprite2D
var collision: CollisionShape2D

func _ready():
	sprite = $Sprite2D
	collision = $CollisionShape2D
```

**Why @onready:**
- Cleaner code (one line instead of multiple in `_ready`)
- Fails fast if node doesn't exist
- Clear dependency declaration

### Step 7: Null Safety and Validation

```gdscript
# Always validate before accessing
func attack_target(target: CombatUnit) -> void:
	# Check if target is valid
	if target == null or not is_instance_valid(target):
		return

	# Check if target has the method
	if not target.has_method("take_damage"):
		push_warning("Target doesn't have take_damage method")
		return

	target.take_damage(damage)

# Safe node access
func get_health_component() -> HealthComponent:
	var health = get_node_or_null("HealthComponent")
	if health == null:
		push_error("HealthComponent not found on ", name)
		return null

	return health as HealthComponent
```

**Validation Checklist:**
- ✅ Check for null before accessing
- ✅ Use `is_instance_valid()` for nodes that might be freed
- ✅ Use `has_method()` before calling dynamic methods
- ✅ Use `get_node_or_null()` instead of `get_node()` for optional nodes

### Step 8: Resource Management

```gdscript
# Preload for compile-time loading
const CHARACTER_SCENE: PackedScene = preload("res://scenes/characters/rookie.tscn")
const SPRITE_TEXTURE: Texture2D = preload("res://assets/sprites/rookie.png")

func spawn_character():
	var character = CHARACTER_SCENE.instantiate()
	add_child(character)

# Load for runtime/conditional loading
func load_level(level_name: String):
	var path = "res://scenes/levels/%s.tscn" % level_name
	var level_scene = load(path) as PackedScene

	if level_scene:
		var level = level_scene.instantiate()
		add_child(level)

# Free nodes safely
func destroy() -> void:
	# Emit cleanup signals
	emit_signal("destroyed")

	# Disconnect signals
	if target and target.died.is_connected(_on_target_died):
		target.died.disconnect(_on_target_died)

	# Queue for deferred removal
	queue_free()  # Use this, not free()
```

**Resource Checklist:**
- ✅ Use `preload()` for frequently-used assets
- ✅ Use `load()` for conditional/dynamic assets
- ✅ Use `queue_free()` instead of `free()`
- ✅ Disconnect signals in `_exit_tree()`

### Step 9: Performance Optimization Patterns

```gdscript
# Avoid allocations in update loops
var velocity: Vector2 = Vector2.ZERO  # Reuse
var direction: Vector2 = Vector2.ZERO  # Reuse

func _physics_process(delta: float) -> void:
	# Reuse existing variables (no allocation)
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")

	velocity = direction.normalized() * speed
	move_and_collide(velocity * delta)

# Cache node references
@onready var sprite: Sprite2D = $Sprite2D  # Cache once

func _process(delta: float) -> void:
	sprite.rotation += delta  # Use cached reference

# Update only on change (property setters)
var _health: int = 100

var health: int:
	get:
		return _health
	set(value):
		if _health != value:
			var old = _health
			_health = value
			emit_signal("health_changed", old, _health)
			update_health_bar()  # Only update when changed
```

**Performance Rules:**
- ✅ Reuse variables in update loops
- ✅ Cache node references with `@onready`
- ✅ Only update UI when values change
- ✅ Use property setters for side effects
- ❌ Don't allocate objects in `_process()` or `_physics_process()`
- ❌ Don't call `get_node()` repeatedly

### Step 10: Error Handling and Debugging

```gdscript
# Use appropriate error levels
func load_save_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("Save file not found: ", path)  # Critical error
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open save file: ", path)
		return {}

	return JSON.parse_string(file.get_as_text())

# Conditional debug output
const DEBUG: bool = true

func _ready():
	if DEBUG:
		print("Character initialized: ", name)
		print("Health: ", health)
		print("Speed: ", speed)

# Never debug print in update loops
func _process(delta: float):
	# ❌ DON'T DO THIS (prints 60 times per second!)
	# print("Delta: ", delta)

	if DEBUG and Engine.get_process_frames() % 60 == 0:
		# ✅ OK: Only prints once per second
		print("FPS: ", Engine.get_frames_per_second())
```

**Error Handling Levels:**
- `push_error()` - Critical errors that break functionality
- `push_warning()` - Non-critical issues that should be fixed
- `print()` / `print_debug()` - Informational messages

## Best Practices Summary

**✅ DO:**
- Use type hints for ALL variables, parameters, and return types
- Use `@onready` for node references
- Use signals for inter-node communication
- Name signals in past tense (events that happened)
- Prefix signal handlers with `_on_`
- Use `snake_case` for files, variables, and functions
- Use `PascalCase` for class names
- Use `UPPER_SNAKE_CASE` for constants
- Validate null before accessing nodes
- Use `queue_free()` instead of `free()`
- Cache node references (don't call `get_node()` repeatedly)
- Avoid allocations in `_process()` and `_physics_process()`
- Disconnect signals in `_exit_tree()`

**❌ DON'T:**
- Skip type hints (performance and safety loss)
- Use string-based signal connections (Godot 3 style)
- Get nodes in `_ready()` (use `@onready`)
- Call `free()` directly (use `queue_free()`)
- Allocate in update loops (causes GC spikes)
- Print in `_process()` (60 prints/second)
- Use magic numbers (define constants)
- Mix naming conventions

## Code Review Checklist

When reviewing GDScript code:

**Naming:**
- [ ] File names use `snake_case`
- [ ] Class names use `PascalCase`
- [ ] Variables/functions use `snake_case`
- [ ] Constants use `UPPER_SNAKE_CASE`

**Type Safety:**
- [ ] All variables have type hints
- [ ] All function parameters have type hints
- [ ] All function returns have type hints
- [ ] Arrays use typed syntax: `Array[Type]`

**Signals:**
- [ ] Signals declared at top of script
- [ ] Signals use past tense names
- [ ] Signal handlers prefixed with `_on_`
- [ ] Signals have type hints (Godot 4)

**Node References:**
- [ ] Use `@onready` for node references
- [ ] Validate nodes before accessing
- [ ] Use `get_node_or_null()` for optional nodes

**Performance:**
- [ ] No allocations in `_process()` / `_physics_process()`
- [ ] Node references cached
- [ ] Updates only occur on change
- [ ] No debug prints in update loops

**Resource Management:**
- [ ] Use `queue_free()` not `free()`
- [ ] Signals disconnected in `_exit_tree()`
- [ ] Use `preload()` for frequent assets

## Example: Complete GDScript File

```gdscript
# combat_unit.gd
class_name CombatUnit
extends CharacterBody2D

# Signals (top of file)
signal health_changed(old_health: int, new_health: int)
signal died()
signal ability_used(ability_name: String)

# Enums
enum State {
	IDLE,
	MOVING,
	ATTACKING
}

# Constants
const MAX_SPEED: float = 200.0
const ATTACK_RANGE: float = 50.0

# Exported variables (editable in inspector)
@export var team: Team = Team.PLAYER
@export var stats: UnitStats

# Private variables
var _current_state: State = State.IDLE
var _target: CombatUnit = null
var velocity: Vector2 = Vector2.ZERO  # Reused

# Cached node references
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var navigation: NavigationAgent2D = $NavigationAgent2D

# Lifecycle methods
func _ready() -> void:
	if DEBUG:
		print("CombatUnit initialized: ", name)

	# Connect signals
	health_changed.connect(_on_health_changed)

	# Validate setup
	if stats == null:
		push_error("CombatUnit has no stats assigned!")

func _physics_process(delta: float) -> void:
	match _current_state:
		State.IDLE:
			handle_idle_state()
		State.MOVING:
			handle_moving_state(delta)
		State.ATTACKING:
			handle_attacking_state(delta)

func _exit_tree() -> void:
	# Cleanup
	if _target and _target.died.is_connected(_on_target_died):
		_target.died.disconnect(_on_target_died)

# Public methods
func take_damage(amount: int) -> void:
	if stats == null:
		return

	var old_health = stats.health
	stats.health -= amount

	emit_signal("health_changed", old_health, stats.health)

	if stats.health <= 0:
		die()

func set_target(target: CombatUnit) -> void:
	if target == null or not is_instance_valid(target):
		return

	_target = target
	_target.died.connect(_on_target_died)
	_current_state = State.MOVING

# Private methods
func handle_idle_state() -> void:
	find_nearest_enemy()

func handle_moving_state(delta: float) -> void:
	if _target == null or not is_instance_valid(_target):
		_current_state = State.IDLE
		return

	var distance = position.distance_to(_target.position)

	if distance <= ATTACK_RANGE:
		_current_state = State.ATTACKING
		return

	# Move toward target
	navigation.target_position = _target.position
	var next_pos = navigation.get_next_path_position()
	var direction = (next_pos - position).normalized()

	velocity = direction * MAX_SPEED
	move_and_slide()

func handle_attacking_state(delta: float) -> void:
	if _target == null or not is_instance_valid(_target):
		_current_state = State.IDLE
		return

	# Attack logic here
	pass

func find_nearest_enemy() -> void:
	# Implementation
	pass

func die() -> void:
	emit_signal("died")
	queue_free()

# Signal handlers
func _on_health_changed(old: int, new: int) -> void:
	if DEBUG:
		print(name, " health: ", old, " -> ", new)

	update_health_bar()

func _on_target_died() -> void:
	_target = null
	_current_state = State.IDLE

func update_health_bar() -> void:
	# Update UI
	pass
```

## Summary

GDScript best practices enforce:
1. **Type safety** - Type hints everywhere
2. **Signal-driven** - Decouple with signals
3. **Performance** - No allocations in loops
4. **Validation** - Check null before access
5. **Naming** - Consistent conventions
6. **Resource management** - Clean up properly

Follow these practices for maintainable, performant Godot code.
