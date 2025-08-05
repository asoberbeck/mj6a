extends TileMapLayer

@export var city_width := 11
@export var city_height := 11
@export var block_size := 6
@export var empty_road_prob := 0.4
@export var veg_prob := 0.7
@export var building_prob := 0.4 
@export var blockRNG : NoiseTexture2D

var veg_prob8b = int(255 * veg_prob)
var building_prob8b = int(255 * building_prob)
var tileKey = []

@onready var tilemap = $"."
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

#var blockRNG = NoiseTexture2D.new()
var rng = RandomNumberGenerator.new()
var map_width : int
var map_height : int
var fourByFourID = []
var sixBySixID = []

func _ready():
	
	var city = []
	var intersections = []
	var fullRoad = []
	var fullBlock = []
	
	# Generate city plan
	city.resize(city_width)
	for x in range(city_width):
		city[x] = []
		for y in range(city_height):
			if rng.randf() >= empty_road_prob:
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
	intersections.resize(city_width-1)
	for x in range(1, city_width):
		intersections[x-1] = []
		intersections[x-1].resize(city_height-1)
		for y in range(1, city_height):
			if !city[x][y]:
				intersections[x-1][y-1] = 0
			else:
				Ncon = city[x][y+1]
				Scon = city[x][y-1]
				Econ = city[x+1][y]
				Wcon = city[x-1][y]
				var connects = [Ncon, Scon, Econ, Wcon]
				intersections[x-1][y-1] = bool_array_to_binary(connects)

	
	map_width = (1 + block_size) * (city_width  - 1)
	map_height = (1 + block_size) * (city_height - 1)
	
	fullRoad.resize(map_width)
	for x in range(map_width):
		fullRoad[x] = []
		fullRoad[x].resize(map_height)
		fullRoad[x].fill(0)
	fullBlock = fullRoad.duplicate(true)
	
	var WlinkID = [2, 3, 6,  7,  10, 11, 14, 15]
	var SlinkID = [8, 9, 10, 11, 12, 13, 14, 15]
	#var vert = Vector2i(3, 0)
	#var horz = Vector2i(0, 3)
	
	for x in range(city_width - 1):
		for y in range(city_height - 1):
			var tileid = intersections[x][y]
			fullRoad[x*block_size][y*block_size] = tileid
			fullBlock[x*block_size][y*block_size] = -1
			
			if tileid in WlinkID:
				for i in range(1, block_size):
					fullRoad[x*block_size + i][y*block_size] = 3
					fullBlock[x*block_size + i][y*block_size] = -1
					
			if tileid in SlinkID:
				for i in range(1, block_size):
					fullRoad[x*block_size][y*block_size + i] = 12
					fullBlock[x*block_size][y*block_size + i] = -1
	
	#blockRNG.set_width(map_width)
	#blockRNG.set_height(map_height)
	blockRNG.set_noise(FastNoiseLite.new())
	await blockRNG.changed
	var image = blockRNG.get_image()
	image = rgba_to_grayscale(image)
	var blockGen = image.get_data()	
	
	print(blockGen)

	#for col in range(map_width):
		#print(fullBlock[col])
	
	var mapCoord = idx2coord(map_width, map_height)
	print(len(mapCoord), ", ", len(blockGen), ", ", map_width, ", ", map_height)
	for n in range(len(blockGen)):
		var coord = mapCoord[n]
		var rn = blockGen[n]
		if fullBlock[coord[0]][coord[1]] == -1:
			pass
		elif rn <= building_prob8b:
			fullBlock[coord[0]][coord[1]] = 3
		elif rn <= veg_prob8b:
			fullBlock[coord[0]][coord[1]] = [18, 19, 20].pick_random()
		 
	
	fourByFourID = idx2coord(4, 4)
	sixBySixID = idx2coord(6, 6)
	
	tileKey.append(fourByFourID)
	tileKey.append(sixBySixID)

	# Construct !
	build_city(fullRoad, 0)
	build_city(fullBlock, 1)


func build_city(plan, source_id):
	for x in range(map_width):
		for y in range(map_height):
			var convertArray = tileKey[source_id]
			var tid = plan[x][y]
			if tid == -1:
				pass
			else:
				tilemap.set_cell(Vector2i(x, y), source_id, convertArray[tid])

func idx2coord(width, height):
# Mapping for tile ID to TileSet location
	var map = []
	for x in range(width):
		for y in range(height):
			map.append(Vector2i(x, y))
	return map


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
	
	
func rgba_to_grayscale(rgba_image: Image) -> Image:
	var width = rgba_image.get_width()
	var height = rgba_image.get_height()

	var grayscale_image = Image.create(width, height, false, Image.FORMAT_L8)
	
	for y in range(height):
		for x in range(width):
			var color = rgba_image.get_pixel(x, y)
			var luminance = color.r * 0.299 + color.g * 0.587 + color.b * 0.114
			grayscale_image.set_pixel(x, y, Color(luminance, luminance, luminance, 1.0))
	
	return grayscale_image
