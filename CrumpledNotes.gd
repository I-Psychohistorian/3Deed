extends KinematicBody



var Name = "Read crumpled notes"
var pickup = "Bad Poetry"
onready var radius = $Area
var active = true
var note1 = "Her nose is like a rose"
var note2 = "...beautiful like her toes..."
var note3 = "The rest of this note is scribbled out, although you can make out many failed attempts to rhyme."

var current_note = 1
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
			if current_note == 1:
				n.dialogue_text = note1
				n.tick_dialogue()
				current_note = 2
			elif current_note == 2:
				n.dialogue_text = note2
				n.tick_dialogue()
				current_note = 3
			elif current_note == 3:
				n.dialogue_text = note3
				n.tick_dialogue()
				current_note = 1
