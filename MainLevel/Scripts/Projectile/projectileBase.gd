@tool # makes function _process called in the editor
extends PhysicsBody2D

const Globals := preload("res://MainLevel/Scripts/globalStuff.gd")

@export var size := 1.0
#var customGravity := 1.0
var motion := Vector2(0,0)
var currentGravity := 10.0
var damping := 10

var isActive := true # marque un point si touche sol

func getRealSize():
	return size * 20

func _ready() -> void:
	Globals.projectiles.append(self)

#function called every frame
func _process(delta : float) -> void:
	scale = Vector2(size,size)
	get_node("CollisionShape2D").scale = 2*Vector2(size,size)
	pass 
	
func _physics_process(delta: float) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	if body.has_method("hit") && isActive:
			body.hit(self)
	print ("Collision with : ",body.name)
