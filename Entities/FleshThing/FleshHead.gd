extends KinematicBody


var health = 100
var damage = 2
var Name = "Bull Head"

var enemy_spotted = false
signal player_seen
signal player_unseen

var damaged = false
var transfered_damage = 0
signal transfer_damage

var player_last_seen = Vector3()

onready var sight_radius = $HeadSight
onready var headanim = $UpperAnimation
onready var bite_area = $Hurtzone
# Called when the node enters the scene tree for the first time.
func _ready():
	headanim.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	face_player()

func take_damage(damage):
	print('head damage')
	if health > 0:
		health -= damage
		$Splorch.play()
		$Torso/HeadSplatter2.emitting = true
	elif health <= 0:
		head_esplode()
		transfered_damage = damage
		print(damage, ' damage transfered')
		emit_signal("transfer_damage")
	print(health)

func head_esplode():
	if damaged == false:
		damaged = true
		$Torso/HeadSplatter2.emitting = true
		$Torso/Hole2.visible = true
		$Torso/Hole1.visible = true
		$Torso/HiddenPoker.visible = true 
		#animation?
		#sound?
		$HeadColide.disabled = true
		$Head.visible = false
		$Pincer1.visible = false
		$Pincer2.visible = false
		$Pincer3.visible = false

func attack():
	if damaged == false:
		headanim.play("BiteOpen")
		$Bite.play()
	elif damaged == true:
		headanim.play("NeckStab")
		$Stab.play()
	var bodies = bite_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			body.take_damage(damage)
		elif body.is_in_group("Destructible"):
			body.take_damage(damage)

func face_player():
	var bodies = sight_radius.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			look_at(body.global_transform.origin, Vector3.UP)
			self.rotation.x = clamp(self.rotation.x, deg2rad(-30), deg2rad(30))
			self.rotation.z = clamp(self.rotation.z, deg2rad(-30), deg2rad(30))
			self.rotation.y = clamp(self.rotation.y, deg2rad(-30), deg2rad(30))


func _on_HeadSight_body_exited(body):
	if body.is_in_group('Player'):
		player_last_seen = body.global_transform.origin
		enemy_spotted = false
		headanim.play("RESET")
		emit_signal("player_unseen")

func _on_HeadSight_body_entered(body):
	if body.is_in_group('Player'):
		enemy_spotted = true
		headanim.play("Open")
		emit_signal("player_seen")


func _on_Hurtzone_body_entered(body):
	pass
	#if body.is_in_group("Player"):
	#	attack()
	#elif body.is_in_group("Destructible"):
	#	attack()


func _on_AttackTimer_timeout():
	var targets = bite_area.get_overlapping_bodies()
	for t in targets:
		if t.is_in_group("Player"):
			attack()
		elif t.is_in_group("Destructible"):
			attack()
