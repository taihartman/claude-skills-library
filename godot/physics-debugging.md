---
name: godot-physics-debugging
description: Systematic physics troubleshooting workflow for Godot 4 games
category: godot
framework: godot
---

# Godot Physics Debugging Workflow

## Description

A systematic approach to diagnosing and fixing physics issues in Godot 4, from collision problems to performance bottlenecks.

## When to Use

- Objects aren't colliding when they should
- Objects are colliding when they shouldn't
- Physics behaving inconsistently or erratically
- Objects tunneling through walls at high speeds
- Physics causing performance drops
- Objects not responding to forces/impulses
- Unexpected bouncing or sliding behavior

## Core Philosophy

**Visualize, verify, then fix.** Never debug physics blind—always enable visual debugging first.

## Workflow

### Step 1: Enable Visual Debugging

Always start by visualizing what's happening:

```gdscript
# Enable in Project Settings:
# Debug > Shapes > Draw Collision Shapes: Visible

# Or enable programmatically:
func _ready():
	if OS.is_debug_build():
		get_tree().debug_collisions_hint = true

# Custom debug drawing
func _draw():
	if OS.is_debug_build():
		# Draw collision bounds
		var shape = $CollisionShape2D.shape
		if shape is CircleShape2D:
			draw_circle(Vector2.ZERO, shape.radius, Color.RED, false, 2.0)
		elif shape is RectangleShape2D:
			draw_rect(Rect2(-shape.size / 2, shape.size), Color.RED, false, 2.0)

		# Draw velocity vector
		if self is RigidBody2D:
			draw_line(Vector2.ZERO, linear_velocity, Color.BLUE, 2.0)
```

**Checklist:**
- ✅ Enable collision shape visualization (Debug menu)
- ✅ Draw velocity vectors for moving objects
- ✅ Draw detection ranges for AI/triggers
- ✅ Use colored shapes to distinguish types (player=green, enemy=red, etc.)

### Step 2: Verify Node Setup

Check that physics nodes are configured correctly:

```gdscript
# Diagnostic script - attach to physics node
extends RigidBody2D

func _ready():
	print("=== Physics Node Diagnostic ===")
	print("Node name: ", name)
	print("Node type: ", get_class())
	print("Position: ", position)
	print("Mass: ", mass)
	print("Gravity scale: ", gravity_scale)
	print("Collision layer: ", collision_layer, " (binary: ", String.num_int64(collision_layer, 2), ")")
	print("Collision mask: ", collision_mask, " (binary: ", String.num_int64(collision_mask, 2), ")")
	print("Can sleep: ", can_sleep)
	print("Sleeping: ", sleeping)
	print("Linear damp: ", linear_damp)
	print("Angular damp: ", angular_damp)

	# Check for collision shape
	var collision_shape = get_node_or_null("CollisionShape2D")
	if collision_shape == null:
		push_error("Missing CollisionShape2D!")
	elif collision_shape.shape == null:
		push_error("CollisionShape2D has no shape assigned!")
	else:
		print("Collision shape: ", collision_shape.shape.get_class())

	# Check parent
	if get_parent() == null:
		push_warning("Node has no parent!")

	print("================================")
```

**Common Issues:**
- ❌ Missing CollisionShape2D node
- ❌ CollisionShape2D exists but shape property is null
- ❌ Collision layers set to 0 (won't collide with anything)
- ❌ Node not added to scene tree (no parent)

### Step 3: Diagnose Collision Layer Issues

Collision layers are the #1 source of physics bugs:

```gdscript
# Collision Layer Debugger
func debug_collision_layers():
	print("\n=== Collision Layer Check ===")

	var node_a = $CharacterA  # Example: Player
	var node_b = $CharacterB  # Example: Peg

	print("Node A (%s):" % node_a.name)
	print("  Layer: %s" % String.num_int64(node_a.collision_layer, 2))
	print("  Mask:  %s" % String.num_int64(node_a.collision_mask, 2))

	print("Node B (%s):" % node_b.name)
	print("  Layer: %s" % String.num_int64(node_b.collision_layer, 2))
	print("  Mask:  %s" % String.num_int64(node_b.collision_mask, 2))

	# Check if they can collide
	var a_checks_b = (node_a.collision_mask & node_b.collision_layer) != 0
	var b_checks_a = (node_b.collision_mask & node_a.collision_layer) != 0

	print("\nCan A detect B? ", a_checks_b)
	print("Can B detect A? ", b_checks_a)

	if a_checks_b and b_checks_a:
		print("✅ Collision should occur")
	else:
		print("❌ Collision won't occur - layer mismatch!")

	print("============================\n")
```

**Decision Framework:**

Ask these questions:
1. Is node A on a layer that node B's mask checks?
2. Is node B on a layer that node A's mask checks?
3. **Both must be true** for collision to occur!

**Common Fixes:**
```gdscript
# Player should collide with pegs and walls
# Layer 1: Player
# Layer 2: Peg
# Layer 3: Wall

# Player setup:
collision_layer = 0b00001  # Player is on layer 1
collision_mask = 0b00110   # Player checks layers 2 (Peg) and 3 (Wall)

# Peg setup:
collision_layer = 0b00010  # Peg is on layer 2
collision_mask = 0b00001   # Peg checks layer 1 (Player)

# Wall setup:
collision_layer = 0b00100  # Wall is on layer 3
collision_mask = 0b00001   # Wall checks layer 1 (Player)
```

### Step 4: Test Collision Detection

Create a minimal test case:

```gdscript
# collision_test.gd
extends Node2D

func _ready():
	# Create test scene
	var player = RigidBody2D.new()
	player.position = Vector2(100, 100)
	player.collision_layer = 1
	player.collision_mask = 2

	var player_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 20
	player_shape.shape = circle
	player.add_child(player_shape)
	add_child(player)

	var peg = StaticBody2D.new()
	peg.position = Vector2(200, 100)
	peg.collision_layer = 2
	peg.collision_mask = 1

	var peg_shape = CollisionShape2D.new()
	var peg_circle = CircleShape2D.new()
	peg_circle.radius = 20
	peg_shape.shape = peg_circle
	peg.add_child(peg_shape)
	add_child(peg)

	# Connect signals
	player.body_entered.connect(_on_collision_detected)

	# Push player toward peg
	player.apply_impulse(Vector2.RIGHT * 500)

func _on_collision_detected(body: Node):
	print("✅ Collision detected with: ", body.name)
```

**If collision doesn't work:**
1. Verify shapes are visible in debug mode
2. Check collision layer/mask with binary debugger (Step 3)
3. Try different node types (RigidBody2D, StaticBody2D, Area2D)
4. Ensure nodes are actually overlapping (check positions)

### Step 5: Diagnose Performance Issues

Physics slowing down your game? Find the bottleneck:

```gdscript
# Physics Performance Monitor
extends Node

var frame_times: Array = []
const SAMPLE_SIZE: int = 60

func _process(delta):
	# Collect frame time
	frame_times.append(delta * 1000)  # Convert to ms

	if frame_times.size() > SAMPLE_SIZE:
		frame_times.pop_front()

	# Every 60 frames, print stats
	if Engine.get_process_frames() % 60 == 0:
		print_performance_stats()

func print_performance_stats():
	var avg = 0.0
	var max_time = 0.0

	for time in frame_times:
		avg += time
		if time > max_time:
			max_time = time

	avg /= frame_times.size()

	print("\n=== Physics Performance ===")
	print("Average frame time: %.2f ms" % avg)
	print("Worst frame time: %.2f ms" % max_time)
	print("Target: 16.67 ms (60 FPS)")

	if avg > 16.67:
		print("⚠️ BELOW TARGET - Optimize physics!")
		diagnose_bottleneck()
	else:
		print("✅ Hitting target")

	print("==========================\n")

func diagnose_bottleneck():
	# Count active physics bodies
	var rigid_bodies = get_tree().get_nodes_in_group("physics")
	print("Active RigidBody2D count: ", rigid_bodies.size())

	if rigid_bodies.size() > 100:
		print("⚠️ Too many physics bodies (target: < 100)")

	# Check for complex collision shapes
	for body in rigid_bodies:
		var shape = body.get_node_or_null("CollisionShape2D")
		if shape and shape.shape:
			if shape.shape is ConvexPolygonShape2D or shape.shape is ConcavePolygonShape2D:
				print("⚠️ Complex polygon shape on: ", body.name, " - use simpler shapes!")
```

**Performance Checklist:**
- ✅ Active physics bodies < 100
- ✅ Using simple shapes (Circle > Capsule > Rectangle > Polygon)
- ✅ Collision layers configured (not checking everything)
- ✅ StaticBody2D for non-moving objects
- ✅ CCD disabled unless needed (fast-moving objects only)
- ✅ Physics bodies can sleep when stationary

### Step 6: Fix Common Physics Issues

#### Issue: Objects tunneling through walls

**Cause:** Moving too fast for discrete collision detection

**Fix:**
```gdscript
# Enable Continuous Collision Detection (CCD)
extends RigidBody2D

func _ready():
	# For fast-moving objects (bullets, etc.)
	continuous_cd = CCD_MODE_CAST_RAY

	# Or for very precise collision:
	continuous_cd = CCD_MODE_CAST_SHAPE  # More expensive

# Note: Only use CCD for objects that actually need it!
```

#### Issue: Objects bouncing unexpectedly

**Cause:** Physics material bounce property

**Fix:**
```gdscript
extends RigidBody2D

func _ready():
	# Create physics material with no bounce
	var material = PhysicsMaterial.new()
	material.bounce = 0.0  # No bounce (0.0 - 1.0)
	material.friction = 0.5  # Some friction

	physics_material_override = material
```

#### Issue: Objects not responding to forces

**Cause:** Node type mismatch or sleeping

**Fix:**
```gdscript
extends RigidBody2D

func _ready():
	# Ensure not sleeping
	can_sleep = true  # Allow sleeping...
	sleeping = false  # ...but start awake

	# Disable lock if accidentally enabled
	lock_rotation = false  # Allow rotation
	freeze = false  # Not frozen

func apply_push_force():
	# Wake up before applying force
	sleeping = false
	apply_central_impulse(Vector2.RIGHT * 500)
```

#### Issue: Erratic movement after collision

**Cause:** Accumulating forces or torque

**Fix:**
```gdscript
extends RigidBody2D

func _physics_process(delta):
	# Damp velocity to prevent infinite bouncing
	linear_velocity *= 0.98  # 2% friction
	angular_velocity *= 0.95  # 5% angular friction

	# Or set explicit damping
	linear_damp = 0.1  # Linear damping
	angular_damp = 0.1  # Angular damping
```

### Step 7: Signal-Based Debugging

Track collision events:

```gdscript
extends RigidBody2D

var collision_count: int = 0

func _ready():
	# Connect collision signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node):
	collision_count += 1
	print("[%s] Collision #%d: Entered %s" % [name, collision_count, body.name])

	# Debug info
	if body is RigidBody2D:
		print("  Other velocity: ", body.linear_velocity)
	print("  My velocity: ", linear_velocity)
	print("  My position: ", position)

func _on_body_exited(body: Node):
	print("[%s] Exited %s" % [name, body.name])
```

**Troubleshooting:**
- Signal not firing? → Check collision layers (Step 3)
- Signal firing multiple times? → May be expected (multiple contact points)
- Signal firing but no visible collision? → Shapes may be overlapping in editor

### Step 8: Verify Physics Timestep

Ensure physics runs at consistent rate:

```gdscript
# Check Project Settings:
# Physics > Common > Physics Ticks Per Second: 60

func _ready():
	print("Physics FPS: ", Engine.physics_ticks_per_second)  # Should be 60

# Test physics consistency
var last_physics_time: float = 0.0

func _physics_process(delta):
	var current_time = Time.get_ticks_msec() / 1000.0
	var time_diff = current_time - last_physics_time

	if last_physics_time > 0:
		var expected_delta = 1.0 / 60.0  # 60 FPS = 0.0167s
		var variance = abs(time_diff - expected_delta)

		if variance > 0.005:  # More than 5ms variance
			print("⚠️ Physics timestep variance: ", variance * 1000, " ms")

	last_physics_time = current_time
```

## Best Practices

**✅ DO:**
- Enable visual debugging first (Debug > Shapes)
- Use binary representation for collision layers (0b00001)
- Test with minimal scenes before full game integration
- Use signals to track collision events
- Keep physics bodies < 100 active
- Use StaticBody2D for non-moving objects
- Use simple collision shapes (Circle, Rectangle)
- Profile physics time with Godot Profiler

**❌ DON'T:**
- Debug physics without visualization
- Use collision_mask = 0xFFFFFFFF (checks everything)
- Use complex polygon shapes unless necessary
- Apply forces in `_process()` (use `_physics_process()`)
- Enable CCD on all objects (expensive)
- Forget to check if nodes are in scene tree
- Ignore collision layer configuration

## Decision Framework

When physics doesn't work:

1. **Are shapes visible?**
   - No → Enable Debug > Shapes or check CollisionShape2D
   - Yes → Continue

2. **Are layers configured?**
   - Check with collision layer debugger (Step 3)
   - Fix layer/mask mismatch

3. **Is collision occurring?**
   - Yes → Signals should fire, check signal connections
   - No → Verify shapes are overlapping, check node types

4. **Is performance poor?**
   - Run performance monitor (Step 5)
   - Optimize bottleneck (bodies, shapes, layers)

## Troubleshooting Quick Reference

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| No collision at all | Collision layer mismatch | Check layers with debugger (Step 3) |
| Collision not detected | Missing signal connection | Connect `body_entered` signal |
| Tunneling through walls | Moving too fast | Enable CCD for fast objects |
| Unexpected bouncing | Physics material | Set bounce = 0.0 |
| Objects not moving | Sleeping or frozen | Set sleeping = false, freeze = false |
| Low FPS | Too many bodies or complex shapes | Reduce count, simplify shapes |
| Erratic movement | Accumulating forces | Add damping or reset forces |
| Inconsistent behavior | Wrong node type | Use RigidBody2D for dynamic, StaticBody2D for static |

## Example: Complete Diagnostic Scene

```gdscript
# physics_diagnostic_scene.gd
extends Node2D

func _ready():
	# Enable visual debugging
	get_tree().debug_collisions_hint = true

	# Run all diagnostics
	await get_tree().create_timer(1.0).timeout
	run_full_diagnostic()

func run_full_diagnostic():
	print("\n" + "=".repeat(50))
	print(" PHYSICS DIAGNOSTIC REPORT ")
	print("=".repeat(50) + "\n")

	# 1. Check project settings
	print("1. Physics Configuration:")
	print("   Physics FPS: ", Engine.physics_ticks_per_second)
	print("   Default gravity: ", ProjectSettings.get_setting("physics/2d/default_gravity"))
	print("")

	# 2. Count physics nodes
	print("2. Scene Physics Nodes:")
	var rigid_bodies = get_tree().get_nodes_in_group("RigidBody2D")
	var static_bodies = get_tree().get_nodes_in_group("StaticBody2D")
	var areas = get_tree().get_nodes_in_group("Area2D")

	print("   RigidBody2D: ", rigid_bodies.size())
	print("   StaticBody2D: ", static_bodies.size())
	print("   Area2D: ", areas.size())
	print("")

	# 3. Check each physics node
	print("3. Node Details:")
	for node in get_all_physics_nodes():
		check_physics_node(node)

	print("=".repeat(50))
	print(" END DIAGNOSTIC REPORT ")
	print("=".repeat(50) + "\n")

func get_all_physics_nodes() -> Array:
	var nodes = []
	nodes.append_array(get_tree().get_nodes_in_group("RigidBody2D"))
	nodes.append_array(get_tree().get_nodes_in_group("StaticBody2D"))
	nodes.append_array(get_tree().get_nodes_in_group("Area2D"))
	return nodes

func check_physics_node(node: Node):
	print("   Node: ", node.name, " (", node.get_class(), ")")

	var shape_node = node.get_node_or_null("CollisionShape2D")
	if shape_node == null:
		print("      ❌ Missing CollisionShape2D")
		return

	if shape_node.shape == null:
		print("      ❌ CollisionShape2D has no shape")
		return

	print("      Shape: ", shape_node.shape.get_class())
	print("      Layer: ", String.num_int64(node.collision_layer, 2))
	print("      Mask:  ", String.num_int64(node.collision_mask, 2))

	if node is RigidBody2D:
		print("      Mass: ", node.mass)
		print("      Sleeping: ", node.sleeping)

	print("")
```

## Summary

Physics debugging workflow:
1. **Enable visual debugging** (shapes, velocity vectors)
2. **Verify node setup** (CollisionShape2D exists, shape assigned)
3. **Check collision layers** (use binary debugger)
4. **Test minimal case** (isolated collision test)
5. **Monitor performance** (frame times, body counts)
6. **Fix common issues** (tunneling, bouncing, forces)
7. **Use signals** (track collision events)
8. **Verify timestep** (consistent 60 FPS physics)

**Always visualize before fixing!**
