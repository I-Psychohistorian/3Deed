extends KinematicBody


var health = 180
var damage = 5
var Name = "MotherGlorper"

var gravity = -10
var hurt = false
var aggro = false
var dead = false

var spawning = false

var random = RandomNumberGenerator.new()

var direction = Vector3()
var fall = Vector3()

onready var Blorp_Area = $Hurt_area
signal death

onready var spawnpoint = $GlorperSpawn
onready var babyglorp = preload("res://Entities/Glorper.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fall.y = gravity
	move_and_slide(fall, Vector3.UP)
	die()

func take_damage(incoming_damage):
	health -= incoming_damage
	print('Ouch!')
	$Blouch.play()
	$GlorpSpew.emitting = true
	
func acid_hazard():
	for body in Blorp_Area.get_overlapping_bodies():
		if body.is_in_group("Player"):
			body.take_damage(damage)
			print("Blorp!")
			$Blorp.play()

func die():
	if health <= -20:
		if dead == false:
			$DeathTimer.start()
			$Boom.play()
			$GlorpSplosion.emitting = true
			$GlorpSplosion2.emitting = true
			$GlorpSplosion3.emitting = true
			dead = true
			emit_signal("death")

func SpawnGlorp():
	if spawning == false:
		gravity = 4
		$RiseTimer.start()
		spawning = true

func _on_Hurt_area_body_entered(body):
	pass # Replace with function body.

#every time this autostart timer goes off there is damage to surroundings
func _on_BlorpTimer_timeout():
	acid_hazard()


func _on_SpawnTimer_timeout():
	if aggro == true:
		SpawnGlorp()


func _on_RiseTimer_timeout():
	if spawning == true:
		gravity = -8
		$SpawnGlorp.play()
		$GlorpBirth.emitting = true
		var b = babyglorp.instance()
		spawnpoint.add_child(b)
		b.reparent()
		spawning = false

#will kill all children suddenly, may want to change this somewhat
func _on_DeathTimer_timeout():
	queue_free()


func _on_AggroArea_body_entered(body):
	if body.is_in_group("Player"):
		aggro = true


func _on_AggroArea_body_exited(body):
	if body.is_in_group("Player"):
		aggro = true


func _on_ReparentTimer_timeout():
	pass # Replace with function body.
