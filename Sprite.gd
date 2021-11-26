extends Sprite



func _ready():
	pass # Replace with function body.


func _input(event):
	print("event")
	if(event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT):
		print("click")
