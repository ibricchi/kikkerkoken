extends Node

# Control vars
@export var number_to_spwan: int = 20
@export var random_x_start: int = 0
@export var random_x_end: int = 1000
@export var random_y_start: int = 0
@export var random_y_end: int = 500

# Children
@onready var point_trap: FlyTrap = $point_trap
@onready var ui: SwampUI = $UI
@onready var player: Player = $player

# Internal values
var flies = []
var points_to_next_part: int = 1;
var ptnp_mult: float = 2;
var points: int = 0:
	set(new_points):
		points = new_points
		if not body_part_available and points >= points_to_next_part:
			points -= points_to_next_part
			points_to_next_part *= ptnp_mult
			release_a_new_part()
		ui.update_point_counter(points)
var in_order_parts: Array[Callable] = [
	BodyPart.create_eye,
]
var body_parts: Array[Callable] = [
	BodyPart.create_eye,
	BodyPart.create_tounge,
]
var body_part_available: bool = false
var target_body_part: BodyPart
var seen_first_eye: bool = false

func spawn_fly():
	var fly: Fly = preload("res://scenes/fly.tscn").instantiate()
	self.add_child(fly)
	fly.position = Vector2(
		randf_range(random_x_start, random_x_end),
		randf_range(random_y_start, random_y_end)
	)
	flies.push_back(fly)

func release_a_new_part():
	if len(body_parts) > 0:
		var new_part: BodyPart
		if len(in_order_parts) != 0:
			new_part = in_order_parts.pop_front().call()
		else:
			var new_part_idx: int = randi() % len(body_parts)
			new_part = body_parts.pop_at(new_part_idx).call()
		new_part.on_attached.connect(part_attached_callback)
		add_child(new_part)
		new_part.position = Vector2(
			randf_range(random_x_start, random_x_end),
			randf_range(random_y_start, random_y_end)
		)
		ui.show_direction_to(new_part)
		ui.notify("Congrats you unlocked a new part, go find your new %s!" % new_part.name)
		body_part_available = true
		target_body_part = new_part

func part_attached_callback(type):
	body_part_available = false
	if type == BodyPart.PartType.EYE and not seen_first_eye:
		ui.notify("Wow! now that's a lot better, I can see so much more")
		seen_first_eye = true
	if type == BodyPart.PartType.TOUNGE:
		ui.notify("Press space to use your new sticky tounge!")

func entered_point_trap(fly: Node2D):
	if fly is Fly:
		flies.erase(fly)
		self.remove_child(fly)
		fly.queue_free()
		points += 1
		spawn_fly()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup ui
	points = 0
	ui.player = player
	
	# spwan flies
	for i in number_to_spwan:
		spawn_fly()
		
	# set callback for fly trap
	point_trap.body_entered_callback = entered_point_trap


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if body_part_available and target_body_part.is_on_screen():
		ui.disable_directions()
