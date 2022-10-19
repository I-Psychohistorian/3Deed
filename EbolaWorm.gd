extends KinematicBody


var health = 10
var Name = "EbolaWorm"
var damage = 4
var aggro = false
var dead = false

var move_speed = 2.2
var gravity = 2
var fall = Vector3()

onready var aggro_zone = $Sight
onready var damage_zone = $DamageArea
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement()
	if not is_on_floor():
		fall.y -= gravity * delta
		move_and_slide(fall, Vector3.UP)
	elif is_on_floor():
		fall.y = 0

func take_damage(damage):
	health -= damage
	$HeadSplatter2.emitting = true
	
	die()

func die():
	if dead == false:
		if health <= 0:
			dead = true
			$DeathTimer.start()

func movement():
	var bodies = aggro_zone.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
				var direction = body.global_transform.origin - self.global_transform.origin
				direction += Vector3(0, 1, 0)
				move_and_slide(direction * (move_speed), Vector3.UP)
				look_at(body.global_transform.origin, Vector3.UP)


func _on_DeathTimer_timeout():
	queue_free()

func _on_AttackTimer_timeout():
	var bodies = damage_zone.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			body.take_damage(damage)
			body.disease = true
