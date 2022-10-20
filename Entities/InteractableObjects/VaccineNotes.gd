extends KinematicBody



var Name = "Read Messier Science Notes"
var pickup = "Notes"
onready var radius = $Area
var active = true
var n1 = "...the flesh phage is resillient and adaptive but slow and requires high exposure to infect.."
var n2 = "...seemingly inevitible yet survivable physiological changes could maladapt fleshphage buying time"
var n3 = "attempt 1: typical IFN inducers failed to slow metamorphosis of sample"
var n4 = "attempt 2: culture media mostly contaminated.. but inflammosome bypass slowed proccess. We are low on media."
var n5 = "attempt 6: flesh phage changes too wildly, started using personel blood samples"
var n6 = "attempt ?: My own severed warted toe lasted 5 hours longer. Viral competitive inhibition??"
var n7 = "finish later"

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
				Name = "Messy Science Notes 2/7"
			elif current == 2:
				n.dialogue_text = n2
				n.tick_dialogue()
				current = 3
			elif current == 3:
				Name = "Messy Science Notes 3/7"
				n.dialogue_text = n3
				n.tick_dialogue()
				current = 4
			elif current == 4:
				Name = "Messier Science Notes 4/7"
				n.dialogue_text = n4
				n.tick_dialogue()
				current = 5
			elif current == 5:
				Name = "Messier Science Notes 5/7"
				n.dialogue_text = n5
				n.tick_dialogue()
				current = 6
			elif current == 6:
				Name = "Read Messier Science Notes 6/7"
				n.dialogue_text = n6
				n.tick_dialogue()
				current = 7
			elif current == 7:
				Name = "Read Messier Science Notes Again"
				n.dialogue_text = n6
				n.tick_dialogue()
				current = 1
