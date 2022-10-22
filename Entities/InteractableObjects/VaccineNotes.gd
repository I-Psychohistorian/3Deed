extends KinematicBody



var Name = "Read Messier Science Notes 1/9"
var pickup = "Notes"
onready var radius = $Area
var active = true
var n1 = "...infection with fleshphage seemingly inevitible, but slow buildup may have exploit"
var n2 = "since low on media, started using personel samples"
var n3 = "human toe with plantar warts lastsed longer than all samples"
var n4 = "...survivable, temporary physiological changes maladapt fleshphage, slowing infection"
var n5 = "bizzare viral-viral inhibition occurance, combined .... homeostasis affecting compounds..."
var n6 = "...slow acting metabolism modifiers and late pathway inflammosome stimulators"
var n7 = "...serum can slow symptoms immensely but is hard on the body."
var n8 = "The serum is not a cure, but preventative and ameliorating. I'm still infected."
var n9 = "I'm going to the armory to end myself before I turn. Maybe someone can survive this if not us."

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
				Name = "Messier Science Notes 2/9"
				n.dialogue_text = n1
				n.tick_dialogue()
				current = 2
			elif current == 2:
				Name = "Messier Science Notes 3/9"
				n.dialogue_text = n2
				n.tick_dialogue()
				current = 3
			elif current == 3:
				Name = "Messier Science Notes 4/9"
				n.dialogue_text = n3
				n.tick_dialogue()
				current = 4
			elif current == 4:
				Name = "Messier Science Notes 5/9"
				n.dialogue_text = n4
				n.tick_dialogue()
				current = 5
			elif current == 5:
				Name = "Messier Science Notes 6/9"
				n.dialogue_text = n5
				n.tick_dialogue()
				current = 6
			elif current == 6:
				Name = "Messier Science Notes 7/9"
				n.dialogue_text = n6
				n.tick_dialogue()
				current = 7
			elif current == 7:
				Name = "Messier Science Notes 8/9"
				n.dialogue_text = n7
				n.tick_dialogue()
				current = 8
			elif current == 8:
				Name = "Messier Science Notes 9/9"
				n.dialogue_text = n8
				n.tick_dialogue()
				current = 9
			elif current == 9:
				Name = "Messier Science Notes 1/9"
				n.dialogue_text = n9
				n.tick_dialogue()
				current = 1
