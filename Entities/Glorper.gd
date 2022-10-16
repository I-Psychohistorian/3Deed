extends KinematicBody


var health = 50
var damage = 5
var Name = 'Glorper'

var gravity = 1
var hurt = false
var aggro = true
var scared = false
var dead = false

#random speed modifier to add eratic behavior
var mod = 0


var random = RandomNumberGenerator.new()

var direction = Vector3()
var fall = Vector3()


onready var Blorp_Area = $BlorpArea
onready var sight_area = $VisionBox
onready var glorp_scared = $GlorpCoreParticlesDark
onready var glorp_normal = $GlorpCoreParticles
# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	var ambient = random.randi_range(0,1)
	if ambient == 0:
		$Ambient1.play()
		print('Ambient1')
	elif ambient == 1:
		$Ambient2.play()
		print('Ambient2')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	death()
	movement()
	if not is_on_floor():
		fall.y -= gravity * delta
		move_and_slide(fall, Vector3.UP)
	elif is_on_floor():
		fall.y = 0
	if is_on_wall():
		fall.y = 0.4
		move_and_slide(fall, Vector3.UP)
		print('hugged wall')
		
func take_damage(incoming_damage):
	health -= incoming_damage
	print('Ouch!')
	$Blouch.play()
	$GlorpSpew.emitting = true

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
		for body in sight_area.get_overlapping_bodies():
			if body.is_in_group("Player"):
				direction = body.global_transform.origin - self.global_transform.origin
				move_and_slide(direction * (speed_direction * (speed + hp_speed)), Vector3.UP)


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


func _on_BlorpArea_body_entered(body):
	pass # Replace with function body.


func _on_BlorpTimer_timeout():
	acid_hazard()


func _on_VisionBox_body_entered(body):
	if body.is_in_group('Player'):
		var coords = body.get_global_transform()
		print(coords)
		aggro = true

func _on_VisionBox_body_exited(body):
	if body.is_in_group('Player'):
		aggro = false


func _on_SpeedModTimer_timeout():
	random.randomize()
	mod = random.randf_range(0.7, 1.4)



func _on_DeathTimer_timeout():
	queue_free()
