extends KinematicBody

var Name = "Door"
var active = true
var health = 400
# Called when the node enters the scene tree for the first time.

var closed = true
var locked = true

signal open
signal close
signal die

onready var radius = $Area

var dead = false

var denied = "The door is sealed shut. It appears you need a keycard to unlock it."
var granted = "You unlock the door with your keycard."


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damage):
	print('the reinforced door laughs at your so called damage')

func use():
	var bodies = radius.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			if locked == true:
				if body.keycard == false:
					body.dialogue_text = denied
					body.tick_dialogue()
					$Red.play()
				elif body.keycard == true:
					body.dialogue_text = granted
					body.tick_dialogue()
					locked = false
					$Green.play()
					$MeshInstance/MeshInstance/RedLight.visible = false
					$MeshInstance/MeshInstance/GreenLight.visible = true
					$MeshInstance/MeshInstance2/RedLight.visible = false
					$MeshInstance/MeshInstance2/GreenLight.visible = false
			elif locked == false:
				if closed == true:
					emit_signal("open")
				elif closed == false:
					emit_signal("close")
