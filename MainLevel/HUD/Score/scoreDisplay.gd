extends Node2D
const Globals := preload("res://MainLevel/Scripts/globalStuff.gd")

var left := 0
var right := 0

func _ready() -> void:
	Globals.scoreDisplay = self
	
func display() -> void:
	get_node("MarginContainer/HBoxContainer/LeftScore/LeftDisplay").text = String.num_int64(left)
	get_node("MarginContainer/HBoxContainer/RightScore/RightDisplay").text = String.num_int64(right)
	
