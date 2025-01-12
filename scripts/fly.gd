extends RigidBody2D
class_name Fly

var wander_orientation : float = 0
var wander_time : float = 3.0 
var rotation_speed : float = 2
var cruise_velocity : float = 80
var frozen: bool = false

@onready var _animated_sprite = $AnimatedSprite2D
@onready var vision_area = $VisionArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vision_area.area_entered.connect( avoid_detected_object )
	
	self.modulate = Color( 1 - 0.4 *randf(),1 - 0.4 *randf(),1 - 0.4 *randf() )
	wander_orientation =  randf() * (2 * PI)
	linear_damp = 0.5
	_animated_sprite.play("fly")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not frozen:
		self.rotation = lerp_angle(self.global_rotation , self.wander_orientation, rotation_speed * delta)
		wander_time -= delta
		if wander_time < 0:
			wander_time = 1.0 * randf() + 4.0
			wander_orientation =  randf() * (2 * PI)
			cruise_velocity = 60 + randf()*60
			_animated_sprite.speed_scale = cruise_velocity / 80
		
		self.move_and_collide(
			delta*cruise_velocity * tanh(wander_time)
			* Vector2(cos(self.global_rotation), sin(self.global_rotation),))

func avoid_detected_object(obj):
	wander_orientation = wander_orientation + PI
	wander_time += 3.0

func freeze():
	frozen = true
func unfreeze():
	frozen = false
