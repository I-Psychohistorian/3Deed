extends KinematicBody


var health = 80
var damage = 10
var Name = "FleshPhage"

var gravity = 8
var spin_factor = 9
var spin_speed = 15
var move_speed = 1
var hurt = false

var aggro = false
var chase = false

var decide_chase = false
var walking = false

var slime_aggro = false
var spitting = false
var spit_cooldown = false

var reorient_behavior = false
var reorienting = false

var dead = false

var can_attack = true

signal spawn_ebola

var rng = RandomNumberGenerator.new()

onready var headblood = $MainBody/Head/HeadSplatter
onready var blood = $Splatter
onready var barf = $MainBody/Head/BarfAttack

onready var sight_area = $Sight_radius

var fall = Vector3()
#planned behaviors
#dormant, until aggroed will give chase
#if players run and exit range it will make a ranged attack
#head rotates to follow player direction
#ranged attack will spawn ebola looking seeker enemy that will chase the player, try to latch on and deal damage
#when players exit aggro range, fleshphage will do a random walk in a direction and go dormant, unless agrroed during
#this action or after
#spooky sound design



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

func movement():
	if spitting == true:
		spitting = false
		spit_cooldown = true
		$BarfCooldown.start()
		barf.emitting = true
		emit_signal("spawn_ebola")
		print('spawning ebola')
	elif aggro == true:
		if chase == false:
			if decide_chase == false:
				decide_chase = true
				$WakeUpTimer.start()
				$AnimationPlayer.play("Awaken")
		if chase == true:
			if walking == false:
				walking = true
				$AnimationPlayer.play("WalkCycle1")
			for body in sight_area.get_overlapping_bodies():
				if body.is_in_group("Player"):
					var direction = body.global_transform.origin - self.global_transform.origin
					move_and_slide(direction * (move_speed), Vector3.UP)
					look_at(body.global_transform.origin, Vector3.UP)
					
	elif reorient_behavior == true:
		if reorienting == false:
			reorienting = true
			rng.randomize()
			var x_or_y = rng.randi_range(1,2)
			$BehaviorTimer.start()
			print('no reorienting yet')
	elif aggro == false:
		$AnimationPlayer.play("RESET")
	if reorient_behavior == false:
		if chase == false:
			walking = false
		
	

func take_damage(damage):
	health -= damage
	blood.emitting = true
	die()
	
func die():
	if dead == false:
		if health <= 0:
			dead = true
			can_attack = false
			$AnimationPlayer.play("Death")
			#sounds
			$DeathTimer.start()
func attack_animation():
	rng.randomize()
	var attack_pattern = rng.randi_range(1, 3)
	if attack_pattern == 1:
		$AnimationPlayer.play("StartAttack")
	elif attack_pattern == 2:
		$AnimationPlayer.play("Attack1Fast")
	elif attack_pattern == 3:
		$AnimationPlayer.play("Attack2Fast")

func _on_Sight_radius_body_entered(body):
	if body.is_in_group('Player'):
		aggro = true
	if body.is_in_group('Blob'):
		slime_aggro = true #have to make some way of getting them unaggroed after slimes are dead or prioritizing one enemy first


func _on_Sight_radius_body_exited(body):
	if body.is_in_group('Player'):
		aggro = false
		chase = false
		reorient_behavior = true


func _on_Behavior_radius_body_exited(body):
	if spit_cooldown == false:
		spitting = true


func _on_WakeUpTimer_timeout():
	chase = true


func _on_BarfCooldown_timeout():
	spit_cooldown = false


func _on_AttackTimer_timeout():
	var attack_zone = $attack_area.get_overlapping_bodies()
	for body in attack_zone:
		if body.is_in_group('Player'):
			body.take_damage(damage)
			body.disease = true
		if body.is_in_group('Blob'):
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


func _on_BehaviorTimer_timeout():
	reorient_behavior = false
	reorienting = false


func _on_DeathTimer_timeout():
	queue_free()


func _on_attack_area_body_exited(body):
	walking = false
