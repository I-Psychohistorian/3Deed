extends Spatial

var current_level = "res://Levels/NonEuclid.tscn"
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Big_Teleport_body_entered(body):
	if body.is_in_group('Player'):
		body.global_transform.origin = Vector3(34.08, -3.54, 16.67)


func _on_Small_teleport_body_entered(body):
	if body.is_in_group('Player'):
		body.global_transform.origin = Vector3(4.74, -3.38, 9.36)
