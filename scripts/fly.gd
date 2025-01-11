extends RigidBody2D

var wander_orientation : float = 0
var wander_time : float = 3.0 
var rotation_speed : float = 2
var cruise_velocity : float = 40

@onready var _animated_sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.modulate = Color( 1 - 0.4 *randf(),1 - 0.4 *randf(),1 - 0.4 *randf() )
	wander_orientation =  randf() * (2 * PI)
	linear_damp = 0.5
	_animated_sprite.play("fly")
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	self.rotation = lerp_angle(self.global_rotation , self.wander_orientation, rotation_speed * delta)
	wander_time -= delta
	if wander_time < 0:
		wander_time = 5.0 * randf() + 1.5
		wander_orientation =  randf() * (2 * PI)
		cruise_velocity = 20 + randf()*40
		_animated_sprite.speed_scale = cruise_velocity / 40
	 
	self.move_and_collide(
		delta*cruise_velocity * tanh(wander_time)
		* Vector2(cos(self.global_rotation), sin(self.global_rotation),))
	
