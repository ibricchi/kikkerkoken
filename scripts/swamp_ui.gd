extends CanvasLayer
class_name SwampUI

@onready var points_label: Label = $MarginContainer/PanelContainer/MarginContainer/GridContainer/points
func update_point_counter(points: int):
	points_label.text = str(points)

@onready var notifiaction_container: MarginContainer = $NotificationContainer
@onready var notification_box: PanelContainer = $NotificationContainer/NotificationBox
@onready var notification_text: Label = $NotificationContainer/NotificationBox/MarginContainer/NotificationText
@onready var notification_timer: Timer = $NotificationContainer/Timer
func notify(msg: String, duration: int = 3, color: Color = Color.SEA_GREEN):
	notification_text.text = msg
	notifiaction_container.visible = true
	notification_timer.timeout.connect(func(): notifiaction_container.visible = false)
	notification_timer.start(duration)
