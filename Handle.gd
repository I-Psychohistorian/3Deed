extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Name = "Open"
signal open_close
onready var radius = $Area
var active = true
var closed = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func use():
	var bodies = radius.get_overlapping_bodies()
	for n in bodies:
		if n.is_in_group("Player"):
			emit_signal("open_close")
			if closed == true:
				closed = false
				Name == "Close"
			elif closed == false:
				closed = true
				Name == "Open"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
