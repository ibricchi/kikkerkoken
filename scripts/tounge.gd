extends Area2D
class_name Tounge

@export var tounge_time: float = 3
@export var tounge_extend_speed: float = 1
@export var tounge_retract_speed: float = 1
@onready var tounge_timer = $Timer
@onready var starting_position: Vector2 = self.position
@export var max_length: float = 3

func is_ready() -> bool:
	return true

var tounge_tween: Tween = create_tween()
func extend_tounge():
	if tounge_tween.is_valid():
		tounge_tween.kill()
	tounge_tween = create_tween()
	tounge_tween.tween_property(self, "scale", Vector2(max_length, max_length), tounge_extend_speed)
	
	tounge_timer.timeout.connect(retract_tounge)
	tounge_timer.start(tounge_time)

func retract_tounge():
	if tounge_tween.is_valid():
		tounge_tween.kill()
	tounge_tween = create_tween()
	tounge_tween.tween_property(self, "scale", Vector2(0, 0), tounge_retract_speed)

func _ready() -> void:
	pass
