extends Node

@export var number_to_spwan: int = 10
@export var random_x_start: int = 0
@export var random_x_end: int = 500
@export var random_y_start: int = 0
@export var random_y_end: int = 300

@onready var fly_res: Resource = preload("res://scenes/fly.tscn")

var flies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello")
	for i in range(number_to_spwan):
		var fly = fly_res.instantiate()
		var x = randf_range(random_x_start, random_x_end)
		var y = randf_range(random_y_start, random_y_end)
		add_child(fly)
		fly.position = Vector2(x, y)
		flies.push_back(flies)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
