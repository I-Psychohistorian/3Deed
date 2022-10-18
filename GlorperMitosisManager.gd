extends Spatial



onready var largearea = $GlorperBreedingArea
onready var new_glorper = preload("res://Entities/Glorper.tscn")

onready var nascent_plant = preload("res://Levels/BasicFlora.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_glorpers():
	for body in largearea.get_overlapping_bodies():
		if body.is_in_group("Blob"):
			if body.about_to_divide == true:
				var parent_glorper_position = body.spawn_coords
				var b = new_glorper.instance()
				add_child(b)
				b.global_transform.origin = parent_glorper_position
				body.about_to_divide = false
				print('spawned')
				b.connect_signals_to_parent()
func plant_plant():
	for body in largearea.get_overlapping_bodies():
		if body.is_in_group("Blob"):
			if body.began_seeding == true:
				var parent_glorper_position = body.spawn_coords
				var p = nascent_plant.instance()
				add_child(p)
				p.nascent = true
				p.check_growth()
				p.global_transform.origin = parent_glorper_position
				print('planted new plant')

func _on_Glorper_anaphase():
	spawn_glorpers()


func _on_Glorper_plant_seed():
	plant_plant()


func _on_Glorper2_anaphase():
	spawn_glorpers()


func _on_Glorper2_plant_seed():
	plant_plant()
