extends KinematicBody

var Name = "Pustule"
var health = 4
var alive = true

onready var bud = $FleshBud

# Called when the node enters the scene tree for the first time.
func _ready():
	bud.awake = false
	bud.collisions.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damage):
	if alive == true:
		health -= damage
		if health <= 0:
			alive = false
			pop()

func pop():
	$CollisionShape.disabled = true
	bud.collide()
	bud.awake = true
	bud.aggro = true
	alive = false
	$HeadSplatter2.emitting = true
	$Shell.visible = false
	
	
	$popsound.play()

func _on_pop_radius_body_entered(body):
	if body.is_in_group('Player'):
		if alive == true:
			pop()
	elif body.is_in_group('Blob'):
		if alive == true:
			pop()
