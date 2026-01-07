extends Node

var data := preload("res://MainLevel/Scripts/mapData.gd").new()
var mapName = "mapTest"

@export var player1: CharacterBody2D
@export var ground: StaticBody2D
#@export var map : mapData

var screenWidth = 1920
var screenHeight = 1080
var currentHeight : float
var currentWidth : float

func _ready() -> void:
	
	if (true): #custom map
		data.filetPos = 0.5
		data.filetSize = 5
		data.width = 30
		data.mapName = mapName
		data.save_map()
	
	
	if (data.load_map(mapName)):
		buildMap()
	else:
		print("Failed to load map : ", mapName)
	
	if(player1):
		player1.set("ground", ground)




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
	
