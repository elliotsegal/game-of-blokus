extends Area2D

export var player = 1
export var tiles = PoolVector2Array()

var dragging = false
var start_position
var board
var can_place = false
var place_x
var place_y

func _ready():
	start_position = position
	board = get_node(@"/root/Node2D/Board")
	board.connect("advance_turn", self, "_on_Board_advance_turn")
	var tile_scene = preload("res://tile.tscn")
	for tile in tiles:
		var node = tile_scene.instance()
		node.position = tile * 32
		node.set_player(player)
		add_child(node)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		# Start dragging if the click is on the sprite.
		if not dragging and event.pressed:
			dragging = true
			z_index = 5

func _input(event):
	if not dragging:
		return
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		# Stop dragging if the button is released.
		if not event.pressed:
			dragging = false
			if can_place:
				board.place_piece(self, place_x, place_y)
				queue_free()
			else:
				position = start_position
				modulate = Color(1, 1, 1, 1)
				z_index = 0
				rotation = 0
				scale = Vector2(1, 1)
	if event is InputEventMouseMotion:
		# While dragging, move the sprite with the mouse.
		global_position = event.position
		var board_position = (global_position - board.global_position) / 32
		place_x = int(round(board_position.x))
		place_y = int(round(board_position.y))
		can_place = board.can_place_piece(self, place_x, place_y)
		if can_place:
			modulate = Color(1, 1, 1, 1)
		else:
			modulate = Color(1, 1, 1, 0.5)
	if event is InputEventKey and event.pressed and not event.echo:
		if event.scancode == KEY_R:
			rotation_degrees += 90
		if event.scancode == KEY_F:
			scale.x *= -1

func _on_Board_advance_turn():
	dragging = false
	position = start_position
	modulate = Color(1, 1, 1, 1)
	z_index = 0
	rotation = 0
	scale = Vector2(1, 1)

func get_transformed_tiles():
	var transformed_tiles = Array(tiles)
	var angle = int(round(global_rotation_degrees / 90))
	var flip = scale.x < 0
	for i in range(transformed_tiles.size()):
		var tile = transformed_tiles[i]
		var tile_x = tile.x
		match angle:
			1:
				tile.x = -tile.y
				tile.y = tile_x
			-2:
				tile.x = -tile.x
				tile.y = -tile.y
			-1:
				tile.x = tile.y
				tile.y = -tile_x
		if flip:
			tile.x = -tile.x
		transformed_tiles[i] = tile
	return transformed_tiles
