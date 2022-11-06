extends KinematicBody


var health = 60
var dead = false
var Name = "Wooden Apparatus"
var active = true


var aggro = false

var rotation_cooldown = false
var rotating = true

var speed = 0.5
var gravity = 5
var up_thrust = 0.1

signal enemy_spotted
signal enemy_lost

onready var core = $Crystal
onready var core_fire = $Crystal/Fire
onready var down = $GravRaycast
var rng = RandomNumberGenerator.new()

onready var sight_radius = $Chase_radius
onready var sightline = $SightLine
onready var target_ball = $Target
var fall = Vector3()
var last_seen = Vector3()

var down_collide = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$IdleAggro.stream_paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	down.global_rotation = Vector3(0, 0, 0)
	check_down()
	if dead == false:
		if down_collide == false:
			if aggro == false:
				fall.y -= gravity
				move_and_slide(fall, Vector3.UP)
			elif aggro == true:
				fall.y = -up_thrust
				move_and_slide(fall, Vector3.UP)
		elif down_collide == true:
			if aggro == false:
				fall.y = 0
				move_and_slide(fall, Vector3.UP)
			elif aggro == true:
				fall.y = (up_thrust/2)
				move_and_slide(fall, Vector3.UP)
		if aggro == true:
			if rotating == true:
				face_target()
			elif rotating == false:
				if rotation_cooldown == false:
					move()
					pass #attacks commence and movement
	if dead == true:
		fall.y -= gravity
		move_and_slide(fall, Vector3.UP)
		

func use():
	pass

func check_down():
	if down.is_colliding() == true:
		if down_collide == false:
			fall.y = 0
		down_collide = true
	else:
		down_collide = false
		if down_collide == true:
			fall.y = 0

func face_target():
	var bodies = sight_radius.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			look_at(body.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(90))
			self.rotation.x = clamp(self.rotation.x, deg2rad(0), deg2rad(-0))
			#rotate_x(deg2rad(5))

func move():
	var bodies = sight_radius.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			var direction = body.global_transform.origin - target_ball.global_transform.origin
			move_and_slide(direction * (speed), Vector3.UP)

func take_damage(damage):
	health -= damage
	if health <= 0:
		die()

func die():
	#crystal break sound
	$AnimationPlayer.play("RESET")
	core.visible = false
	$IdleAggro.stream_paused = true
	$Death.start()
	aggro = false

func _on_Chase_radius_body_entered(body):
	print('Golem radius entered')
	#pass


func _on_Chase_radius_body_exited(body):
	if body.is_in_group('Player'):
		aggro = false
		core.spinning = false
		core_fire.visible = false
		$IdleAggro.stream_paused = true
		emit_signal("enemy_lost")
		$AnimationPlayer.play("DeAggro")
		up_thrust = 3


func _on_Chase_trigger_body_entered(body):
	if aggro == false:
		if body.is_in_group('Player'):
			$BeginChase.start()
			core.spinning = true
			core_fire.visible = true
			$IdleAggro.stream_paused = false
			emit_signal("enemy_spotted")
			$AnimationPlayer.play("Awaken")


func _on_BeginChase_timeout():
	aggro = true
	up_thrust = 3
	$AnimationPlayer.play("Aggro")


func _on_AttackTimer_timeout():
	if aggro == true:
		if rotating == false:
			rng.randomize()
			var choice = rng.randi_range(0, 1)
			print(choice)
			if choice == 0:
				$AnimationPlayer.play("LeftSwing")
			elif choice == 1:
				$AnimationPlayer.play("RightSwing")


func _on_SightLine_body_entered(body):
	if body.is_in_group('Player'):
		rotating = false
		rotation_cooldown = true
		$RotationTimer.start()


func _on_SightLine_body_exited(body):
	if body.is_in_group('Player'):
		rotating = true


func _on_RotationTimer_timeout():
	rotation_cooldown = false


func _on_Death_timeout():
	dead = true 
