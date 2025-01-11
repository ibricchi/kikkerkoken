extends Area2D

func _ready():
	self.monitoring = false

@export var body_entered_callback: Callable: set = set_callback

func set_callback(callback: Callable):
	self.body_entered.connect(callback)
	self.monitoring = true
