extends CharacterBody2D

@export var max_speed: int = 200
@export var acceleartion: float = 0.9
@export var deceleration: float = 1.2
@export var push_force: float = 20000
@export var rotation_speed: float = 10

var speed: Vector2 = Vector2.UP

func get_movement_input():
	var input = Vector2()
	if Input.is_action_pressed("right"):
		input.x += 1
	if Input.is_action_pressed("left"):
		input.x -= 1
	if Input.is_action_pressed("down"):
		input.y += 1
	if Input.is_action_pressed("up"):
		input.y -= 1
	return input.normalized()

func _physics_process(delta):
	var input = get_movement_input()
	
	var lerp_fact = acceleartion
	if (input == Vector2.ZERO):
		lerp_fact = deceleration
	
	var target_velocity = input * max_speed
	self.velocity = lerp(self.velocity, target_velocity, lerp_fact * delta)
	if (input != Vector2.ZERO):
		self.rotation = lerp_angle(self.rotation, atan2(self.velocity.y, self.velocity.x), rotation_speed * delta)
	
	if move_and_slide():
		var col = get_last_slide_collision()
		var obj = col.get_collider()
		if obj is RigidBody2D:
			obj.apply_force(-col.get_normal() * push_force * delta )
