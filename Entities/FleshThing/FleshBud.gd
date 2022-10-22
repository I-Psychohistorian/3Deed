extends KinematicBody


var Name = "FleshFlu"
var health = 25
var damage = 2
var awake = true
var aggro = false
var dead = false
var anim_playing = false

var move_speed = 0.6
var gravity = 5
var fall = Vector3()
var falling = true

signal bud_died

onready var aggro_zone = $Sight
onready var damage_zone = $damage_zone
onready var collisions = $CollisionShape

var random = RandomNumberGenerator.new()
var x_spin = 0
var y_spin = 0
var z_spin = 0

var sound_check = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Ambient1.stream_paused = false
	$AmbientAggro.stream_paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if aggro == true:
		if sound_check == false:
			sound_check == true
			$AmbientAggro.stream_paused = false
			$Ambient1.stream_paused = true
		if anim_playing == false:
			$AnimationPlayer.play("Idle")
			anim_playing = true
		if dead == false:
			movement()
	elif aggro == false:
		if sound_check == false:
			sound_check = true
			$Ambient1.stream_paused = false
			$AmbientAggro.stream_paused = true
		if anim_playing == true:
			anim_playing = false
			$AnimationPlayer.play("Idle 2")
		rotate_y(deg2rad(y_spin))
		rotate_x(deg2rad(x_spin))
		rotate_z(deg2rad(z_spin))
	if is_on_wall():
		fall.y += 0.4
	elif is_on_ceiling():
		fall.y = 0
	elif not is_on_floor():
		if awake == true:
			fall.y -= gravity * delta
	elif is_on_floor():
		fall.y = 0
	
	
	move_and_slide(fall, Vector3.UP)

func movement():
	var bodies = aggro_zone.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
				var direction = body.global_transform.origin - self.global_transform.origin
				move_and_slide(direction * (move_speed), Vector3.UP)
				look_at(body.global_transform.origin, Vector3.UP)


func take_damage(damage):
	health -= damage
	#hurt timer
	$HurtSound.play()
	$HeadSplatter2.emitting = true
	die()
	
func die():
	if health <= 0:
		if dead == false:
			dead = true
			emit_signal("bud_died")
			$DeathTimer.start()
			$HurtSound.play()
			$HeadSplatter2.emitting = true

func _on_DeathTimer_timeout():
	queue_free()

func _on_Sight_body_entered(body):
	if body.is_in_group('Player'):
		if awake == true:
			aggro = true
			sound_check = false

func collide():
	collisions.disabled = false

func _on_Sight_body_exited(body):
	if body.is_in_group('Player'):
		aggro = false
		sound_check = false


func _on_DamageTimer_timeout():
	var bodies = damage_zone.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			if dead == false:
				$AttackSound.play()
				body.take_damage(damage)
				body.infection_check()


func _on_RandomTimer_timeout():
	random.randomize()
	x_spin = random.randf_range(-0.2,0.2)
	y_spin = random.randf_range(-0.2,0.2)
	z_spin = random.randf_range(-0.2,0.2)
	#print(x_spin)
	#print(y_spin)
	#print(z_spin)
	
