extends KinematicBody


var health = 30
var Name = "Fleshy body"
var dialogue = "kkkkkiiiiii"
var dialogue2 = "ll meeee"
var dialogue3  = "..."
var active = true

var dead = false
var disease = true

onready var parasite = preload("res://Entities/FleshThing/FleshBud.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead == false:
		if health <= 0:
			dead = true
			#active = false
			Name = "Fleshy remains"
			die()

func take_damage(damage):
	if dead == false:
		health -= damage
		#play hurt sound

func use():
	var bodies = $Player_interact.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			if dead == false:
				body.dialogue_text = dialogue
				body.tick_dialogue()
			if dead == true:
				body.dialogue_text = dialogue3
				body.tick_dialogue()
		
	
func die():
	$DeathTimer.start()
	$HeadSplatter.emitting = true
	$HeadSplatter2.emitting = true
	$HeadSplatter3.emitting = true
	$Body.visible = false
	$Head/CSGCylinder/HeadHole.visible = true
	$BodyColider.disabled = true
	var p = parasite.instance()
	add_child(p)
	#deathtimer
	#deaethsound
	#SpawnEbolaWorm

func _on_DeathTimer_timeout():
	pass
