extends KinematicBody


var health = 50
var damage = 6
var Name = 'Glorper'

var gravity = 1
var hurt = false
var aggro = false
var scared = false
var dead = false

#random speed modifier to add eratic behavior
var mod = 0
var random_walk_active = true
var direction_int = 0
var x_or_z = 0

#used for multiplying glorpers if they are sated
signal not_hungry

signal anaphase

var spawn_coords = Vector3()

onready var spawnpoint = $UpGlorp
onready var buds = $Core/Buds
var budded = false
var divided = false
var about_to_divide = false

#used for flora seeding
var seeded = false
var began_seeding = false
signal plant_seed
onready var plant_timer = $PlantTimer


var random = RandomNumberGenerator.new()

var direction = Vector3()
var fall = Vector3()


onready var Blorp_Area = $BlorpArea
onready var sight_area = $VisionBox
onready var glorp_scared = $GlorpCoreParticlesDark
onready var glorp_normal = $GlorpCoreParticles
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("bud_idle")
	random.randomize()
	var ambient = random.randi_range(0,1)
	if ambient == 0:
		$Ambient1.play()
		#print('Ambient1')
	elif ambient == 1:
		$Ambient2.play()
		#print('Ambient2')

#used with mother glorper
func reparent():
	$ReparentTimer.start()


#moves one step up as is used in mitosis
func reparent2():
	var new_parent = get_parent().get_parent().get_parent()
	get_parent().remove_child(self)
	new_parent.get_parent().get_parent().add_child(self)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	death()
	movement()
	mitosis()
	begin_planting()
	if not is_on_floor():
		fall.y -= gravity * delta
		move_and_slide(fall, Vector3.UP)
	elif is_on_floor():
		fall.y = 0
	if is_on_wall():
		fall.y = 0.4
		move_and_slide(fall, Vector3.UP)
		#print('hugged wall')
		
func take_damage(incoming_damage):
	health -= incoming_damage
	#print('Ouch!')
	$Blouch.play()
	$GlorpSpew.emitting = true

func begin_planting():
	if seeded == true:
		if began_seeding == false:
			$SeedTimer.start()
			print('started looking to plant')
			began_seeding = true

func movement():
	random.randomize()
	var speed = 0.5
	var speed_direction = 1
	var hp_speed = (health/50)
	
	if scared == true:
		speed_direction = -1.0
	elif scared == false:
		speed_direction = 1.0
	speed_direction *= mod
	if aggro == true:
		if random_walk_active == false:
			random_walk_active = true
		for body in sight_area.get_overlapping_bodies():
			if body.is_in_group("Player"):
				direction = body.global_transform.origin - self.global_transform.origin
				move_and_slide(direction * (speed_direction * (speed + hp_speed)), Vector3.UP)
	if aggro == false:
		for body in sight_area.get_overlapping_bodies():
			if scared == true:
				if body.is_in_group("Flora"):
					if body.nascent == false:
						direction = body.global_transform.origin - self.global_transform.origin
						random.randomize()
						var scavenge_mod = random.randf_range(-0.3,0.3)
						move_and_slide(direction * ((speed+scavenge_mod)), Vector3.UP)
			if scared == false:
				if divided == false:
					if body.is_in_group("Flora"):
						if body.nascent == false:
							direction = body.global_transform.origin - self.global_transform.origin
							random.randomize()
							var scavenge_mod = random.randf_range(-0.3,0.3)
							move_and_slide(direction * ((speed+scavenge_mod)), Vector3.UP)
		if random_walk_active == true:
			random_walk()


func random_walk():
	if x_or_z <= 1:
		direction = self.global_transform.origin - (self.global_transform.origin - Vector3(direction_int, 0, 0))
	elif x_or_z == 2: 
		direction = self.global_transform.origin - (self.global_transform.origin + Vector3(0, 0, direction_int))
	move_and_slide(direction * 0.3, Vector3.UP)
		

func death():
	if scared == false:
		glorp_normal.emitting = true
		glorp_scared.emitting = false
	elif scared == true:
		glorp_normal.emitting = false
		glorp_scared.emitting = true
	if health <= -20:
		scared = true
	elif health >= -20:
		scared = false
	if health < -65:
		if dead == false:
			if seeded == true:
				spawn_coords = $UpGlorp.global_transform.origin
				var coin = random.randi_range(1,2)
				print(coin)
				if coin == 1:
					spread_seeds()
			$DeathTimer.start()
			$GlorpSplosion.emitting = true
			$Boom.play()
			dead = true

func acid_hazard():
	for body in Blorp_Area.get_overlapping_bodies():
		if body.is_in_group("Player"):
			body.take_damage(damage)
			print("Blorp!")
			$Blorp.play()
		if body.is_in_group("Spinner"):
			body.take_damage(damage)
			print("Blorp!")
			$Blorp.play()
		if body.is_in_group("Flora"):
			body.take_damage(damage)
			print("Blorp is tasty!")
			$Blorp.play()

func mitosis():
	if divided == true:
		if budded == false:
			buds.visible = false
			budded = true
	if divided == false:
		if health > 55:
			health -= 5
			$Blorp.play()
			health -= 20
			$GlorpSpew.emitting = true
			about_to_divide = true
			spawn_coords = $UpGlorp.global_transform.origin
			print(spawn_coords)
			emit_signal("anaphase")
			print('popping')
			divided = true

func spread_seeds():
	spawn_coords = $UpGlorp.global_transform.origin
	emit_signal("plant_seed")
	seeded = false
	began_seeding = false

func connect_signals_to_parent():
	var GlorpManager = get_parent()
	connect('anaphase', GlorpManager, "spawn_glorpers")
	connect('plant_seed', GlorpManager, "plant_plant")

func _on_BlorpArea_body_entered(body):
	pass # Replace with function body.


func _on_BlorpTimer_timeout():
	acid_hazard()


func _on_VisionBox_body_entered(body):
	if body.is_in_group('Player'):
		#var coords = body.get_global_transform()
		aggro = true
	if body.is_in_group('Flora'):
		#print('PLANT SPOTTED')
		pass

func _on_VisionBox_body_exited(body):
	if body.is_in_group('Player'):
		aggro = false


func _on_SpeedModTimer_timeout():
	random.randomize()
	mod = random.randf_range(0.7, 1.4)



func _on_DeathTimer_timeout():
	queue_free()


func _on_SeedTimer_timeout():
	random.randomize()
	var chance_of_seed = random.randi_range(1,3)
	print(chance_of_seed)
	if chance_of_seed == 3:
		spread_seeds()
		#print('planted a seed')
	elif chance_of_seed == 2:
		#print('lost seed')
		began_seeding = false
		seeded = false
	else:
		#print('did not seed yet')
		began_seeding = false


func _on_PlantTimer_timeout():
	spread_seeds()


func _on_RandomWalkTimer_timeout():
	random.randomize()
	#print('random walk direction int = ' + String(direction_int))
	#print('random walk x or z = ' + String(x_or_z))
	direction_int = random.randi_range(-2,2)
	x_or_z = random.randi_range(1,2)


func _on_ReparentTimer_timeout():
	var new_parent = get_parent().get_parent().get_parent()
	print(new_parent)
	print(get_parent())
	get_parent().remove_child(self)
	new_parent.add_child(self)
