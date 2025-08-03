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

# Camera input
@export var zoom_min = 3.0
@export var zoom_max = 1.0
var zoom = 2.0

func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
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
		var offset = sin(time * step_freq) * stride_len
		var swing_vector = Vector2(1, 0) * offset
		
		lf.position = Vector2(0, 8) + swing_vector
		rf.position = Vector2(0, -8) - swing_vector
		$Feet.rotation = lerp_angle($Feet.rotation, velocity.angle(), 0.2)
	else:
		time = 0.0
		lf.position = Vector2(0, 8)
		rf.position = Vector2(0, -8)


func _unhandled_input(event):
	var rezoom = false
	if event.is_action_pressed("zoom_in"):
		zoom = min(zoom + 0.1, zoom_min)
		rezoom = true
	elif event.is_action_pressed("zoom_out"):
		zoom = max(zoom - 0.1, zoom_max)
		rezoom = true
	elif event.is_action_pressed("zoom_reset"):
		zoom = 2.0
		rezoom = true
	elif event.is_action_pressed("fire"):
		var new_bullet = preload("res://bullet_1.tscn").instantiate()
		new_bullet.transform = transform
		new_bullet.rotation = pit.rotation
		$"../BulletsCollection".add_child(new_bullet)
	if rezoom:
		$Camera2D.zoom = Vector2(zoom, zoom)

func perp(vec : Vector2):
	var perpVec := Vector2.ZERO
	perpVec.x = vec.y
	perpVec.y = -vec.x
	perpVec.x *= -1
	return perpVec
	
	
	
	
	
