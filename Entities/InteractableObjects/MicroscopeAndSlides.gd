extends KinematicBody


var Name = "Turn On Microscope"
var active = true

var slide_placed = false
var on = false
onready var radius = $Main_Interact
onready var eyelight1 = $CSGCombiner/Eyepiece/EyeLight
onready var eyelight2 = $CSGCombiner/Eyepiece2/EyeLight
onready var stagelight = $CSGCombiner/Diaphragm/DiaphragmLight

onready var ready_slide = $Slide
onready var unready_slide = $Slideboxandslides/SlideBox/Slide

signal on
signal off

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
			if on == false:
				on = true
				$onoff.play()
				emit_signal('on')
				eyelight1.visible = true
				eyelight2.visible = true
				stagelight.visible = true
				Name = "Turn Off Microscope"
			elif on == true:
				on = false
				$onoff.play()
				emit_signal('off')
				eyelight1.visible = false
				eyelight2.visible = false
				stagelight.visible = false
				Name = "Turn On Microscope"

func _on_Slideboxandslides_placed():
	ready_slide.visible = true
	unready_slide.visible = false


func _on_Slideboxandslides_removed():
	ready_slide.visible = false
	unready_slide.visible = true
