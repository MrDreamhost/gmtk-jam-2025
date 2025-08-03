class_name LevelCompletePanel extends PanelContainer

signal retry_level()
signal next_level()

@export var data: Data : set = set_data
@export var screen_border_margin := 0.0
@export var slide_duration_sec := 0.5

@onready var time_value: Label = %TimeValue
@onready var fastes_time_value: Label = %FastesTimeValue
@onready var resets_value: Label = %ResetsValue
@onready var loops_value: Label = %LoopsValue
@onready var dev_record_value: Label = %DevRecordValue
@onready var game_width := get_viewport().get_visible_rect().size.x

var slide_from_right_side := false


func _ready() -> void:
	set_data(data)


func set_data(_data: Data) -> void:
	data = _data
	if data == null or not is_node_ready():
		return
	time_value.text = format_as_time(data.time)
	fastes_time_value.text = format_as_time(data.fastes_time)
	resets_value.text = str(data.reset_count)
	loops_value.text = str(data.loop_count)
	dev_record_value.text = format_as_time(data.dev_record_time)


func play_slide_in_from_side_animation(player_position: Vector2) -> void:
	visible = true
	slide_from_right_side = player_position.x < (game_width / 2.0)
	var slide_path_x := get_slide_path_x()
	var tween := create_tween()
	tween.tween_property(self, "position:x", slide_path_x[0], slide_duration_sec) \
			.from(slide_path_x[1]) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)


func play_slide_out_animation() -> void:
	var slide_path_x := get_slide_path_x()
	var tween := create_tween()
	tween.tween_property(self, "position:x", slide_path_x[1], slide_duration_sec) \
			.from(slide_path_x[0]) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(func (): self.visible = false)


func get_slide_path_x() -> Vector2:
	var outside_x: float
	var inside_x: float 
	if slide_from_right_side:
		outside_x = game_width         + screen_border_margin
		inside_x = game_width - size.x - screen_border_margin
	else:
		outside_x = 0.0 - screen_border_margin
		inside_x = 0.0  + screen_border_margin
	return Vector2(inside_x, outside_x)


func _on_next_level_button_pressed() -> void:
	next_level.emit()
	play_slide_out_animation()

func _on_retry_button_pressed() -> void:
	retry_level.emit()
	play_slide_out_animation()


static func format_as_time(total_seconds: float) -> String:
	var minutes := floori(int(total_seconds) / 60.0)
	var seconds := int(total_seconds) % 60
	var milliseconds := int((total_seconds - int(total_seconds)) * 1000)
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]


class Data extends Resource:
	
	@export_file("*.tscn") var level_file
	@export var time := 0.0
	@export var fastes_time := 0.0
	@export var dev_record_time := 0.0
	@export var reset_count := 0
	@export var loop_count := 0
	@export var death_count := 0
