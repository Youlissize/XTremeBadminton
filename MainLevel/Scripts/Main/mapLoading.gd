extends Node

const Globals := preload("res://MainLevel/Scripts/Main/globalStuff.gd")
var data := preload("res://MainLevel/Scripts/Main/mapData.gd").new()
var badMatch := preload("res://MainLevel/Scripts/Match/badMatch.gd").new()
var mapName = "mapTest"


var screenWidth = 1920
var screenHeight = 1080
var currentHeight : float
var currentWidth : float

func _ready() -> void:
	Globals.level = self
	Globals.currentMatch = badMatch
	#Create and Save custom map here
	if (true): 
		data.filetPos = 0.5
		data.filetSize = 4
		data.width = 25
		data.height = 15
		data.mapName = mapName
		data.save_map()
	
	# Load map
	if (data.load_map(mapName)):
		buildMap()
	else:
		print("Failed to load map : ", mapName)
	

var mapBlockSize = 64.0
# Generate the level from datas comming from map.xbm
func buildMap():
	
	# Mise en place bordures
	# max 
	#var actualViewSize = get_viewport().get_visible_rect().size
	var mapMinBorderSize = 40.0
	var mapMinGroundHeight = 130.0	
	
	var mapW = data.width*mapBlockSize
	var mapH = data.height*mapBlockSize
	get_node("Celling").position = Vector2(0, 0)
	get_node("Ground").position = Vector2(0, mapH)
	get_node("LeftBorder").position = Vector2(0, 0)
	get_node("RightBorder").position = Vector2(mapW, 0)
	
	var filet = get_node("Filet")
	var filetX = (mapW *data.filetPos)
	filet.position = Vector2(filetX, mapH)
	filet.scale = Vector2(1.0,data.filetSize)
	
	get_node("MainCam").offset = Vector2(mapW*0.5, (mapH + mapMinGroundHeight)*0.5)
	 
	var z = min( 1.0*screenWidth/(mapW+2*mapMinBorderSize), 1.0*screenHeight/(mapH+mapMinBorderSize+ mapMinGroundHeight) )
	get_node("MainCam").zoom = Vector2(z,z)*0.9
	
	get_node("Background/ColorRect").size = Vector2(mapW,mapH)
	get_node("Ground/ScoreDisplay").position = Vector2(mapW*0.5-140, mapH+40.0)
	
	
	Globals.ground = get_node("Ground/StaticBody2D")
