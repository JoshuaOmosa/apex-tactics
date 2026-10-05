extends Node2D

## Left-click to move, right-click to stop. A marker shows the reachable
## destination; it disappears when the actor arrives.

const MARKER_RADIUS := 6.0
const MARKER_COLOR := Color(0.2, 0.8, 1.0, 0.9)

@onready var player = $Actor

var _marker: Variant = null  # Vector2 while moving, null otherwise


func _ready() -> void:
	player.arrived.connect(_clear_marker)


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.pressed):
		return
	match event.button_index:
		MOUSE_BUTTON_LEFT:
			player.set_target(get_global_mouse_position())
			# The path is computed on the next physics frame, so wait for it
			# before asking where the agent can actually reach.
			await get_tree().physics_frame
			_marker = player.final_destination()
			queue_redraw()
		MOUSE_BUTTON_RIGHT:
			player.stop()
			_clear_marker()


func _clear_marker() -> void:
	_marker = null
	queue_redraw()


func _draw() -> void:
	if _marker != null:
		var local: Vector2 = to_local(_marker)
		draw_circle(local, MARKER_RADIUS, MARKER_COLOR, false, 2.0)
		draw_line(local + Vector2(-3, 0), local + Vector2(3, 0), MARKER_COLOR, 2.0)
		draw_line(local + Vector2(0, -3), local + Vector2(0, 3), MARKER_COLOR, 2.0)
