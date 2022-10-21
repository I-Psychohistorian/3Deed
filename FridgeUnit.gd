extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var radius = $Spatial/Door/Handle/Area
var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Handle_open_close():
	if open == true:
		open = false
		$Hinge.rotate_y(deg2rad(90))
		$DoorClose.play()
	elif open == false:
		open = true
		$Hinge.rotate_y(deg2rad(-90))
		$DoorOpen.play()
