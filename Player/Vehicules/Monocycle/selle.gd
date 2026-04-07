extends RigidBody2D

func getVehicule() -> Node2D:
	return get_parent()
	

func _on_body_entered(body: Node) -> void:
	pass
	#if (body.has_method("setVehicule")) : 
	#	body.setVehicule(get_parent())
