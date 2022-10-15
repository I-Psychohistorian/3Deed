extends KinematicBody


var speed = 5
var acceleration = 20
var gravity = 9.8

#each tick at true allows for updates
var status_tick = false

var stamina_max = 100
var stamina_regen = 1
var stamina = 100
var health = 100
var status = false
var ammo = 0 
var sprint = false
var exertion = false
#exertion is for checking sprint

var mouse_hidden = true
var mouse_sensitivity = 0.05

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()

onready var head = $Head
onready var hud = $Head/Camera/HUD

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
	if event.is_action_pressed("quit"):
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	direction = Vector3()
	handle_sprint()
	status_upkeep()
	update_hud()
	if not is_on_floor():
		fall.y -= gravity * delta
		move_and_slide(fall, Vector3.UP)
	
	if is_on_floor():
		fall.y = 0
	
	if Input.is_action_just_pressed("menu"):
		if mouse_hidden == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_hidden = false
		elif mouse_hidden == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		sprint_check()
		fall.y += speed
	
	if Input.is_action_pressed("forward"):
		direction -= transform.basis.z
		sprint_check()
	elif Input.is_action_pressed("backward"):
		direction += transform.basis.z
		sprint_check()
	if Input.is_action_pressed("left"):
		direction -= transform.basis.x
		sprint_check()
	elif Input.is_action_pressed("right"):
		direction += transform.basis.x
		sprint_check()
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)

func update_hud():
	hud.health = health
	hud.stamina = stamina
	hud.ammo = ammo
	hud.status = status
	hud.sprint = sprint
	
#this is for stamina regen and health and status effects
#status effects will come later
func status_upkeep():
	if status_tick == true:
		if stamina < stamina_max:
			stamina += stamina_regen
		if exertion == true:
			stamina -= 3
			exertion = false
		status_tick = false
	if stamina <= 0:
		sprint = false
		speed = 5
		stamina = 0

func sprint_check():
	if sprint == true:
		exertion = true
	
func handle_sprint():
	if Input.is_action_just_pressed("sprint_toggle"):
		if sprint == false:
			sprint = true
		elif sprint == true:
			sprint = false
		if sprint == true:
			speed = 8
			acceleration = 30
		else:
			speed = 5
			acceleration = 20


func _on_StatusTick_timeout():
	status_tick = true
