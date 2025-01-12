extends Node2D
class_name BodyPart

@export var part_name: String
@export var part_img: Resource:
	set(img):
		part_img = img
		print($Sprite2D)
		$Sprite2D.texture = img

@export var zoom_multiplier: int = 1
