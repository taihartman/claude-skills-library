---
name: godot-mobile-first-design
description: Mobile-first UI and performance implementation for Godot 4 games
category: godot
framework: godot
---

# Godot Mobile-First Design Workflow

## Description

This skill guides Godot 4 development with mobile-first principles, ensuring games run at 60 FPS on baseline devices (iPhone SE / Snapdragon 778G) while maintaining proper UI/UX for touch controls.

## When to Use

- Creating new UI screens or game scenes
- Implementing touch controls and input handling
- Optimizing game performance for mobile devices
- Setting up project configuration for mobile deployment
- Debugging performance issues on mobile devices

## Core Philosophy

**Mobile first, desktop second.** Design for the constraints of mobile (limited performance, touch input, small screen) and scale up, not down.

## Workflow

### Step 1: Project Configuration Check

Before implementing any feature, ensure project settings are mobile-optimized:

```gdscript
# Verify in Project > Project Settings:

# Display > Window
Width: 375          # iPhone SE width
Height: 667         # iPhone SE height
Orientation: Portrait
Stretch Mode: canvas_items
Stretch Aspect: keep

# Rendering > Renderer
Renderer: Mobile    # CRITICAL: Use Mobile renderer, not Forward+

# Physics > 2D
Physics FPS: 60     # Match target frame rate
```

**✅ DO**: Always start with Mobile renderer settings
**❌ DON'T**: Use Forward+ renderer for mobile games (desktop-only)

### Step 2: Performance Budget Planning

Every feature must fit within the frame budget:

```
Total: 16.67ms per frame (60 FPS)

Budget allocation:
- Physics: 4ms (25%)
- Rendering: 6ms (36%)
- Game Logic: 4ms (25%)
- System/OS: 2.67ms (16%)
```

**Decision Framework:**

Before adding any feature, ask:
1. Will this add draw calls? (Target: < 50 per frame)
2. Will this add physics bodies? (Target: < 100 active)
3. Will this allocate memory in update loops? (Avoid!)
4. Will this run every frame? (Can it be throttled?)

### Step 3: Mobile-First UI Implementation

```gdscript
# Good (mobile-first UI)
extends Control

# Minimum touch target size (Apple/Android guidelines)
const MIN_TOUCH_SIZE: float = 44.0

@onready var button: Button = $Button

func _ready():
	# Ensure touch target is large enough
	button.custom_minimum_size = Vector2(MIN_TOUCH_SIZE, MIN_TOUCH_SIZE)

	# Support both touch and mouse for testing
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	# Handle tap/click
	pass
```

**UI Checklist:**
- ✅ All interactive elements ≥ 44x44pt
- ✅ Text readable at 375px width (min 14pt font)
- ✅ Single-hand reachable controls (bottom 2/3 of screen)
- ✅ Portrait orientation by default
- ✅ No hover-dependent interactions (touch has no hover state)

### Step 4: Touch Input Handling

```gdscript
# Good (supports both touch and mouse)
extends Node2D

func _input(event: InputEvent) -> void:
	# Touch input (primary for mobile)
	if event is InputEventScreenTouch:
		if event.pressed:
			handle_touch_down(event.position)
		else:
			handle_touch_up(event.position)

	# Mouse input (for desktop testing)
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			handle_touch_down(event.position)
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			handle_touch_up(event.position)

func handle_touch_down(screen_pos: Vector2) -> void:
	# Convert screen coords to world coords if needed
	var world_pos = get_global_mouse_position()
	spawn_character(world_pos)

func handle_touch_up(screen_pos: Vector2) -> void:
	# Handle release
	pass
```

**✅ DO**: Support both touch and mouse input for desktop testing
**❌ DON'T**: Use mouse-only events (no `_on_mouse_entered`, etc.)

### Step 5: Rendering Optimization

```gdscript
# Good (sprite batching with atlases)
const ATLAS: Texture2D = preload("res://assets/sprites/atlas.png")

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	# Use texture atlas to batch draw calls
	sprite.texture = ATLAS
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0, 0, 64, 64)  # Sprite region in atlas

# Bad (individual textures break batching)
# Each unique texture = new draw call
sprite1.texture = preload("res://assets/sprite1.png")
sprite2.texture = preload("res://assets/sprite2.png")
```

**Rendering Checklist:**
- ✅ Use texture atlases (1 texture = 1 draw call for all sprites)
- ✅ Keep draw calls < 50 per frame
- ✅ Use z_index for sorting, not CanvasLayers
- ✅ Disable off-screen processing with VisibleOnScreenNotifier2D

### Step 6: Physics Optimization

```gdscript
# Good (optimized collision layers)
extends RigidBody2D

func _ready():
	# Define what this object IS (layer)
	collision_layer = 0b00001  # Player layer

	# Define what this object COLLIDES WITH (mask)
	collision_mask = 0b01110   # Collides with Peg, Wall, Enemy

	# Simple collision shape (circle is fastest)
	var circle = CircleShape2D.new()
	circle.radius = 16.0
	$CollisionShape2D.shape = circle

	# Allow sleeping when stationary
	can_sleep = true
	sleeping = false

# Bad (no layer optimization)
# Checks ALL objects for collision (O(n²))
collision_mask = 0xFFFFFFFF
```

**Physics Checklist:**
- ✅ Use collision layers to reduce checks
- ✅ Simple shapes: Circle > Capsule > Rectangle > Polygon
- ✅ StaticBody2D for non-moving objects (pegs, walls)
- ✅ Allow RigidBody2D to sleep when stationary
- ✅ Disable CCD unless object is fast-moving

### Step 7: Memory Management

```gdscript
# Good (avoid allocations in update loops)
var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Reuse existing variables (no allocation)
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")

	velocity = direction.normalized() * speed
	move_and_collide(velocity * delta)

# Bad (allocates every frame = GC spikes)
func _physics_process(delta: float) -> void:
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	var velocity = direction.normalized() * speed
	move_and_collide(velocity * delta)
```

**Memory Checklist:**
- ✅ Declare variables once, reuse in update loops
- ✅ Use object pooling for frequently spawned objects
- ✅ Disconnect signals in `_exit_tree()`
- ✅ Use `queue_free()` not `free()`

### Step 8: Asset Optimization

```gdscript
# Texture compression (Project Settings)
# Rendering > Textures > Compress
Mode: VRAM Compressed
Format: ETC2 (mobile)
High Quality: Disabled

# Per-texture import settings:
# - Character sprites: 128x128 or 256x256
# - Peg sprites: 64x64
# - Background: 512x512 max
# - UI elements: 64x64 to 256x256
```

**Asset Checklist:**
- ✅ VRAM compression for all textures (75% memory reduction)
- ✅ Appropriate resolutions for target screen (375x667)
- ✅ Ogg Vorbis for music, WAV for SFX
- ✅ MSDF fonts for scalable text

### Step 9: Profiling and Testing

```gdscript
# Add FPS counter (autoload singleton)
extends Node

var fps_label: Label

func _ready():
	fps_label = Label.new()
	fps_label.position = Vector2(10, 10)
	add_child(fps_label)

func _process(delta: float) -> void:
	var fps = Engine.get_frames_per_second()
	fps_label.text = "FPS: %d" % fps

	# Red if below target
	if fps < 60:
		fps_label.modulate = Color.RED
	else:
		fps_label.modulate = Color.WHITE
```

**Testing Workflow:**
1. ✅ Run on desktop first (quick iteration)
2. ✅ Export to mobile and test on device (real performance)
3. ✅ Monitor FPS counter during worst-case scenario
4. ✅ Check Godot Profiler (Debug > Profiler)
5. ✅ Verify all metrics hit target:
   - Frame time < 16.67ms
   - Draw calls < 50
   - Physics time < 4ms
   - Active bodies < 100

### Step 10: Mobile Export Configuration

```
# iOS Export Settings
Application > Bundle Identifier: com.yourcompany.gamename
Architecture > Architectures: arm64
Required Icons: (all sizes)

# Android Export Settings
Package > Unique Name: com.yourcompany.gamename
Package > Min SDK: 21 (Android 5.0)
Package > Target SDK: 33 (Android 13)
Architecture > Architectures: armeabi-v7a, arm64-v8a
```

**Export Checklist:**
- ✅ Install export templates (Editor > Manage Export Templates)
- ✅ Configure signing certificates (iOS: Xcode, Android: keystore)
- ✅ Test on physical device, not emulator
- ✅ Monitor thermal throttling (device temperature)

## Best Practices

**✅ DO:**
- Design for 375x667px (iPhone SE) viewport first
- Use Mobile renderer in Project Settings
- Support touch input (InputEventScreenTouch)
- Ensure 44x44pt minimum touch targets
- Profile early and often with Godot Profiler
- Test on actual devices, not emulators
- Use texture atlases for sprite batching
- Use collision layers to reduce physics checks
- Avoid allocations in `_process()` and `_physics_process()`
- Keep frame budget in mind for every feature

**❌ DON'T:**
- Use Forward+ renderer for mobile (desktop-only)
- Rely only on desktop testing (too fast)
- Use hover-dependent UI (touch has no hover)
- Create individual textures for each sprite (breaks batching)
- Skip collision layer optimization (O(n²) checks)
- Allocate objects in update loops (GC spikes)
- Forget to disconnect signals (memory leaks)
- Use complex polygon collision shapes (slow)

## Performance Targets

**Critical Metrics:**
- **Frame Rate**: 60 FPS minimum (16.67ms per frame)
- **Baseline Device**: iPhone SE (2020) or Snapdragon 778G
- **Draw Calls**: < 50 per frame
- **Physics Bodies**: < 100 active
- **Memory**: < 200MB total
- **Texture Memory**: < 50MB

**If performance drops below target:**
1. Use Godot Profiler to identify bottleneck
2. Check draw calls (Rendering issue)
3. Check physics time (Too many bodies or complex shapes)
4. Check allocations (Memory/GC issue)
5. Optimize highest contributor first

## Troubleshooting

### Problem: Low FPS on mobile (below 60)

**Solution:**
1. Open Godot Profiler (Debug > Profiler)
2. Look for highest time contributor:
   - **Physics > 4ms**: Reduce physics bodies, simplify collision shapes, use collision layers
   - **Rendering > 6ms**: Reduce draw calls with atlases, use VisibleOnScreenNotifier2D
   - **Game Logic > 4ms**: Optimize expensive algorithms, throttle updates
3. Test fix and re-profile

### Problem: Touch targets too small

**Solution:**
```gdscript
# Ensure minimum 44x44pt touch target
button.custom_minimum_size = Vector2(44, 44)

# Or use larger collision area
var area = Area2D.new()
var shape = RectangleShape2D.new()
shape.size = Vector2(44, 44)
```

### Problem: UI doesn't scale properly

**Solution:**
```
# Project Settings > Display > Window
Stretch Mode: canvas_items  # Scales UI properly
Stretch Aspect: keep        # Maintains aspect ratio
```

### Problem: High draw calls

**Solution:**
1. Create texture atlas in Godot Editor
2. Select all sprites > Right-click > "Create Atlas"
3. Use region_enabled to select sprite from atlas
4. All sprites in atlas = 1 draw call

## Example: Complete Mobile Scene

```gdscript
# mobile_game_scene.gd
extends Node2D

# Performance
const MIN_TOUCH_SIZE: float = 44.0
const MAX_PHYSICS_BODIES: int = 100

# Pooling
var projectile_pool: Array[Node2D] = []
var velocity: Vector2 = Vector2.ZERO  # Reused

# Assets (atlased)
const ATLAS: Texture2D = preload("res://assets/sprites/atlas.png")

@onready var fps_counter: Label = $FPSCounter

func _ready():
	# Verify mobile renderer
	if ProjectSettings.get_setting("rendering/renderer/rendering_method") != "mobile":
		push_warning("Not using Mobile renderer!")

	# Setup touch input
	set_process_input(true)

	# Initialize object pool
	init_projectile_pool(20)

	fps_counter.position = Vector2(10, 10)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		handle_tap(event.position)

func handle_tap(screen_pos: Vector2) -> void:
	var world_pos = get_global_mouse_position()
	spawn_effect(world_pos)

func init_projectile_pool(size: int) -> void:
	for i in range(size):
		var projectile = create_projectile()
		projectile.visible = false
		projectile.set_process(false)
		add_child(projectile)
		projectile_pool.append(projectile)

func spawn_effect(pos: Vector2) -> void:
	# Get from pool (no allocation)
	for obj in projectile_pool:
		if not obj.visible:
			obj.position = pos
			obj.visible = true
			obj.set_process(true)
			return

func _process(delta: float) -> void:
	# Update FPS counter
	var fps = Engine.get_frames_per_second()
	fps_counter.text = "FPS: %d" % fps

	if fps < 60:
		fps_counter.modulate = Color.RED
	else:
		fps_counter.modulate = Color.WHITE
```

## Summary

Mobile-first Godot development requires:
1. **Configure project for Mobile renderer** (not Forward+)
2. **Design for 375x667px** with portrait orientation
3. **Support touch input** with 44pt minimum targets
4. **Optimize rendering** with texture atlases (< 50 draw calls)
5. **Optimize physics** with collision layers (< 100 bodies)
6. **Avoid allocations** in update loops (prevent GC spikes)
7. **Profile constantly** with Godot Profiler
8. **Test on device** (iPhone SE or equivalent)

Target: **60 FPS on baseline mobile device with optimal UX**.
