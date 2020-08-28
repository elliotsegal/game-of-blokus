extends Node

const board_size = 20
var new_tiles = []

func _ready():
	new_tiles.resize(board_size * board_size)

func get_tile(x, y):
	return new_tiles[(y * board_size) + x]
	
func set_tile(x, y, val):
	new_tiles[(y * board_size) + x] = val

func tick(board):
	for y in range(board_size):
		for x in range(board_size):
			var tile = board.get_tile(x, y)
			var alive = tile != null
			var player = 0
			var neighbors = board.count_neighbors(x, y)
			if alive:
				player = tile.player
				if neighbors.count < 2 or neighbors.count > 3:
					alive = false
			else:
				if neighbors.count == 3:
					alive = true
					player = neighbors.player
			if alive:
				set_tile(x, y, player)
			else:
				set_tile(x, y, 0)
	for y in range(board_size):
		for x in range(board_size):
			board.set_tile(x, y, get_tile(x, y), true)
