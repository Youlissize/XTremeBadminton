extends Node

# Inputs and multiplayer stuff
#@onready var player_manager = $PlayerManager #res://Player/Scripts/Inputs/PlayerDeviceManager.gd
var player_manager := preload("res://Player/Scripts/Inputs/PlayerDeviceManager.gd").new()
# map from player integer to the player node
#var player_nodes = {}
var player_selector_nodes = {}
#const player_scene = preload("res://Player/Player_walking.tscn")
const player_selector_scene = preload("res://Player/Scripts/PlayerSelector.tscn")



func _ready() : 
	player_manager.player_joined.connect(spawn_player)
	player_manager.player_left.connect(delete_player)

func _process(_delta):
	player_manager.handle_join_input()

func spawn_player(player: int):
		#Spawn player selector
	var player_selector_node = player_selector_scene.instantiate()
	add_child(player_selector_node)

	var isLeftSide := player%2==0;
	# spawn position
	if (isLeftSide):
		player_selector_node.position = Vector2(randf_range(100, 500), 500)
	else:
		player_selector_node.position = Vector2(randf_range(1500, 2000), 500)
		
	var device = player_manager.get_player_device(player)
	player_selector_node.init(player, device)
	player_selector_node.leave.connect(on_player_leave)
	
	player_selector_nodes[player] = player_selector_node
	
	
	



func delete_player(player: int):
	#player_nodes[player].desinit()
	#player_nodes[player].queue_free()
	#player_nodes.erase(player)
	#TODO : delete player_selector
	player_selector_nodes[player].desinit()
	player_selector_nodes[player].queue_free()
	player_selector_nodes.erase(player)

func on_player_leave(player: int):
	# just let the player manager know this player is leaving
	# this will, through the player manager's "player_left" signal,
	# indirectly call delete_player because it's connected in this file's _ready()
	player_manager.leave(player)
