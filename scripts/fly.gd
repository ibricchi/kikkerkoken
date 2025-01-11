extends RigidBody2D

var wander_orientation : float = 0
var wander_time : float = 4.0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wander_orientation =  randf() * (2 * PI)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_rotation  = self.wander_orientation  
	wander_time -= delta
	if wander_time < 0:
		wander_time = 4.0
		wander_orientation =  randf() * (2 * PI)
