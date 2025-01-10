extends CharacterBody2D

@export var speed: int = 200
@export var dash_speed: int = 2000

func get_movement_input():
	var velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	return velocity.normalized()

func _physics_process(delta):
	velocity = get_movement_input() * speed
	move_and_slide()
