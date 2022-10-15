extends KinematicBody


var health = 80
var damage = 5
var Name = 'Glorper'

var hurt = false
var aggro = true

onready var Blorp_Area = $BlorpArea
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	death()

func take_damage(incoming_damage):
	health -= incoming_damage
	print('Ouch!')
	$Blouch.play()

func death():
	if health < -20:
		queue_free()

func acid_hazard():
	for body in Blorp_Area.get_overlapping_bodies():
		if body.is_in_group("Destructible"):
			body.take_damage(damage)
			print("Blorp!")
			$Blorp.play()
	

func _on_BlorpArea_body_entered(body):
	pass # Replace with function body.


func _on_BlorpTimer_timeout():
	acid_hazard()


func _on_VisionBox_body_entered(body):
	if body.is_in_group('Player'):
		var coords = body.get_global_transform()
		print(coords)
		aggro = true

func _on_VisionBox_body_exited(body):
	aggro = false
