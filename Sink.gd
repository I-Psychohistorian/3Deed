extends KinematicBody

var Name = "Turn Handle"
var pickup = "Faucet"
onready var radius = $Area
var active = true

var turned = false
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
			if turned == false:
				turned = true
				$Drip.play()
				$Timer.start()
				$Base.rotate_y(deg2rad(-90))
			elif turned == true:
				turned = false
				$Base.rotate_y(deg2rad(90))


func _on_Timer_timeout():
	$Particles.emitting = true
