extends KinematicBody


var Name = "Open Reinforced Tank"
var pickup = "Glass Case"
onready var radius = $Area
var active = true
var health = 20

var closed = true

signal open_case
signal close_case
signal break_lid
signal break_glass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damage):
	health -= damage
	emit_signal("break_lid")
	if health <= 0:
		queue_free()

func use():
	var bodies = radius.get_overlapping_bodies()
	for n in bodies:
		if n.is_in_group("Player"):
			if closed == true:
				emit_signal("open_case")
				closed = false
				Name = "Close Reinforced Tank"
			elif closed == false:
				emit_signal("close_case")
				closed = true
				Name = "Open Reinforced Tank"
				
