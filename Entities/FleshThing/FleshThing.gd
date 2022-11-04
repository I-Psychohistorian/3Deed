extends KinematicBody


var health = 100
var damage = 15
var Name = "FleshPhage"

var gravity = 8
var spin_factor = 9
var spin_speed = 15
var move_speed = 0.9
var hurt = false

onready var NotWall = $NotWall #must not intersect wall to allow climbing
onready var IsWall = $IsWall #must intersect wall to allow climbing
onready var HeightMax = $StepHeightRay #max climb height

var aggro = false
var chase = false

var decide_chase = false
var walking = false

var slime_aggro = false
var spitting = false
var spit_cooldown = false

#reorient ai behavior

var reorient_behavior = false
var reorienting = false
onready var RightRay = $RightObstacleRay
onready var MidRay = $MidObstacleRay
onready var LeftRay = $LeftObstacleRay
onready var SightLine = $LineOfSight
var move_modify_x = 0
var move_modify_z = 0
var unseen_attacker = false
#chase behavior circling

var dead = false

var can_attack = true

signal spawn_ebola

var rng = RandomNumberGenerator.new()

onready var headblood = $MainBody/Head/HeadSplatter
onready var blood = $Splatter
onready var barf = $MainBody/Head/BarfAttack

onready var sight_area = $Sight_radius

var fall = Vector3()
var spawn_coords = Vector3()
var player_last_seen = Vector3()
#planned behaviors
#dormant, until aggroed will give chase
#if players run and exit range it will make a ranged attack
#head rotates to follow player direction
#ranged attack will spawn ebola looking seeker enemy that will chase the player, try to latch on and deal damage
#when players exit aggro range, fleshphage will do a random walk in a direction and go dormant, unless agrroed during
#this action or after
#spooky sound design
var walksound_on = false


# Called when the node enters the scene tree for the first time.
func _ready():
	player_last_seen = self.global_transform.origin
	connect_to_parent()
	$Walk.stream_paused = true




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement()
	if not HeightMax.is_colliding():
		gravity = 8
	elif IsWall.is_colliding():
		if not NotWall.is_colliding():
			gravity = -1
	fall.y -= gravity
	move_and_slide(fall, Vector3.UP)
	fall.y = 0
func connect_to_parent():
	var FleshManager = get_parent()
	connect('spawn_ebola', FleshManager, "spawn_seeker")

func movement():
	if slime_aggro == true:
		if chase == false:
			for body in sight_area.get_overlapping_bodies():
				if body.is_in_group("Blob"):
					look_at(body.global_transform.origin, Vector3.UP)
					self.rotation.x = clamp(self.rotation.x, deg2rad(0), deg2rad(-0))
					self.rotation.z = clamp(self.rotation.z, deg2rad(0), deg2rad(-0))
	if spitting == true:
		if not MidRay.is_colliding():
			spit_cooldown = true
			$BarfCooldown.start()
			barf.emitting = true
			rng.randomize()
			var choice = rng.randi_range(1,2)
			if choice == 1:
				$Spit.play()
			elif choice == 2:
				$Spit2.play()
			spawn_coords = $MainBody/Head/MouthSpawn.global_transform.origin
			emit_signal("spawn_ebola")
			#print('spawning ebola')
			spitting = false
		if MidRay.is_colliding():
			#print('spit path blocked, rotating')
			#rotate_y(deg2rad(2)) #spins until spit
			spitting = false
	elif aggro == true:
		#print('aggro step 1')
		if chase == false:
			#print('aggro step 2')
			if decide_chase == false:
				#print('aggro step 3')
				decide_chase = true
				$WakeUpTimer.start()
				$Aggro.play()
				$AnimationPlayer.play("Awaken")
				print('Woke up')
		if chase == true:
			if walking == false:
				walking = true
				$Walk.stream_paused = false
				$AnimationPlayer.play("WalkCycle1")
			for body in sight_area.get_overlapping_bodies():
				if body.is_in_group("Player"):
					var direction = body.global_transform.origin - self.global_transform.origin
					move_and_slide(direction * (move_speed), Vector3.UP)
					look_at(body.global_transform.origin, Vector3.UP)
					self.rotation.x = clamp(self.rotation.x, deg2rad(0), deg2rad(-0))
					self.rotation.z = clamp(self.rotation.z, deg2rad(0), deg2rad(-0))
	elif reorient_behavior == true:
		if reorienting == false:
			$AnimationPlayer.play("WalkCycle1")
			reorienting = true
			rng.randomize()
			var choice = rng.randi_range(1,2)
			var x_z = rng.randi_range(0,3)
			if RightRay.is_colliding() and not LeftRay.is_colliding():
				#print('behavior left')#-x
				move_modify_x = -1
			if LeftRay.is_colliding() and not RightRay.is_colliding():
				#print('behavior right') #+x
				move_modify_x = 1
			if MidRay.is_colliding():
				pass
				#print('obstacle in front')
			if RightRay.is_colliding() and LeftRay.is_colliding():
				move_modify_x = 0
				#print('double colision')
			elif not RightRay.is_colliding() and not LeftRay.is_colliding():
				if choice == 1:
					move_modify_x = -1
				elif choice == 2:
					move_modify_x = 1
				#print('random vector')
			else:
				move_modify_x = 0
			if unseen_attacker == true:
				unseen_attacker = false
				var neg_pos = 0
				if choice == 1:
					neg_pos = -3
				elif choice == 2:
					neg_pos = 3
				if x_z == 0: #x
					move_modify_x = neg_pos
				elif x_z == 1: #z
					move_modify_z = neg_pos
				elif x_z == 3: #both
					move_modify_z = neg_pos
					move_modify_x = neg_pos
				#print(move_modify_x)
				#print(move_modify_z)
			
		var direction = player_last_seen - self.global_transform.origin
		direction.x += move_modify_x
		direction.z += move_modify_z
		#print(move_modify_x)
		move_and_slide(direction * (-0.1), Vector3.UP)


	if aggro == false:
		if reorient_behavior == false:
			walking = false
			#print('Went dormant')
			if dead == false:
				$AnimationPlayer.play("RESET")
				$Walk.stream_paused = true
		
	

func take_damage(damage):
	if dead == false:
		health -= damage
		if hurt == false:
			blood.emitting = true
			$Hurt.play()
			hurt = true
			$HurtTimer.start()
		elif hurt == true:
			headblood.emitting = true
	###
		if aggro == false:
			unseen_attacker = true
			reorient_behavior = true
			#print('timerstart')
			$BehaviorTimer.start()
	die()
	
func die():
	if dead == false:
		if health <= 0:
			dead = true
			$MainBody/Head/HeadSplatter2.emitting = true
			can_attack = false
			$AnimationPlayer.play("Death")
			#sounds
			$DeathTimer.start()
func attack_animation():
	rng.randomize()
	var attack_pattern = rng.randi_range(1, 3)
	if attack_pattern == 1:
		$AnimationPlayer.play("StartAttack")
		$Attack2.play()
	elif attack_pattern == 2:
		$AnimationPlayer.play("Attack1Fast")
		$Attack.play()
	elif attack_pattern == 3:
		$AnimationPlayer.play("Attack2Fast")
		$Attack2.play()
	

func _on_Sight_radius_body_entered(body):
	if body.is_in_group('Player'):
		aggro = true
	if body.is_in_group('Blob'):
		print('Spotted Corrupted Threat')
		slime_aggro = true #have to make some way of getting them unaggroed after slimes are dead or prioritizing one enemy first
		$Slime_aggro.start()

func _on_Sight_radius_body_exited(body):
	if body.is_in_group('Player'):
		aggro = false
		chase = false
		if reorient_behavior == false:
			reorient_behavior = true
			#print('timerstart')
			$BehaviorTimer.start()
		player_last_seen = body.global_transform.origin
	if body.is_in_group('Blob'):
		slime_aggro = false


func _on_Behavior_radius_body_exited(body):
	if body.is_in_group('Player'):
		if spit_cooldown == false:
			rng.randomize()
			var choice = rng.randi_range(1,5)
			#print(choice)
			if choice >= 2:
				spitting = true
				#print('spitting')


func _on_WakeUpTimer_timeout():
	chase = true
	decide_chase = false


func _on_BarfCooldown_timeout():
	spit_cooldown = false


func _on_AttackTimer_timeout():
	#if NotWall.is_colliding():
		#print('NotWall colliding')
	#if IsWall.is_colliding():
		#print('IsWall colliding')
	#if HeightMax.is_colliding():
		#print('Heightmax colliding')
	#print(fall.y)
	#climbing debug
	
	#wallstuck debug
	var attack_zone = $attack_area.get_overlapping_bodies()
	for body in attack_zone:
		if body.is_in_group('Player'):
			body.take_damage(damage)
			body.infection_check()
		if body.is_in_group('Blob'):
			body.take_damage(damage)
		if body.is_in_group('Destructible'):
			body.take_damage(damage)
	walking = false

func _on_attack_area_body_entered(body):
	if can_attack == true:
		var attack_zone = $attack_area.get_overlapping_bodies()
		for body in attack_zone:
			if body.is_in_group('Player'):
				$AttackTimer.start()
				$NextAttackTimer.start()
				$AnimationPlayer.play("StartAttack")
			if body.is_in_group('Blob'):
				$NextAttackTimer.start()
				$AttackTimer.start()
				$AnimationPlayer.play("StartAttack")
			if body.is_in_group('Obstacle'):
				$NextAttackTimer.start()
				$AttackTimer.start()
				$AnimationPlayer.play("StartAttack")
				$Attack.play()

func _on_NextAttackTimer_timeout():
	if can_attack == true:
		var attack_zone = $attack_area.get_overlapping_bodies()
		for body in attack_zone:
			if body.is_in_group('Player'):
				$AttackTimer.start()
				$NextAttackTimer.start()
				attack_animation()
			if body.is_in_group('Blob'):
				$NextAttackTimer.start()
				$AttackTimer.start()
				attack_animation()
			if body.is_in_group('Obstacle'):
				if aggro == true:
					$NextAttackTimer.start()
					$AttackTimer.start()
					attack_animation()


func _on_BehaviorTimer_timeout():
	#print('behaving')
	move_modify_x = 0
	move_modify_z = 0
	reorient_behavior = false
	reorienting = false


func _on_DeathTimer_timeout():
	queue_free()


func _on_attack_area_body_exited(body):
	#walking = false
	pass


func _on_Slime_aggro_timeout():
	slime_aggro = false




func _on_Behavior_radius_body_entered(body):
	if SightLine.is_colliding():
		var sight = SightLine.get_collision_point()


func _on_HurtTimer_timeout():
	hurt = false


func _on_DebugTimer_timeout():
	#print("aggro is ", aggro)
	#print("reorienting behavior is ", reorient_behavior)
	#print("reorienting is", reorienting)
	#print('walking is ', walking)
	#print('chase is ', chase)
	#print('spitting is ', spitting)
	#print('slime aggro is ', slime_aggro)
	pass
