extends "res://Player/Vehicules/vehicule.gd"

var currentTorque := 0.0
@export var monocycleSpeed := 10000.0


func _physics_process(delta: float) -> void:
	$Roue.apply_torque(currentTorque) #cos(Time.get_ticks_msec()*0.001) * 10000000 )
	#var vec :Vector2= $Fourche/CollisionShape2D.global_position - $Selle/CollisionShape2D.global_position

	#$Fourche/Sprite2D.rotation = vec.angle()+PI/2.0
	#$Selle/Sprite2D.rotation = vec.angle()+PI/2.0
	

func move(X_dir : float, speed : float):
	currentTorque = X_dir * speed * monocycleSpeed

#func body_touched_selle(body: Node) -> void:
#	if (body.has_method("setVehicule")) : 
#		body.setVehicule(self)
