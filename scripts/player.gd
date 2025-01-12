extends CharacterBody2D
class_name Player

@export var max_speed: int = 400
@export var acceleartion: float = 0.9
@export var deceleration: float = 1.2
@export var push_force: float = 20000
@export var rotation_speed: float = 10

@onready var camera: Camera2D = get_node("camera")
@export var zoom_speed: float = 1
@export var target_zoom: Vector2 = Vector2(3, 3)
@onready var zoom: Vector2 = target_zoom:
	set(_zoom):
		zoom = _zoom
		camera.zoom = zoom

func _ready() -> void:
	camera.zoom = zoom

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

var tounge_enabled: bool = false
@onready var tounge: Tounge = $tounge
func _process(delta):
	if zoom != target_zoom:
		zoom = lerp(zoom, target_zoom, zoom_speed * delta)
	
	if tounge_enabled && Input.is_action_just_pressed("space") && tounge.is_ready():
		tounge.extend_tounge()

func _physics_process(delta):
	var input = get_movement_input()
	
	var lerp_fact = acceleartion
	if (input == Vector2.ZERO):
		lerp_fact = deceleration
	
	var target_velocity = input * max_speed
	self.velocity = lerp(self.velocity, target_velocity, lerp_fact * delta)
	if (input != Vector2.ZERO):
		self.rotation = lerp_angle(self.rotation, atan2(self.velocity.y, self.velocity.x), rotation_speed * delta)
	 
	if self.velocity.length() < 15:
		$AnimatedSprite2D.play("idle")
	elif self.velocity.length() < 60:
		$AnimatedSprite2D.play("swim")
		$AnimatedSprite2D.speed_scale = 1
	else:
		$AnimatedSprite2D.play("swim")
		$AnimatedSprite2D.speed_scale = 1.6

	if move_and_slide():
		for i in get_slide_collision_count():
			var col = get_slide_collision(i)
			var obj = col.get_collider()
			if obj is RigidBody2D:
				obj.apply_force(-col.get_normal() * push_force * delta)

@onready var left_eye = $left_eye
@onready var right_eye = $right_eye
func attach_body_part(obj: BodyPart):
	if obj.part_type == BodyPart.PartType.EYE:
		target_zoom /= obj.zoom_multiplier
		if !left_eye.visible:
			left_eye.visible = true
		else:
			right_eye.visible = true
	elif obj.part_type == BodyPart.PartType.TOUNGE:
		tounge_enabled = true
		tounge.visible = true
