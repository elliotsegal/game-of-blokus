extends Node2D

var current_player = 1
onready var turn_intro = get_node(@"/root/Node2D/AnimationPlayer")
onready var score_list = get_node(@"/root/Node2D/Scores")

func _ready():
	show_turn_intro()

func show_turn_intro():
	var turn_intro_label = turn_intro.get_node(@"Popup/Label")
	var text_player = current_player
	if get_child(current_player - 1).get_child_count() == 0:
		text_player = get_winner()
		turn_intro_label.text = "Player %d Wins!" % text_player
	else:
		turn_intro_label.text = "Player %d's Turn" % current_player
	turn_intro_label.add_color_override("font_color", score_list.get_child(text_player - 1).get_color("font_color"))
	turn_intro.play("NextTurn")

func advance_turn():
	current_player += 1
	if current_player > 4:
		current_player = 1
	for player_idx in range(get_child_count()):
		get_child(player_idx).visible = (player_idx + 1) == current_player
	show_turn_intro()

func get_winner():
	var scores = get_node(@"/root/Node2D/Board").update_scores()
	return scores.find(scores.max()) + 1
