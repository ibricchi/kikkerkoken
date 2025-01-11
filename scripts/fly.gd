extends RigidBody2D

var wander_orientation : float = 0
var wander_time : float = 4.0 
var rotation_speed : float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wander_orientation =  randf() * (2 * PI)
	linear_damp = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	self.rotation = lerp_angle(self.global_rotation , self.wander_orientation, rotation_speed * delta)
	wander_time -= delta
	if wander_time < 0:
		wander_time = 4.0
		wander_orientation =  randf() * (2 * PI)