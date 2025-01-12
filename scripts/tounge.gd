extends Node2D
class_name Tounge

# config
@export var tounge_time: float = 3
@export var tounge_extend_speed: float = 1
@export var tounge_retract_speed: float = 1
@export var max_length: float = 3
@export var tounge_cooldown: float = 5

# children
@onready var tounge_timer = $Timer
@onready var tounge_reset_timer = $Timer2
@onready var tounge_area = $tounge_area

# signals
signal tounge_cooldown_level(level)

# internal
var tounge_out: bool = false
var tounge_ready: bool = true
var tounge_tween: Tween = create_tween()
var caputred_fly_original_parent: Node2D
var caputred_flies: Array[Fly] = []

func is_ready() -> bool:
	return tounge_ready

func extend_tounge():
	if tounge_tween.is_valid():
		tounge_tween.kill()
	tounge_tween = create_tween()
	tounge_tween.tween_property(tounge_area, "scale", Vector2(max_length, max_length), tounge_extend_speed)
	
	tounge_out = true
	tounge_ready = false
	tounge_timer.timeout.connect(retract_tounge)
	tounge_timer.start(tounge_time)

func retract_tounge():
	if tounge_tween.is_valid():
		tounge_tween.kill()
	tounge_tween = create_tween()
	tounge_tween.tween_property(tounge_area, "scale", Vector2(0, 0), tounge_retract_speed)
	
	release_flies()
	tounge_cooldown_level.emit(0.0)
	tounge_out = false
	tounge_reset_timer.timeout.connect(func():
		tounge_ready = true
		print("emitted here1")
		tounge_cooldown_level.emit(1.0)
	)
	tounge_reset_timer.start(tounge_cooldown)

func capture_fly(obj: Node):
	if obj is Fly and obj not in caputred_flies and tounge_out:
		var fly: Fly = obj
		fly.freeze()
		var gp = fly.global_position
		caputred_fly_original_parent = fly.get_parent()
		caputred_flies.push_back(fly)
		caputred_fly_original_parent.remove_child(fly)
		add_child(fly)
		fly.global_position = gp

func release_flies():
	for child in get_children():
		if child is Fly:
			var fly: Fly = child
			var gp = fly.global_position
			fly.get_parent().remove_child(fly)
			caputred_fly_original_parent.add_child(fly)
			fly.unfreeze()
			fly.global_position = gp
	caputred_flies = []

func _ready() -> void:
	tounge_area.body_entered.connect(capture_fly)

func _process(delta: float) -> void:
	if tounge_out:
		tounge_cooldown_level.emit(tounge_timer.time_left / tounge_time)
	elif not tounge_ready:
		tounge_cooldown_level.emit(1 - tounge_reset_timer.time_left / tounge_cooldown)
