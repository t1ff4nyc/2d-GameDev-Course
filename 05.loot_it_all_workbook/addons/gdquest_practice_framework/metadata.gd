## Saves and loads metadata for practices using the ConfigFile format of Godot.
extends RefCounted

## The path to the file containing the metadata of all practices.
const PATH := "res://addons/gdquest_practice_framework/practice_solutions/metadata.cfg"


## Represents the metadata of a practice.
class PracticeMetadata:
	var lesson_number := 0
	var practice_number := 0
	var id := ""
	var title := ""
	var main_scene := ""

	func _to_string() -> String:
		return (
			'{ "id": %s, "lesson_number": %d, "practice_number": %d, "title": %s, "main_scene": %s }'
			% [id, lesson_number, practice_number, title, main_scene]
		)



## Loads the metadata of all practices contained in a config file.
static func load() -> Array[PracticeMetadata]:
	var result: Array[PracticeMetadata] = []
	var cfg := ConfigFile.new()
	var error_code := cfg.load(PATH)
	if error_code != OK:
		push_error(
			"Failed to load practices metadata file '%s', error code: %d" % [PATH, error_code]
		)
		return result

	var lesson_number := 0
	var practice_number := 1
	for section in cfg.get_sections():
		var metadata := PracticeMetadata.new()
		metadata.id = section
		for key in cfg.get_section_keys(section):
			metadata.set(key, cfg.get_value(section, key))

		if lesson_number != metadata.lesson_number:
			lesson_number = metadata.lesson_number
			practice_number = 1
		metadata.practice_number = practice_number
		practice_number += 1
		result.push_back(metadata)
	return result


static func get_modified_time() -> int:
	return FileAccess.get_modified_time(PATH)
