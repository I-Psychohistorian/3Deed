extends KinematicBody


var Name = 'Tripod Creature'
var health = 10
var active = true
var searching = true
var target_chosen = false
var alive = true
var text = "It seems rather friendly"

var speed = 0.25
var personality = 1
var rng = RandomNumberGenerator.new()

onready var sight = $Sight

var target = Vector3()
var direction = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Pulse")
	rng.randomize()
	var num = rng.randi_range(1,3)
	speed = speed*num
	personality = num
	if personality == 2:
		health += 10
		text = "It seems rather docile"
	elif personality == 1:
		text = "It seems quite curious"
	print(personality)
	print(speed)
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	seek_light()
	if alive == true:
		move()
	
func use():
	var bodies = sight.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			body.dialogue_text = text
			body.tick_dialogue()

func die():
	$AnimationPlayer.play("Death")
	$DeathTimer.start()

func move():
	if target_chosen == true:
		look_at(target, Vector3.UP)
		direction = target - self.global_transform.origin
		move_and_slide(direction * speed, Vector3.UP)

func seek_light():
	if searching == true:
		var areas = sight.get_overlapping_areas()
		for area in areas:
			if area.is_in_group('Light'):
				if area.activated == true:
					if target_chosen == false:
						target = area.global_transform.origin
						target_chosen = true
						if personality == 1:
							speed += 1
							$Timer.start()

func take_damage(damage):
	health -= damage
	if health <= 0:
		if alive == true:
			alive = false
			die()

#sprinter behavior
func _on_Timer_timeout():
	speed -= 1


func _on_HealthDegen_timeout():
	take_damage(1)
	print("Tripod Health ", health)


func _on_DeathTimer_timeout():
	queue_free()


func _on_Attention_timeout():
	target_chosen = false
