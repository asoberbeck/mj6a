extends CharacterBody2D

# Initialize Nodes
@onready var pit = $Torso
@onready var lf = $Feet/L_foot
@onready var rf = $Feet/R_foot

# Physical Movement Parameters
@export var acceleration := 100
@export var max_speed := 100
@export var friction := 70
@export var rot_speed := 3.0

# Movement Animation Parameters
var time := 0.0
var stride_len := 4.0
var step_freq := 2.0

func _physics_process(delta):
	var input_direction = get_input()
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)


func _process(delta):
	pit.look_at($"../AimSpot".position) # fixme
	
	# Cartesian Position Update
	move_and_slide()
	
	var speed = velocity.length()
	if speed > 1.0:
		time += delta * speed * 0.1
		var dir = velocity.normalized()
		var offset = sin(time * step_freq) * stride_len
		var swing_vector = dir * offset
		
		lf.position = Vector2(0, 8) + swing_vector
		rf.position = Vector2(0, -8) - swing_vector
	else:
		time = 0.0
		lf.position = Vector2(0, 8)
		rf.position = Vector2(0, -8)


func get_input():
	return Input.get_vector("left", "right", "up", "down")

func perp(vec : Vector2):
	var perpVec := Vector2.ZERO
	perpVec.x = vec.y
	perpVec.y = -vec.x
	perpVec.x *= -1
	return perpVec
	
	
	
	
	
