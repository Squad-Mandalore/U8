extends Node
class_name NameGenerator

var name_data = null

func _ready():
	# Load and parse the JSON once, when the game starts
	var file = FileAccess.open("res://assets/npcs/berlin_names.json", FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()

		var json = JSON.new()
		var data_to_send = ["a", "b", "c"]
		var error = json.parse(json_string)
		if error == OK:
			name_data = json.data
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	else:
		push_error("Could not open 'berlin_names.json' in NameGenerator.")

func get_random_name(gender: String) -> String:
	# Fallback name if something goes wrong
	var fallback_name = "Unknown Person"

	if not name_data:
		# If the file never loaded, return fallback
		return fallback_name

	# Pull lists from JSON
	var first_list := []
	var female_list := name_data["female_first_names"] as Array
	var male_list := name_data["male_first_names"] as Array
	var last_list := name_data["last_names"] as Array

	# Decide which first-name list to use
	match gender:
		"Male":
			first_list = male_list
		"Female":
			first_list = female_list
		"Diverse":
			# Combine both lists, or pick randomly from female or male
			first_list = female_list + male_list

	if first_list.size() == 0 or last_list.size() == 0:
		return fallback_name

	# Random picks
	var rand_first = first_list[randi() % first_list.size()]
	var rand_last  = last_list[randi() % last_list.size()]
	return rand_first + " " + rand_last
