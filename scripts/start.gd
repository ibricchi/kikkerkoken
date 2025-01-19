extends Control

@onready var start_label: Button = $CenterContainer/GridContainer/MarginContainer/Button
@onready var instructions_label: Button = $CenterContainer/GridContainer/MarginContainer2/Label
@onready var best_time_label: Label = $CenterContainer/GridContainer/MarginContainer3/Label

var high_score_path = "user://high_score.ini"
#func save():
	#var config_file = ConfigFile.new()
	#config_file.set_value("game", "time", high_score_time)
	#var error = config_file.save(high_score_path)
	#if error:
		#print("error saving high_score: ", error)

# To load data
func ld():
	var config_file = ConfigFile.new()
	var error = config_file.load(high_score_path)
	if error:
		print("An error happened while loading data: ", error)
		best_time_label.text = "Best Time: N/A"
	else:
		var high_score: int = config_file.get_value("game", "time")
		best_time_label.text = "Best Time: %ds" % (float(high_score) * 0.001)

func start_game():
	get_tree().change_scene_to_file("res://swamp.tscn")

func instructions():
	get_tree().change_scene_to_file("res://instructions.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ld()
	start_label.button_up.connect(start_game)
	instructions_label.button_up.connect(instructions)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
