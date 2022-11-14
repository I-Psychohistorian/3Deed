extends RigidBody


var player = 0
var contains = "Nothing"
var Name = "Take Bingo Bean"
var active = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	player.powerups +=1
	player.bingo()
	queue_free()

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		print('player in range of bean')
