extends KinematicBody

var Name = "WoodClaw"
var health = 25
var dead = false
var aggro = false
signal die
var damage = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damage):
	health -= damage
	$Ouch.play()
	if health <= 0:
		die()

func aggro():
	aggro = true
	$Spike_zone/CollisionShape.disabled = false
	$AnimationPlayer.play("IdleVibrate")

func deaggro():
	aggro = false
	$Spike_zone/CollisionShape.disabled = true
	$AnimationPlayer.play("RESET")

func die():
	emit_signal('die')


func _on_Spike_zone_body_entered(body):
	if body.is_in_group('Player'):
		print('spike hit player')
		$Hit.play()
		body.take_damage(damage)
