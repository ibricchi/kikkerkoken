extends Control

@onready var back_button: Button = $CenterContainer/GridContainer/MarginContainer/Button

func main_menu():
	get_tree().change_scene_to_file("res://start.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.button_up.connect(main_menu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
