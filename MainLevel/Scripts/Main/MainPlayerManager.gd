extends Node

# Inputs and multiplayer stuff
#@onready var player_manager = $PlayerManager #res://Player/Scripts/Inputs/PlayerDeviceManager.gd
var player_manager := preload("res://Player/Scripts/Inputs/PlayerDeviceManager.gd").new()
# map from player integer to the player node
var player_nodes = {}




func _ready() : 
	player_manager.player_joined.connect(spawn_player)
	player_manager.player_left.connect(delete_player)

func _process(_delta):
	player_manager.handle_join_input()

func spawn_player(player: int):
	# create the player node
	var player_scene = load("res://Player/Player_walking.tscn")
	var player_node = player_scene.instantiate()

	player_node.leave.connect(on_player_leave)
	player_nodes[player] = player_node
	
	# let the player know which device controls it
	var device = player_manager.get_player_device(player)
	player_node.init(player, device)
	# add the player to the tree
	add_child(player_node)
	# spawn position
	if (player_node.isLeftSide):
		player_node.position = Vector2(randf_range(100, 500), 500)
	else:
		player_node.position = Vector2(randf_range(1000, 1500), 500)
		
func delete_player(player: int):
	player_nodes[player].desinit()
	player_nodes[player].queue_free()
	player_nodes.erase(player)

func on_player_leave(player: int):
	# just let the player manager know this player is leaving
	# this will, through the player manager's "player_left" signal,
	# indirectly call delete_player because it's connected in this file's _ready()
	player_manager.leave(player)
