extends CharacterBody2D

var speed = 300.0
@onready var nav_agent = $NavigationAgent2D

func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		return 
		
	print("Moving toward: ", nav_agent.get_next_path_position())
		

	var next_path_pos = nav_agent.get_next_path_position()
	var direction = (next_path_pos - global_position).normalized()
	
	velocity = direction * speed
	move_and_slide()

func set_target(target_pos):
	nav_agent.target_position = target_pos
