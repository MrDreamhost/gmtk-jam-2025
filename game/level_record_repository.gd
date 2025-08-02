class_name LevelRecordRepository extends Node

const PLAYER_RECORD_FILE := "user://level_records.json"

var dev_records: Dictionary[String, LevelRecord] = {}
var player_records: Dictionary[String, LevelRecord] = {}


func _ready() -> void:
	call_deferred("load_dev_records")
	call_deferred("load_player_records")


func load_dev_records() -> void:
	dev_records = load_records("res://game/dev_level_records.json")

func load_player_records() -> void:
	player_records = load_records(PLAYER_RECORD_FILE)


func add_record_and_return_total(record: LevelRecord) -> LevelRecord:
	var saved_record: LevelRecord = player_records.get(record.level_file) as LevelRecord
	if saved_record == null:
		saved_record = LevelRecord.new()
		saved_record.level_file = record.level_file
		player_records.set(record.level_file, saved_record)
	
	if record.time < saved_record.time:
		saved_record.time = record.time
		saved_record.loop_count = record.loop_count
	
	saved_record.total_time += record.total_time
	saved_record.total_loop_count += record.total_loop_count
	saved_record.total_death_count += record.total_death_count
	saved_record.total_reset_count += record.total_reset_count
	save_records(PLAYER_RECORD_FILE, player_records)
	return saved_record


func load_records(path: String) -> Dictionary[String, LevelRecord]:
	var file_access := FileAccess.open(path, FileAccess.READ)
	var dic: Dictionary[String, LevelRecord]= {}
	if file_access == null:
		return dic
	
	while true:
		var line := file_access.get_line()
		if not line:
			break
		var level_stats := LevelRecord.new()
		if level_stats.parse_from_json(line):
			dic.set(level_stats.level_file, level_stats)
		else:
			push_warning("could not read LevelStatistic from: " + line)
	file_access.close()
	return dic


func save_records(path: String, records: Dictionary[String, LevelRecord]) -> bool:
	var file_access := FileAccess.open(path, FileAccess.WRITE)
	if not file_access:
		return false
	for record: LevelRecord in records.values():
		var recprd_json := record.write_as_json()
		file_access.store_line(recprd_json)
	file_access.close()
	return true


class LevelRecord extends Resource:
	
	@export_file("*.tscn") var level_file
	@export var time := 4_000.0
	@export var loop_count := 0
	
	@export var total_time := 0.0
	@export var total_loop_count := 0
	@export var total_death_count := 0
	@export var total_reset_count := 0
	
	
	func write_as_json() -> String:
		var dic := {
			"level_file": level_file,
			"time": time,
			"total_time": total_time,
			"loop_count": loop_count,
			"total_loop_count": total_loop_count,
			"total_death_count": total_death_count,
			"total_reset_count": total_reset_count,
		}
		return JSON.stringify(dic)
	
	func parse_from_json(json: String) -> bool:
		var dic: Dictionary = JSON.parse_string(json)
		if dic == null:
			return false
		level_file = dic.get("level_file")
		time = dic.get("time", 0.0)
		total_time = dic.get("total_time", 0.0)
		loop_count = dic.get("loop_count", 0)
		total_loop_count = dic.get("total_loop_count", 0)
		total_death_count = dic.get("total_death_count", 0)
		total_reset_count = dic.get("total_reset_count", 0)
		return true
