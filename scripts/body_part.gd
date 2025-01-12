extends Area2D
class_name BodyPart

enum PartType {
	EYE,
	TOUNGE,
}

@export var part_name: String
@export var part_type: PartType
@export var part_img: Resource:
	set(img):
		part_img = img
		print($Sprite2D)
		$Sprite2D.texture = img

@export var zoom_multiplier: int = 1

func is_on_screen() -> bool:
	return $VisibleOnScreenNotifier2D.is_on_screen()

signal on_attached(part_type: PartType)
func attach_to_player(obj):
	if obj is Player:
		obj.attach_body_part(self)
		get_parent().remove_child(self)
		on_attached.emit(part_type)
		self.queue_free()

func _ready():
	body_entered.connect(attach_to_player)

#
# Body part creation functions
#

static var bp_scene = preload("res://scenes/body_part.tscn")
static func create_eye() -> BodyPart:
	var part: BodyPart = bp_scene.instantiate()
	part.part_name = "eye"
	part.part_type = PartType.EYE
	part.part_img = preload("res://assets/eye.png")
	part.zoom_multiplier = 2
	return part

static func create_tounge() -> BodyPart:
	var part: BodyPart = bp_scene.instantiate()
	part.part_name = "tounge"
	part.part_type = PartType.TOUNGE
	part.part_img = preload("res://assets/tounge.png")
	return part
