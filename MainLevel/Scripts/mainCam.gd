extends Camera2D

var timer := 0.0
var currentIntensity := 0
var currentRot := 0

func _process(delta: float) -> void:
	#rotate(delta*10)
	if (true): #small permanent rotation
		currentRot = sin(Time.get_ticks_msec()*0.001)*0.02
		rotation = currentRot
	
	

func shake(duration :float, intensity :float, fadeIn := 0.1, fadeOut := 0.6) -> void:
	timer = duration
	currentIntensity = intensity
	# TODO
	return
