extends Spatial


var health = 20
var Name = 'Barrel'
var broken = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		if broken == false:
			$BingoBean1/BingoBarrel1/CollisionShape.queue_free()
			$BingoBean1/BingoBarrel1/barrel.queue_free()
			$BingoBean1/BingoBarrel1.queue_free()
			$Break.play()
			broken = true

func take_damage(incoming_damage):
	health -= incoming_damage
	print('Ouch!')
	$Break.play()
