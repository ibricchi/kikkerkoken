extends CanvasLayer
class_name SwampUI

@onready var points_label: Label = $MarginContainer/PanelContainer/MarginContainer/GridContainer/points

func update_point_counter(points: int):
	points_label.text = str(points)
