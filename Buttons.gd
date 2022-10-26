extends KinematicBody


var Name = "Use door controls"
onready var radius = $Area
var on = false
var broke = false
var active = true

var text = "The cargo door controls are completely unresponsive."


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func use():
	var bodies = radius.get_overlapping_bodies()
	for n in bodies:
		if n.is_in_group("Player"):
			n.dialogue_text = text
			n.tick_dialogue()
