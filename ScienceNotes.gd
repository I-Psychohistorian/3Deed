extends KinematicBody



var Name = "Read Messy Science Notes"
var pickup = "Notes"
onready var radius = $Area
var active = true
var n1 = "...flesh phage highly adaptable, but high load of fluid contact required for infection"
var n2 = "of three potential modes of cellular action at least two have been observed...avoid touching them at all costs.."
var n3 = "Subversion of IFN pathway leads to chills but no fever. Still working on potential treatments..."

var current = 1
onready var note1 = $Notes1
onready var note2 = $Notes2
onready var note3 = $Notes3

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
			if current == 1:
				n.dialogue_text = n1
				n.tick_dialogue()
				current = 2
				Name = "Read Messy Science Notes 2/3"
			elif current == 2:
				n.dialogue_text = n2
				n.tick_dialogue()
				current = 3
				Name = "Read Messy Science Notes 3/3"
			elif current == 3:
				Name = "Read Messy Science Notes 1/3"
				n.dialogue_text = n3
				n.tick_dialogue()
				current = 1
