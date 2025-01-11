extends Area2D
class_name FlyTrap

func _ready():
	self.monitoring = false

@export var body_entered_callback: Callable:
	set(callback):
		self.body_entered.connect(callback)
		self.monitoring = true
		body_entered_callback = callback
