extends CharacterBody2D

@export var max_speed: int = 200
@export var acceleartion: float = 0.01
@export var deceleration: float = 0.03

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
	if (input == Vector2.ZERO):
		velocity -= velocity * deceleration
	else:
		var speed = velocity.length()
		var new_speed = clampf(speed + max_speed * acceleartion, 0, max_speed)
		velocity = input * new_speed
		rotation = atan2(input.y, input.x)
	move_and_slide()
