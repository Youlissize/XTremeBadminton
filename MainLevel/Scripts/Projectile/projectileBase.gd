#@tool # makes function _process called in the editor
extends RigidBody2D

const Globals := preload("res://MainLevel/Scripts/Main/globalStuff.gd")

@export var size := 1.0
#var customGravity := 1.0
#var motion := Vector2(0,0)
#var currentGravity := 10.0
#var damping := 10

var currentPowerUps := Array()

var isActive := true # marque un point si touche sol
var waitingForService := true #not yet hit by anything

func getRealSize():
	return size * 20

func _ready() -> void:
	Globals.projectiles.append(self)

#function called every frame
func _process(delta : float) -> void:
	#scale = Vector2(size,size) #Degeulasse!
	#get_node("CollisionShape2D").scale = 2*Vector2(size,size) #sale!
	pass

func _physics_process(delta: float) -> void:
	
	var additionalForces := Vector2(0,0)
	for pu in currentPowerUps:
		if (pu.addForce):
			#additionalForces += 
			var f = pu.getPowerUpForce(self)
			self.apply_central_force(f)
	#if (currentPowerUps.size()):
	#	self.apply_impulse(additionalForces, self.global_position)
	#test
	#
	#	currentPowerUps[0].exit(self)
		#currentPowerUps.remove_at(0)

func _on_body_entered(body: Node) -> void:
	if body.has_method("hit") && isActive:
			body.hit(self)
	print ("Collision with : ",body.name)

func body_exited(body:Node)->void:
	print ("Exited collision with : ",body.name)
	
func hitted(newVelocity : Vector2) -> void:
	set("linear_velocity", newVelocity)
	waitingForService = false
	set("gravity_scale", 1) # TODO : remove this

func teleportForService(targetLocation : Vector2) ->void:
		var temp = collision_mask
		collision_mask = 0
		move_and_collide(targetLocation-position)
		collision_mask = temp
		set("linear_velocity",Vector2(0,0))
		set("gravity_scale", 0.08)
		isActive = true
		waitingForService = true
		
