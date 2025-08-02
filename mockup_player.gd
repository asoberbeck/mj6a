extends CharacterBody2D

@export var speed = 100
@export var input_lerp_weight = 0.1

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	look_at(get_global_mouse_position())
	velocity = lerp(velocity, input_direction*speed, input_lerp_weight)

func _physics_process(delta):
	get_input()
	move_and_slide()
