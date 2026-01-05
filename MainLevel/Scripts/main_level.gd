extends Node2D

@export var player1: CharacterBody2D
@export var ground: StaticBody2D
@export var volant: PhysicsBody2D


func _ready() -> void:
	if(player1):
		player1.set("ground", ground)
		player1.set("volant",volant)
