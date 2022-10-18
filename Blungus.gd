extends KinematicBody


var Name = "Blungus"
var health = 40

onready var radius = $PlayerInteractor

var active = true
var dialogue1 = "Hello! I hope you're having a good time."
var dialogue2 = "I wasn't always a stock image of a horse you know."
var current_dialogue = 'x'


var dialogue_change = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	if dialogue_change == false:
		dialogue_change = true
		current_dialogue = dialogue1
	elif dialogue_change == true:
		dialogue_change = false
		current_dialogue = dialogue2
	var bodies = radius.get_overlapping_bodies()
	for n in bodies:
		if n.is_in_group("Player"):
			n.dialogue_text = current_dialogue
			n.tick_dialogue()
