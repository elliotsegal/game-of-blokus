extends Node2D

export var player = 1

func _enter_tree():
	for child in get_children():
		child.player = player
