extends Node2D
const Globals := preload("res://MainLevel/Scripts/globalStuff.gd")

@export var player1: CharacterBody2D
@export var ground: StaticBody2D
@export var volant: PhysicsBody2D


func _ready() -> void:
	if(player1):
		player1.set("ground", ground)
		#player1.set("volant"[0],volant)
	if (volant):
		Globals.volants.append(volant)
