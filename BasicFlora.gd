extends KinematicBody


# Declare member variables here. Examples:
var health = 5
var Name = "Plant"
var stages = ["Sprout", "Mid", "FullyGrown"]
var current_stage = "Sprout"
var dead = false

var growing = false

onready var plant1 = $flowersLow
onready var plant2 = $flowers
onready var plant3 = $plant
onready var overgrowth = $flowersLow2
# Called when the node enters the scene tree for the first time.
func _ready():
	check_growth()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	die()

func take_damage(incoming_damage):
	for body in $Surrounding.get_overlapping_bodies():
		if body.is_in_group('Blob'):
			body.health += 5
		
	health -= incoming_damage
	check_growth()
	$Sound.play()
	print('Plant Ouch!')

func use():
	for body in $Surrounding.get_overlapping_bodies():
		if body.is_in_group('Player'):
			body.stamina += health
			body.crunch.play()
			queue_free()

func check_growth():
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
	print(current_stage)
	print(health)

func die():
	if dead == false:
		if health <= 0:
			dead = true
			queue_free()
	
func _on_GrowthTimer_timeout():
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
