extends KinematicBody


var Name = "FleshFlu"
var health = 25
var damage = 2
var aggro = false
var dead = false
var anim_playing = false

var move_speed = 0.5
var gravity = 6
var fall = Vector3()

onready var aggro_zone = $Sight
onready var damage_zone = $damage_zone

var random = RandomNumberGenerator.new()
var x_spin = 0
var y_spin = 0
var z_spin = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if aggro == true:
		if anim_playing == false:
			$AnimationPlayer.play("Idle")
			anim_playing = true
		movement()
	elif aggro == false:
		if anim_playing == true:
			anim_playing = false
			$AnimationPlayer.play("Idle 2")
		rotate_y(deg2rad(y_spin))
		rotate_x(deg2rad(x_spin))
		rotate_z(deg2rad(z_spin))
	if not is_on_floor():
		fall.y -= gravity * delta
		move_and_slide(fall, Vector3.UP)
	elif is_on_floor():
		fall.y = 0

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
	#hurt sound
	$HeadSplatter2.emitting = true
	die()
	
func die():
	if health <= 0:
		if dead == false:
			dead = true
			$DeathTimer.start()
			$HeadSplatter2.emitting = true

func _on_DeathTimer_timeout():
	queue_free()

func _on_Sight_body_entered(body):
	if body.is_in_group('Player'):
		aggro = true


func _on_Sight_body_exited(body):
	if body.is_in_group('Player'):
		aggro = false


func _on_DamageTimer_timeout():
	var bodies = damage_zone.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			body.take_damage(damage)
			body.disease = true


func _on_RandomTimer_timeout():
	random.randomize()
	x_spin = random.randf_range(-0.2,0.2)
	y_spin = random.randf_range(-0.2,0.2)
	z_spin = random.randf_range(-0.2,0.2)
	#print(x_spin)
	#print(y_spin)
	#print(z_spin)
	
