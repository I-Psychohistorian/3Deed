extends KinematicBody

var health = 300
var damage = 20
var Name = "Flesh Bull Body"

var walkspeed = 0.4
var runspeed = 4
var gravity = 10
var run_grav = 5

var aggro = false
var backing_up = false
var angry = false
var player_near_body = false
var pursuing = false
var running = false
var turning = true

var charge_time_start = false

var rng = RandomNumberGenerator.new()
var turn_co = 1
var initial_rotate = 1
var rotate_degree = 2

var set_anim = true

var walk_anim = false
var run_anim = false
var idle_anim = false
var wake_anim = false
var die_anim = false
var walk_check = false
var idle = true

onready var bodyanim = $BodyAnimation

signal spawn_ebola
var spitting = true
var spawn_coords = Vector3()

var fall = Vector3()
#last position seen by body radius
var player_last_position = Vector3()
#last position seen in front of bull
var player_last_position_front = Vector3()
var charge_point = Vector3()
var reverse = Vector3()

onready var body_sight = $BodySight

onready var sightline = $SightLine
onready var gravline = $GravCast
onready var groundcast = $GroundCast
onready var carrot = $InFront
onready var behind = $InBack


onready var gallop = $Run
onready var trot = $Walk
onready var head = $FleshHead
# Called when the node enters the scene tree for the first time.
func _ready():
	connect_to_parent()
	gallop.stream_paused = true
	trot.stream_paused = true
	#print(carrot.global_transform.origin)
	#print(self.global_transform.origin)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if groundcast.is_colliding():
		if gravline.is_colliding():
			#print('yes')
			fall.y = 0
			gravity = -2
		elif not gravline.is_colliding():
			#print('almost yes')
			if running == false:
				gravity = 15
			elif running == true: gravity = 1
	elif not groundcast.is_colliding():
		#print('no')
		gravity = 10
	fall.y -= gravity * delta
	move_and_slide(fall, Vector3.UP)
	if turning == false and player_near_body == true:
		if pursuing == false:
			pursuing = true
			#print('pursuing')
	elif turning == true:
		if pursuing == true:
			pursuing = false
			#print('stopped pursuit')
	if pursuing == true:
		if running == false:
			walk_anim = true
			trot.stream_paused = false
			pursue()
	if running == true:
		if sightline.is_colliding():
			#print('stopped running')
			gallop.stream_paused = true
			running = false
			run_anim = false
			set_anim = true
		charge()
	handle_anim()
	#is it possible to have this running with nothing happening
	if turning == true:
		if running == false:
			walk_anim = true
			trot.stream_paused = false
			rotate_to_player()
	if turning == true and player_near_body == false:
		if backing_up == false:
			walk_anim = false
			trot.stream_paused = true
		if backing_up == true:
			if running == false:
				backup()


func spawn():
	if $Tumor.popped == false:
		spawn_coords = $Tumor.spawn_point
		$Tumor.pop()
		$Splorch2.play()
		emit_signal("spawn_ebola")
	elif $Tumor.popped == true:
		if $Tumor2.popped == false:
			spawn_coords = $Tumor2.spawn_point
			emit_signal("spawn_ebola")
			$Tumor2.pop()
			$Splorch2.play()
			#other sounds?
		elif $Tumor2.popped == true:
			print('No tumors left!')
func handle_anim():
	if set_anim == true:
		set_anim = false
		if run_anim == true:
			bodyanim.play("Run")
		elif walk_anim == true:
			bodyanim.play("Walk")
		elif die_anim == true:
			pass
		elif idle_anim == true:
			bodyanim.play("RESET")
		else:
			bodyanim.play("RESET")

func pursue():
	var target = body_sight.get_overlapping_bodies()
	for body in target:
		if body.is_in_group('Player'):
			var direction = body.global_transform.origin - self.global_transform.origin
			move_and_slide(direction * walkspeed, Vector3.UP)

func charge():
	var target = body_sight.get_overlapping_bodies()
	move_and_slide(charge_point * runspeed, Vector3.UP)

func backup():
	reverse = behind.global_transform.origin - self.global_transform.origin
	move_and_slide(reverse * 1, Vector3.UP)

func rotate_to_player():
	if aggro == true:
		if angry == false:
			rotate_y(deg2rad(initial_rotate * turn_co))
		elif angry == true:
			rotate_y(deg2rad(rotate_degree * turn_co))

func connect_to_parent():
	var FleshManager = get_parent()
	connect('spawn_ebola', FleshManager, "spawn_seeker")

func take_damage(damage):
	print('body damage')
	health -= damage
	$Splorch2.play()
	$Body/HeadSplatter2.emitting = true
	if health <= 0:
		queue_free()

func _on_BodySight_body_entered(body):
	if body.is_in_group("Player"):
		player_near_body = true
		set_anim = true



func _on_BodySight_body_exited(body):
	if body.is_in_group("Player"):
		set_anim = true
		player_near_body = false
		angry = true
		player_last_position = body.global_transform.origin





func _on_SightLineArea_body_entered(body):
	if body.is_in_group("Player"):
		turning = false
		turn_co = -1
		player_last_position_front = body.global_transform.origin


func _on_SightLineArea_body_exited(body):
	if body.is_in_group("Player"):
		turning = true
		turn_co = -1
		player_last_position_front = body.global_transform.origin



func _on_FleshHead_player_seen():
	aggro = true
	set_anim = true



func _on_FleshHead_player_unseen():
	aggro = false
	set_anim = true
	$BackupTimer.start()
	backing_up = true




func _on_Debugtimer_timeout():
	#gposition = self.global_transform.origin
	#print(fall)
	#print(gposition)
	#move_and_slide(Vector3(-50, 20,-50), Vector3.UP)
	#print('turning is ', turning)
	#print('running is ', running)
	#print(running)
	pass

#negative is just left side of bull and will make it turn towards where it last saw player
func _on_SightLineAreaneg_body_entered(body):
	if body.is_in_group("Player"):
		
		turning = false
		turn_co = 1
		player_last_position_front = body.global_transform.origin



func _on_SightLineAreaneg_body_exited(body):
	if body.is_in_group("Player"):
		turning = true
		turn_co = 1
		player_last_position_front = body.global_transform.origin



func _on_ChargeTimer_timeout():
	gallop.stream_paused = false
	print('running')
	run_anim = true
	set_anim = true
	var carrot_on_stick = carrot.global_transform.origin - self.global_transform.origin
	charge_point = carrot_on_stick
	#charge_point = player_last_position_front
	print('chasing last seen')
	running = true
	charge_time_start = false


func _on_ChargeTick_timeout():
	set_anim = true
	print('anim set')


func _on_FleshHead_transfer_damage():
	take_damage(head.transfered_damage)




func _on_ChargeAggro_body_exited(body):
	if body.is_in_group("Player"):
		if charge_time_start == false:
			if running == false:
				$ChargePrelude.play()
				$ChargeTimer.start()
				charge_time_start = true


func _on_BackupTimer_timeout():
	backing_up = false
	print('stopped backing up')
	set_anim = true
