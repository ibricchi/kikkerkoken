extends Node

@export var number_to_spwan: int = 20
@export var random_x_start: int = 0
@export var random_x_end: int = 1000
@export var random_y_start: int = 0
@export var random_y_end: int = 500

@onready var fly_res: Resource = preload("res://scenes/fly.tscn")

@onready var point_trap: FlyTrap = $point_trap
@onready var ui: SwampUI = $UI

var flies = []
func spawn_fly():
	var fly = preload("res://scenes/fly.tscn").instantiate()
	self.add_child(fly)
	fly.position = Vector2(
		randf_range(random_x_start, random_x_end),
		randf_range(random_y_start, random_y_end)
	)
	flies.push_back(fly)

var points_to_next_part: int = 1;
var ptnp_mult: float = 2;
var points: int = 0:
	set(new_points):
		points = new_points
		if points >= points_to_next_part:
			points -= points_to_next_part
			points_to_next_part *= ptnp_mult
			release_a_new_part()
		ui.update_point_counter(points)

func release_a_new_part():
	ui.notify("Congrats you unlocked a new part, go find it!")
	pass

func entered_point_trap(fly: Node2D):
	if fly is Fly:
		flies.erase(fly)
		self.remove_child(fly)
		points += 1
		spawn_fly()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in number_to_spwan:
		spawn_fly()
	point_trap.body_entered_callback = entered_point_trap


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
