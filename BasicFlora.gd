extends KinematicBody


# Declare member variables here. Examples:
var health = 5
var Name = "Edible Flower"
var stages = ["Sprout", "Mid", "FullyGrown"]
var current_stage = "Sprout"
var dead = false

var fall = Vector3()
var gravity = 1

var growing = false
var nascent = false

#player tests if is interactable
var active = true

onready var plant1 = $flowersLow
onready var plant2 = $flowers
onready var plant3 = $plant
onready var overgrowth = $flowersLow2
# Called when the node enters the scene tree for the first time.
func _ready():
	check_growth()
	#print(active)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	die()
	fall.y -= gravity
	move_and_slide(fall, Vector3.UP)



func take_damage(incoming_damage):
	if nascent == false:
		for body in $Surrounding.get_overlapping_bodies():
			if body.is_in_group('Blob'):
				body.health += 5
				body.seeded = true
		health -= incoming_damage
		print('Plant Ouch')
		$Sound.play()
	check_growth()
	if nascent == true:
		print('Plant Still Seed!')

func use():
	for body in $Surrounding.get_overlapping_bodies():
		if body.is_in_group('Player'):
			body.stamina += health
			body.health += 1
			body.crunch.play()
			queue_free()

func check_growth():
	if nascent == false:
		if health <= 5:
			current_stage = stages[0]
			plant3.visible = false
			plant2.visible = false
			plant1.visible = true
			overgrowth.visible = false
		elif health <=10:
			current_stage = stages[1]
			plant2.visible = true
			plant3.visible = false
			overgrowth.visible = false
		elif health == 15:
			current_stage = stages[2]
			plant3.visible = true
			overgrowth.visible = false
		elif health > 15:
			current_stage = stages[2]
			overgrowth.visible = true
	if nascent == true:
		active = false
		plant1.visible = false
		plant2.visible = false
		plant3.visible = false
		overgrowth.visible = false

	#print(current_stage)
	#print(health)

func die():
	if dead == false:
		if health <= 0:
			dead = true
			queue_free()
	
func _on_GrowthTimer_timeout():
	if nascent == false:
		if current_stage == "Sprout":
			#growing = true
			health += 5
			check_growth()
			$Sound.play()
		elif current_stage == "Mid":
			#growing = true
			health += 5
			check_growth()
			$Sound.play()
		elif current_stage == "FullyGrown":
			check_growth()
	elif nascent == true:
		nascent = false
		active = true
		check_growth()
