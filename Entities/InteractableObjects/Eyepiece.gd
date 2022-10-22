extends KinematicBody

var Name = "Use eyepiece (get close)"
var active = true
var usable = false
var light_on = false
# Called when the node enters the scene tree for the first time.
var off_text = "The microscope is off."
var slide_text = "You see a lot of light. You probably need to place a slide down first."
var observe = "The previously flash frozen cells should be dead but appear to be moving again."

signal microscope_viewing

onready var radius = $ViewingArea
onready var out_radius = $Eyepiece_interact

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	var bodies = radius.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			if light_on == false:
				body.dialogue_text = off_text
				body.tick_dialogue()
			elif usable == false:
				body.dialogue_text = slide_text
				body.tick_dialogue()
			elif light_on == true and usable == true:
				body.dialogue_text = observe
				body.tick_dialogue()
				body.micro_image.visible = true
				emit_signal("microscope_viewing")
		
func _on_Microscope_off():
	light_on = false


func _on_Microscope_on():
	light_on = true


func _on_Slideboxandslides_placed():
	usable = true


func _on_Slideboxandslides_removed():
	usable = false


func _on_ViewingArea_body_exited(body):
	if body.is_in_group('Player'):
		body.micro_image.visible = false
		print('microscope no longer in use')
