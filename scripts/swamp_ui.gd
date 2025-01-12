extends CanvasLayer
class_name SwampUI

@onready var points_label: Label = $MarginContainer/PanelContainer/MarginContainer/GridContainer/points
func update_point_counter(points: int):
	points_label.text = str(points)

@onready var notifiaction_container: MarginContainer = $NotificationContainer
@onready var notification_box: PanelContainer = $NotificationContainer/NotificationBox
@onready var notification_text: Label = $NotificationContainer/NotificationBox/GridContainer/MarginContainer/NotificationText
@onready var notification_timer: Timer = $NotificationContainer/Timer
@onready var notification_progress: TextureProgressBar = $NotificationContainer/NotificationBox/GridContainer/ProgressBar
func notify(msg: String, duration: int = 3, color: Color = Color.SEA_GREEN, pg_color: Color = Color.PALE_GREEN):
	notification_text.text = msg
	
	var panel_style: StyleBoxFlat = StyleBoxFlat.new()
	panel_style.bg_color = color
	panel_style.bg_color.a = 0.7
	notification_box.add_theme_stylebox_override("panel", panel_style)
	
	notification_progress.max_value = duration * 100
	
	notifiaction_container.visible = true
	notification_timer.timeout.connect(func(): notifiaction_container.visible = false)
	notification_timer.start(duration)

var player: Player
var target: Node2D
@onready var arrow_container: MarginContainer = $ArrowContainer
@onready var arrow: TextureRect = $ArrowContainer/Arrow
func show_direction_to(new_target: Node2D):
	print(new_target.position)
	target = new_target
	arrow_container.visible = true

func _process(delta: float):
	notification_progress.value = notification_timer.time_left * 100
	if arrow_container.visible:
		arrow.pivot_offset = arrow.size / 2
		var direction = player.global_position - target.global_position
		arrow.rotation = atan2(direction.y, direction.x) - PI / 2
