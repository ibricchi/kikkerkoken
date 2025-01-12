extends CanvasLayer
class_name SwampUI

# GENERALLY USEFUL VARS
var player: Player
var camera: Camera2D

#
# POINTS UI ELEMENT
# 
@onready var points_label: Label = $MarginContainer/PanelContainer/MarginContainer/GridContainer/points
func update_point_counter(points: int, points_to_next: int):
	points_label.text = "%d / %d" % [points, points_to_next]

#
# TOUNGE COOLDOWN UI ELEMEENT
#
@onready var tounge_img: TextureRect = $MarginContainer/PanelContainer/MarginContainer/GridContainer/tounge_img
@onready var tounge_level: Label = $MarginContainer/PanelContainer/MarginContainer/GridContainer/tounge
func tounge_cooldown(level: float):
	if not tounge_img.visible:
		tounge_img.visible = true
	if not tounge_level.visible:
		tounge_level.visible = true
	tounge_level.text = "%d%s" % [round((level) * 100), "%"]

#
# NOTIFICATION SYSTEM
#
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
func process_notification(delta: float):
	notification_progress.value = notification_timer.time_left * 100

#
# ARROW SYSTEM
#
@onready var arrow_container: MarginContainer = $ArrowContainer
@onready var arrow: TextureRect = $ArrowContainer/Arrow
var target: Node2D

func show_direction_to(new_target: Node2D):
	target = new_target
	arrow_container.visible = true
func disable_directions():
	arrow_container.visible = false
func process_arrow(delta: float):
	if arrow_container.visible:
		arrow.pivot_offset = arrow.size / 2
		var direction = player.global_position - target.global_position
		arrow.rotation = atan2(direction.y, direction.x) - PI / 2

#
# Connext to level signals
#
func connect_to_swamp_level_signals(level: SwampLevel):
	level.points_changed.connect(update_point_counter)

#
# Connect to player signals
#
func connect_to_player_signals(player: Player):
	player.tounge.tounge_cooldown_level.connect(tounge_cooldown)

func _process(delta: float):
	process_notification(delta)
	process_arrow(delta)
