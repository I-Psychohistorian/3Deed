extends KinematicBody


var health = 100
var armor = 2
var Name = "StoneColumn"
var dead = false
var halfbroke = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if halfbroke == false:
		if health <= 50:
			halfbroke = true
			$column.visible = false
			$StoneDeath.play()
	if dead == false:
		if health <= 0:
			dead = true
			$DeathTimer.start()
			$StoneDeath.play()

func take_damage(incoming_damage):
	health -= (incoming_damage-armor)
	print('Thump!')
	$StoneBreak.play()

func _on_DeathTimer_timeout():
	queue_free()
