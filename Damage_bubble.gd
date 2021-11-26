extends Node2D

func _ready():
	pass
	
func set_text(text):
	$HBoxContainer/Label.text = str(text)
