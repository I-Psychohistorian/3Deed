extends KinematicBody


var Name = "BasicDoor"
var active = true
var health = 50
# Called when the node enters the scene tree for the first time.
var angle_coords_open = Vector3(0, 90, 0)
var angle_coords_closed = Vector3(0, 0, 0)
var open = false
var dead = false

signal open_space
signal hurt_space
signal die_space

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		if dead == false:
			dead = true
			die()


func use():
	emit_signal("open_space")

func take_damage(damage):
	health -= damage
	emit_signal("hurt_space")

func die():
	emit_signal("die_space")
