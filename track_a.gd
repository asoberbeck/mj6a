extends AudioStreamPlayer2D

@onready var player = $"."

func _ready():
	player.stream.loop = true
