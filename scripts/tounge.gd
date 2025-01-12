extends Area2D
class_name Tounge

@export var tounge_time: float = 3
@onready var tounge_timer = $Timer
@export var max_length: float = 400
@export var extend_speed: float = 1
var target_length: float = 0

func is_ready() -> bool:
	return true

func extend_tounge():
	target_length = max_length
	tounge_timer.timeout.connect(retract_tounge)
	tounge_timer.start(tounge_time)

func retract_tounge():
	target_length = 0

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if scale.y != target_length:
		scale.y = lerp(scale.y, target_length, extend_speed * delta)
