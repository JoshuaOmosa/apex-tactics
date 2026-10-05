extends CharacterBody2D

## A unit that walks to a target along the navigation mesh.
## Avoidance is on, so several actors steer around each other instead of
## overlapping.

signal arrived

@export var speed: float = 300.0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	nav_agent.avoidance_enabled = true
	nav_agent.max_speed = speed
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	nav_agent.navigation_finished.connect(func(): arrived.emit())


func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	# Query the path once per physics frame, as Godot recommends.
	var next_pos := nav_agent.get_next_path_position()
	# Propose a velocity; the avoidance system answers via velocity_computed.
	nav_agent.velocity = global_position.direction_to(next_pos) * speed


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()


func set_target(target_pos: Vector2) -> void:
	nav_agent.target_position = target_pos


## Where the agent will actually end up (the closest reachable point).
func final_destination() -> Vector2:
	return nav_agent.get_final_position()


func stop() -> void:
	nav_agent.target_position = global_position
