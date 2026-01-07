extends Node

var mapName := "Default"
var width : int = 20
var height : int = 14
var filetPos := 0.5
var filetSize := 3.5
# var gravity := 1
# var staticObjects -> décor et autres trucs fixes
# var floatingObjects 
# var powerUps
# var playerStrength := 1.0
# var gameSpeed := 1.0
# var playerSpeed := 1.0



# Maps goes in %AppData%\Roaming\Godot\app_userdata\XTremeBadminton\
func save() -> Dictionary:
	var save_dict = {
		#"mapName" : mapName, 
		"width" : width,
		"height" : height,
		"filetPos" : filetPos,
		"filetSize" : filetSize
	}
	return save_dict
	
	# Note: This can be called from anywhere inside the tree. This function is

func save_map():
	if (!DirAccess.dir_exists_absolute("user://maps")):
		DirAccess.make_dir_absolute("user://maps")
		print("Create Map Folder")
	
	var save_file = FileAccess.open("user://maps//" + mapName + ".xbm", FileAccess.WRITE)

		# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(save())

		# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)
	print("Saving map : ", mapName)
	print("--datas : ", json_string)

func load_map(name : String) -> bool:
	var path = name
	if (!name.ends_with(".xbm")):
		path = path + ".xbm"
	path = "user://maps//"+path
	if not FileAccess.file_exists(path):
		return false# Error! We don't have a save to load.
	
	var save_file = FileAccess.open(path, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data

		print("Loading map : ", name)
		print(" -- datas : ", node_data)
		
		mapName = name
		# self prends toutes les valeurs du fichier
		for attribute in node_data.keys():
			self.set(attribute, node_data[attribute])
	return true
