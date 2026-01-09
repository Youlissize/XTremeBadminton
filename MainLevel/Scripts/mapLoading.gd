extends Node

const Globals := preload("res://MainLevel/Scripts/globalStuff.gd")
var data := preload("res://MainLevel/Scripts/mapData.gd").new()
var mapName = "mapTest"

# Inputs and multiplayer stuff
#@onready var player_manager = $PlayerManager #res://Player/Scripts/Inputs/PlayerDeviceManager.gd
var player_manager := preload("res://Player/Scripts/Inputs/PlayerDeviceManager.gd").new()
# map from player integer to the player node
var player_nodes = {}

@export var player1: CharacterBody2D
@export var ground: StaticBody2D
#@export var map : mapData

var screenWidth = 1920
var screenHeight = 1080
var currentHeight : float
var currentWidth : float

func _ready() -> void:
	
	#Create and Save custom map here
	if (true): 
		data.filetPos = 0.5
		data.filetSize = 3
		data.width = 30
		data.mapName = mapName
		data.save_map()
	
	# Load map
	if (data.load_map(mapName)):
		buildMap()
	else:
		print("Failed to load map : ", mapName)
	
	if(player1):
		player1.set("ground", ground)
		
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
	player_nodes[player].queue_free()
	player_nodes.erase(player)

func on_player_leave(player: int):
	# just let the player manager know this player is leaving
	# this will, through the player manager's "player_left" signal,
	# indirectly call delete_player because it's connected in this file's _ready()
	player_manager.leave(player)


# Generate the level from datas comming from map.xbm
func buildMap():
	var terrainRatio : float = data.width/data.height
	# pour le moment  ground = 250, celling = 100, il suffit d'adapter right et left
	currentHeight = screenHeight - 350
	currentWidth = currentHeight * terrainRatio
	var bodersWidth = (screenWidth - currentWidth)/2
	
	get_node("LeftBorder").position = Vector2(bodersWidth, 0)
	get_node("RightBorder").position = Vector2(screenWidth-bodersWidth, 0)
	
	var filet = get_node("Filet")
	var filetX = (screenWidth / 2) + currentWidth * (data.filetPos-0.5)
	filet.position = Vector2(filetX, screenHeight-250)
	filet.scale = Vector2(1.0,data.filetSize)
	
	Globals.ground = get_node("Ground/StaticBody2D")
