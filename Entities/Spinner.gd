extends KinematicBody

# spinning enemy with effectively only one plane of attack
var health = 120
var damage = 10
var Name = 'Spinner'

var gravity = 8
var spin_factor = 9
var spin_speed = 15
var move_speed = 1
var hurt = false
var aggro = false
var chase = false
var dead = false

onready var sight_area = $sight_radius


var fall = Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if aggro == true:
		rotate_y(deg2rad(spin_speed * (spin_factor * delta)))
	elif aggro == false:
		pass
	if chase == true:
		for body in sight_area.get_overlapping_bodies():
			if body.is_in_group("Player"):
				var direction = body.global_transform.origin - self.global_transform.origin
				move_and_slide(direction * (move_speed), Vector3.UP)
	if not is_on_floor():
		fall.y -= gravity * delta
		move_and_slide(fall, Vector3.UP)
	elif is_on_floor():
		fall.y = 0
	die()
func take_damage(incoming_damage):
	health -= incoming_damage
	print('Ouch!')
	$Hurt.play()

func die():
	if dead == false:
		if health <= 0:
			dead = true
			$DeathTimer.start()
			$AuraExplosion.emitting = true
			$Death.play()
			
			

func _on_sight_radius_body_entered(body):
	if body.is_in_group('Player'):
		$AttackTimer.start()
		aggro = true
		$spike_barrier/Spikeflames.emitting = true
		$Fwoosh.play()



func _on_sight_radius_body_exited(body):
	if body.is_in_group('Player'):
		aggro = false
		$spike_barrier/Spikeflames.emitting = false
		chase = false
		spin_factor = 10
		# spin factor set one higher than starting for theorhetical infinite accelration for the luls
func _on_AttackTimer_timeout():
	chase = true
	spin_factor *= 3


func _on_hurt_zone_body_entered(body):
	$Hit.play()
	if body.is_in_group('Player'):
		body.take_damage(damage)
	if body.is_in_group('Blob'):
		body.take_damage(damage)
	if body.is_in_group('Destructible'):
		body.take_damage(damage)


func _on_DeathTimer_timeout():
	queue_free()
