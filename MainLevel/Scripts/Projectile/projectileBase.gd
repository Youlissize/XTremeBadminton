@tool # makes function _process called in the editor
extends PhysicsBody2D

const Globals := preload("res://MainLevel/Scripts/globalStuff.gd")

@export var size := 1.0
#var customGravity := 1.0

func getRealSize():
	return size * 20

func _ready() -> void:
	Globals.projectiles.append(self)

#function called every frame
func _process(delta : float) -> void:
	scale = Vector2(size,size)
	get_node("CollisionShape2D").scale = 2*Vector2(size,size)
	pass 
