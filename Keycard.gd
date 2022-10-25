extends KinematicBody


var Name = "Keycard"
var active = true
var text = "You take the keycard."
onready var radius = $Area

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	var bodies = radius.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			body.dialogue_text = text
			body.tick_dialogue()
			body.keycard = true
			queue_free()
