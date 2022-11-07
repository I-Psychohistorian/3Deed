extends KinematicBody


var health = 10
var dead = false
var Name = "Strange wooden construct with crystal"
var active = true
var spinning = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$IdleAggro.stream_paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead == false:
		if spinning == true:
			$Crystal.rotate_y(deg2rad(10))

func use():
	if spinning == false:
		spinning = true
		$Crystal/Fire.visible = true
		$IdleAggro.stream_paused = false
	elif spinning == true:
		spinning = false
		$Crystal/Fire.visible = false
		$IdleAggro.stream_paused = true

func take_damage(damage):
	if dead == false:
		health -= damage
		if health <= 0:
			dead = true
			die()
		
func die():
	$Glass.emitting = true
	$Crystal/Fire.visible = false
	$Crystal.visible = false
	active = false
	$CrystalBreak.play()
	$IdleAggro.stream_paused = true
