extends KinematicBody

var Name = "Turn On"
var pickup = "Computer"
onready var radius = $Area
var on = false
var broke = false
var active = true

var screen_text = "There's lots of biometric data on the infected here. There's also a complaint about lack of eyewash stations."
var screen_text2 = "A single textfile reads 'SERUM IN FRIDGE ONE DOSE PER PERSON SLOWS INFECTION. NOTES ON DESK'"

var read_num = 1

var health = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damage):
	health -= damage
	if health <= 0:
		if broke == false:
			broke = true
			$Break.play()
			active = false
			$Case/ScreenBroke.visible = true
			$Case/ScreenOn.visible = false

func use():
	var bodies = radius.get_overlapping_bodies()
	for n in bodies:
		if n.is_in_group("Player"):
			if on == false:
				on = true
				$Case/ScreenOn.visible = true
				$On.play()
				Name = "Browse Files"
			elif read_num == 1:
				read_num += 1 
				n.dialogue_text = screen_text
				n.tick_dialogue()
				Name = "Keep Browsing Files"
			elif read_num == 2:
				n.dialogue_text = screen_text2
				n.tick_dialogue()
				Name = "Turn Off"
				read_num = 0
			elif on == true:
				on = false
				Name = "Turn On"
				read_num = 1
				$Case/ScreenOn.visible = false
		
