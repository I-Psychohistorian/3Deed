extends KinematicBody


var Name = "Gas Tank"

var health = 100
var exploded = false
signal explode
signal leaking
signal leak_stopped
var hurt = false

var fire_damage = 5
var explosion_damage = 80
#add vector pushback later?

var leaking = false
var leak_toggle = false
var rightening = false
var leftening = false
var venting = false

onready var leaksound = $Leak #looped, pause stream required
onready var damagesound = $Hit
onready var fwoosh = $Explode1
onready var debrisafter = $Explode2
onready var burning = $Fire #looped

onready var valve = $CSGSphere/ValveInteractor/Valve/ValveJoint
onready var interact_zone = $CSGSphere/ValveInteractor/Area
onready var fire_zone = $FireDamage

onready var gasfire = preload("res://Effects/GasFirespread.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	burning.stream_paused = true
	leaksound.stream_paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	resolve_actions()

func resolve_actions():
	if rightening == true:
		valve.rotate_x(deg2rad(1))
	elif leftening == true:
		valve.rotate_x(deg2rad(-1))
	if leak_toggle == false:
		leak_toggle = true
		if leaking == true:
			leaksound.stream_paused = false
		elif leaking == false:
			leaksound.stream_paused = true



func take_damage(damage):
	if exploded == false:
		if hurt == false:
			hurt = true
			damagesound.play()
			$Hurt.start()
		health -= damage
		if health <= 0:
			if exploded == false:
				exploded = true
				fast_explode()

func explode():
	venting = true
	$ValveFire.visible = true
	$FireTick.start()
	burning.stream_paused = false
	$Exploding.start()
	
	

func _on_ValveInteractor_loosen():
	leftening = true
	$Turn.start()


func _on_ValveInteractor_tighten():
	rightening = true
	$Turn.start()



func _on_Turn_timeout():
	leak_toggle = false
	rightening = false
	leftening = false
	if leaking == false:
		leaking = true
		emit_signal("leaking")
	elif leaking == true:
		leaking = false
		emit_signal("leak_stopped")

func _on_Hurt_timeout():
	hurt = false


func _on_Exploding_timeout():
	emit_signal("explode")
	var g = gasfire.instance()
	self.add_child(g)
	$BigFire.visible = true
	fwoosh.play()
	venting = false
	$ValveFire.visible = false
	var bodies = interact_zone.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			body.take_damage(explosion_damage)
		if body.is_in_group('Enemy'):
			body.take_damage(explosion_damage)
		if body.is_in_group('Destructible'):
			body.take_damage(explosion_damage)
	$AfterFwoosh.start()

func fast_explode():
	emit_signal("explode")
	var g = gasfire.instance()
	self.add_child(g)
	$BigFire.visible = true
	fwoosh.play()
	venting = false
	$ValveFire.visible = false
	var bodies = interact_zone.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			body.take_damage(explosion_damage)
		if body.is_in_group('Enemy'):
			body.take_damage(explosion_damage)
		if body.is_in_group('Destructible'):
			body.take_damage(explosion_damage)
	$AfterFwoosh.start()

func _on_AfterFwoosh_timeout():
	$CSGCylinder.visible = false
	$CSGSphere.visible = false
	debrisafter.play()
	$Aftermath.start()


func _on_FireTick_timeout():
	if venting == true:
		var bodies = fire_zone.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group('Player'):
				body.take_damage(fire_damage)
			if body.is_in_group('Enemy'):
				body.take_damage(fire_damage)
			if body.is_in_group('Destructible'):
				body.take_damage(fire_damage)


func _on_Aftermath_timeout():
	queue_free()


func _on_ExplosionManager_lit_gas():
	explode()
