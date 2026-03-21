extends Node2D

# This must match the name of the node in your scene exactly
@onready var player = $Actor 

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Click detected at: ", get_global_mouse_position()) # Add this
		player.set_target(get_global_mouse_position())
