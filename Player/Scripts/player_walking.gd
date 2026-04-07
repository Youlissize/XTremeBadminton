extends "res://Player/Scripts/player_base.gd"

var jumpForce := 850


func _ready() -> void:
	super._ready()
	$AnimatedSprite2D.animation_looped.connect(onAnimationFinished)	

func _process(delta: float) -> void:
	super._process(delta)
	

func jump():
	super.jump()
	if allowedToJump():
		Y_speed = -jumpForce
		inAir = true
		currentVehicule = null


func hit(ignoreTiming := false) ->bool:
	var res = super.hit(ignoreTiming)
	#anim.play("frapperHaut")
	$AnimatedSprite2D.play("shot")
	
	#$AnimatedSprite2D.animation_finished("IDLE")
	return res

func onAnimationFinished():
	$AnimatedSprite2D.play("IDLE")
