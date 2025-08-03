extends TileMapLayer

@export var city_width := 11
@export var city_height := 11
@export var empty_plot_prob := 0.3

@onready var tilemap = $"."
var source_id = 0
"""
Tile Guide:
	0:  Null
	1:  Deadend - W
	2:  Deadend - E
	3:  Horizontal
	4:  Deadend - N
	5:  Elbow - SW
	6:  Elbow - SE
	7:  T - S
	8:  Deadend - S
	9:  Elbow - NW
	10: Elbow - NE
	11: T - N
	12: Vertical
	13: T - W
	14: T - E
	15: 4-Way
"""

var rng = RandomNumberGenerator.new()

func _ready():
	
	var city = []
	var city_tiles = []
	
	# Generate city plan
	city.resize(city_width)
	for x in range(city_width):
		city[x] = []
		for y in range(city_height):
			if rng.randf() >= empty_plot_prob:
				city[x].append(true)
			else:
				city[x].append(false)

	# Pad and look for connection, convert to binary
	city = pad_city(city)
	
	# connection array [N, S, E, W]
	var Ncon : bool
	var Scon : bool
	var Econ : bool
	var Wcon : bool
	city_tiles.resize(city_width-1)
	for x in range(1, city_width):
		city_tiles[x-1] = []
		city_tiles[x-1].resize(city_height-1)
		for y in range(1, city_height):
			if !city[x][y]:
				city_tiles[x-1][y-1] = 0
			else:
				Ncon = city[x][y+1]
				Scon = city[x][y-1]
				Econ = city[x+1][y]
				Wcon = city[x-1][y]
				city_tiles[x-1][y-1] = bool_array_to_binary([Ncon, Scon, Econ, Wcon])
	
	var idx2coord = []
	for x in range(4):
		for y in range(4):
			idx2coord.append(Vector2i(x, y))
	print(idx2coord)
	
	for x in range(city_width - 1):
		for y in range(city_height - 1):
			var tileid = city_tiles[x][y]
			tilemap.set_cell(Vector2i(x, y), source_id, idx2coord[tileid])


func pad_city(plan):
	var xpad = Array()
	xpad.resize(city_height)
	xpad.fill(false)
	plan.insert(0, xpad)
	plan.append(xpad)
	
	for x in range(city_width + 2):
		plan[x].insert(0, false)
		plan[x].append(false)
	
	return plan
	
	
func bool_array_to_binary(bits: Array) -> int:
	var result := 0
	for i in bits.size():
		result = (result << 1) | int(bits[i])
	return result
