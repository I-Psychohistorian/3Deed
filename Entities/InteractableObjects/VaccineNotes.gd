extends KinematicBody



var Name = "Read Messier Science Notes"
var pickup = "Notes"
onready var radius = $Area
var active = true
var n1 = "...infection with fleshphage seemingly inevitible, but slow buildup may have exploit"
var n2 = "...survivable, temporary physiological changes could maladapt fleshphage buying us time"
var n3 = "attempt 1: typical IFN inducers failed to slow metamorphosis of sample"
var n4 = "attempt 6: culture media mostly contaminated.. but inflammosome bypass slowed proccess marginally."
var n5 = "attempt 11: ..treatments show diminishing rewards, started using personel samples"
var n6 = "attempt 38: ...human toe with plantar warts lasted hours longer all samples. Viral competitive inhibition??"
var n7 = "...enough for a few doses of counter viral-drug cocktail. Not a cure, but it will slow infection dramatically"
var n8 = "There are only two of us left, but my work wasn't for nothing. Maybe someone can survive this."

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
				Name = "Messier Science Notes 2/8"
				n.dialogue_text = n1
				n.tick_dialogue()
				current = 2
			elif current == 2:
				n.dialogue_text = n2
				n.tick_dialogue()
				current = 3
			elif current == 3:
				Name = "Messier Science Notes 3/8"
				n.dialogue_text = n3
				n.tick_dialogue()
				current = 4
			elif current == 4:
				Name = "Messier Science Notes 4/8"
				n.dialogue_text = n4
				n.tick_dialogue()
				current = 5
			elif current == 5:
				Name = "Messier Science Notes 5/8"
				n.dialogue_text = n5
				n.tick_dialogue()
				current = 6
			elif current == 6:
				Name = "Read Messier Science Notes 6/8"
				n.dialogue_text = n6
				n.tick_dialogue()
				current = 7
			elif current == 7:
				Name = "Read Messier Science Notes 7/8"
				n.dialogue_text = n7
				n.tick_dialogue()
				current = 8
			elif current == 8:
				Name = "Read Messier Science Notes Again"
				n.dialogue_text = n8
				n.tick_dialogue()
				current = 1
