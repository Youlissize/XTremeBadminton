extends "res://Player/Scripts/player_base.gd"

var jumpForce := 700
var fallingFactor := 2.0


func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	

func jump():
	super.jump()
	if (!inAir):
		Y_speed = -jumpForce
		inAir = true


func hit(ignoreTiming := false) ->bool:
	var res = super.hit(ignoreTiming)
	#anim.play("frapperHaut")
	return res
