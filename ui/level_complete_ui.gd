class_name LevelCompletePanel extends PanelContainer

signal retry_level()
signal next_level()

@export var dev_records: Dictionary[String, Data]
@export var data: Data : set = set_data

@onready var time_value: Label = %TimeValue
@onready var fastes_time_value: Label = %FastesTimeValue
@onready var resets_value: Label = %ResetsValue
@onready var loops_value: Label = %LoopsValue
@onready var dev_record_value: Label = %DevRecordValue


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


func _on_next_level_button_pressed() -> void:
	next_level.emit()

func _on_retry_button_pressed() -> void:
	retry_level.emit()


static func format_as_time(total_seconds: float) -> String:
	var minutes := floori(int(total_seconds) / 60.0)
	var seconds := int(total_seconds) % 60
	var milliseconds := int((total_seconds - int(total_seconds)) * 100)
	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]


class Data extends Resource:
	
	@export_file("*.tscn") var level_file
	@export var time := 0.0
	@export var fastes_time := 0.0
	@export var dev_record_time := 0.0
	@export var reset_count := 0
	@export var loop_count := 0
	@export var death_count := 0
