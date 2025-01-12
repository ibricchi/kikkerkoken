extends CharacterBody2D
class_name Player

# Controls
@export var max_speed: int = 200
@export var acceleartion: float = 0.9
@export var deceleration: float = 1.2
@export var push_force: float = 20000
@export var rotation_speed: float = 10
@export var zoom_time: float = 2
@export var initial_zoom: Vector2 = Vector2(3, 3)

# children
@onready var camera: Camera2D = $camera
@onready var tounge: Tounge = $tounge
@onready var left_eye = $left_eye
@onready var right_eye = $right_eye
@onready var left_back_leg = $left_back_leg
@onready var right_back_leg = $right_back_leg

# Internal info
var zoom: Vector2:
	set(_zoom):
		zoom = _zoom
		camera.zoom = zoom
var tounge_enabled: bool = false
var zoom_tween: Tween = create_tween()

func _ready() -> void:
	zoom = initial_zoom

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

func _process(delta):
	if tounge_enabled && Input.is_action_just_pressed("space"):
		if tounge.is_ready():
			tounge.extend_tounge()
		else:
			print("Tongue not ready")

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

func attach_body_part(obj: BodyPart):
	if obj.part_type == BodyPart.PartType.EYE:
		if zoom_tween.is_valid():
			zoom_tween.exit()
		zoom_tween = create_tween()
		zoom_tween.tween_property(self, "zoom", zoom / obj.zoom_multiplier, zoom_time)
		if not left_eye.visible:
			left_eye.visible = true
		else:
			right_eye.visible = true
	elif obj.part_type == BodyPart.PartType.TOUNGE:
		tounge_enabled = true
		tounge.visible = true
	elif obj.part_type == BodyPart.PartType.BACK_LEG:
		max_speed += obj.speed_modifier
		if not left_back_leg.visible:
			left_back_leg.visible = true
		elif not right_back_leg.visible:
			right_back_leg.visible = true
