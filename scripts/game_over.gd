extends Control

@onready var result: Label = $CenterContainer/GridContainer/Label
@onready var back_button: Button = $CenterContainer/GridContainer/MarginContainer/Button

func main_menu():
	get_tree().change_scene_to_file("res://start.tscn")

var high_score_path = "user://high_score.ini"
# To load data
func ld():
	var config_file = ConfigFile.new()
	config_file.load("user://last_score.ini")
	var score: int = config_file.get_value("game", "time")
	print("score", score)
	result.text = "Congrats, you grew up in: %d s" % (float(score) * 0.001)
	
	var cc_f = ConfigFile.new()
	if cc_f.load("user://high_score.ini") != OK:
		var asd = ConfigFile.new()
		asd.set_value("game", "time", score)
		asd.save("user://high_score.ini")
	else:
		var high_score = cc_f.get_value("game", "time")
		if score < high_score:
			cc_f.set_value("game", "time", score)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ld()
	back_button.button_up.connect(main_menu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
