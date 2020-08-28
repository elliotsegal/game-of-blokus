extends CollisionShape2D

var player = 1

func set_player(p):
	player = p
	var sprite = get_node(@"Node2D/Sprite")
	match p:
		1:
			sprite.region_rect = Rect2(0, 0, 32, 32)
		2:
			sprite.region_rect = Rect2(32, 0, 32, 32)
		3:
			sprite.region_rect = Rect2(0, 32, 32, 32)
		4:
			sprite.region_rect = Rect2(32, 32, 32, 32)

func bump():
	$AnimationPlayer.play("Bump")
