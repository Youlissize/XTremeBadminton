extends Node2D

func _ready() -> void:
	#	TileMapLayer functions
	#clear
	#erase_cell(position)
	# set_cell(position, atlas, atlasCoord)
	# get_cell_atlas_coords(coords: Vector2i)
	get_node("TileMapLayer").set_cell(Vector2(0,0), 0, Vector2(1,1))
