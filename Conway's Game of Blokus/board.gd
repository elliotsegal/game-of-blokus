extends Node2D

signal advance_turn

const board_size = 20
var tiles = []
var player_manager
var score_list
var can_place = true

var tile_scene = preload("res://tile.tscn")
var neighbor_tiles = [Vector2(-1, -1), Vector2( 0, -1), Vector2( 1, -1),
					  Vector2(-1,  0),                  Vector2( 1,  0),
					  Vector2(-1,  1), Vector2( 0,  1), Vector2( 1,  1)]

func _ready():
	player_manager = get_node(@"/root/Node2D/Players")
	score_list = get_node(@"/root/Node2D/Scores")
	tiles.resize(board_size * board_size)

func get_tile(x, y):
	return tiles[(y * board_size) + x]

func set_tile(x, y, val, bump = false):
	var current_tile = get_tile(x, y)
	if val > 0 and current_tile == null:
		var node = tile_scene.instance()
		node.position = Vector2(x * 32, y * 32)
		node.set_player(val)
		add_child(node)
		tiles[(y * board_size) + x] = node
		if bump:
			node.bump()
	elif val <= 0 and current_tile != null:
		current_tile.queue_free()
		tiles[(y * board_size) + x] = null
	elif val > 0 and val != current_tile.player:
		current_tile.set_player(val)
		if bump:
			current_tile.bump()

func count_neighbors(x, y):
	var count = 0
	var player_list = [0, 0, 0, 0]
	for neighbor in neighbor_tiles:
		var lx = x + neighbor.x
		var ly = y + neighbor.y
		if not (lx < 0 or lx >= board_size or ly < 0 or ly >= board_size):
			var tile = get_tile(lx, ly)
			if tile != null:
				count += 1
				player_list[tile.player - 1] += 1
	return {
		count = count,
		player = player_list.find(player_list.max()) + 1
	}

func can_place_piece(piece, x, y):
	if !can_place:
		return false
	for tile in piece.get_transformed_tiles():
		# Check in-bounds
		var lx = x + tile.x
		var ly = y + tile.y
		if lx < 0 or lx >= board_size or ly < 0 or ly >= board_size:
			return false
		# Check unoccupied
		if get_tile(lx, ly) != null:
			return false
		# Check valid placement
		# TODO
	return true

func place_piece(piece, x, y):
	for tile in piece.get_transformed_tiles():
		set_tile(x + tile.x, y + tile.y, piece.player)
	can_place = false
	yield(get_tree().create_timer(0.75), "timeout")
	$Conway.tick(self)
	update_scores()
	yield(get_tree().create_timer(0.5), "timeout")
	player_manager.advance_turn()
	emit_signal("advance_turn")
	can_place = true

func update_scores():
	var player_scores = [0, 0, 0, 0]
	for tile in tiles:
		if tile != null:
			player_scores[tile.player - 1] += 1
	for idx in range(4):
		score_list.get_child(idx).text = "Player %d Score: %d" % [idx + 1, player_scores[idx]]
	return player_scores
