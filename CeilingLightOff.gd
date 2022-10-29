extends KinematicBody


var Name = 'Light'
var health = 20
var on = false
var broken = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func toggle():
	if broken == false:
		if on == false:
			on = true
			$Outside2.visible = true
			$Light.visible = true
		elif on == true:
			on = false
			$Outside.visible = false
			$Light.visible = false
		
func take_damage(damage):
	if broken == false:
		if damage > 10:
			broken = true
			$Break.play()
			$Light.visible = false
			$Outside2.visible = false
