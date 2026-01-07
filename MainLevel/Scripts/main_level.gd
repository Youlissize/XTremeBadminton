extends Node2D
const Globals := preload("res://MainLevel/Scripts/globalStuff.gd")
var data := preload("res://MainLevel/Scripts/mapData.gd").new()
@export var player1: CharacterBody2D
@export var ground: StaticBody2D
@export var volant: PhysicsBody2D
#@export var map : mapData

func _ready() -> void:
	if(player1):
		player1.set("ground", ground)
		#player1.set("volant"[0],volant)
	
	data.mapName = "OHHHH"
	data.save_map()
	data.mapName = "incr"
	print(data.mapName)
	data.load_map("mapTest")
	print(data.mapName)
