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
var exertion = false #for checking sprint stamina drain
var hurt = false #ticks for hurt sound and possibly stuns?


var LMB_cooldown = false #when true, cannot attack with left click


#weapon values
var knife_damage = 10
var gun_damage = 30
var fairy_damage = 15

#inventory stuff
var inv_weapons = []
var powerups = 1

var mouse_hidden = true
var mouse_sensitivity = 0.05

var weapons = ["BasicGun", "Knife", "Nothing", "Wizard"]
var equipped = []

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()

onready var head = $Head
onready var hud = $Head/Camera/HUD
onready var knife = $Head/Camera/EquipNode/Knife
onready var anim = $Head/Camera/EquipNode/AnimationPlayer
onready var StabZone = $Head/Camera/EquipNode/StabZone

# Called when the node enters the scene tree for the first time.
func _ready():
	print(weapons)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	equipped = weapons[2]
	print(equipped)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
	if event.is_action_released("powerup"):
		if powerups > 0:
			powerups -= 1
			use_powerup()
		else:
			print('No bingo beans left!')
	if event.is_action_pressed("quit"):
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	direction = Vector3()
	handle_sprint()
	handle_death()
	status_upkeep()
	update_hud()
	if not is_on_floor():
		fall.y -= gravity * delta
		move_and_slide(fall, Vector3.UP)
	
	if is_on_floor():
		fall.y = 0
	
	if Input.is_action_just_pressed("swap weapon"):
		switch_equipment()
	
	if Input.is_action_just_pressed("menu"):
		if mouse_hidden == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_hidden = false
		elif mouse_hidden == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		sprint_check()
		fall.y += speed
		
	if Input.is_action_pressed("LMB"):
		if equipped == "Nothing":
			pass
		elif equipped == "Knife":
			knife_stab()
	
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
	hud.equipped = equipped
	hud.powerups = powerups
	
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

#players powerup sound
func bingo():
	$Bingo.play()

#determines powerup effect
func use_powerup():
	print(equipped)
	if String(equipped) == "Nothing":
		print("Nothing in hand, major stamina + health gained")
		stamina += 30
		health += 30
	elif String(equipped) == "Knife":
		print("Knife in hand, major stamina, minor health and 1 second attack boost gained")
		stamina += 30
		health +=20
		knife_damage = 20
		$KnifePowerupTimer.start()
#will toggle weapon, will add additional weapons and overhaul this
func switch_equipment():
	if equipped == "Nothing":
		equipped = weapons[1]
		knife.visible = true
	elif equipped == "Knife":
		knife.visible = false
		equipped = weapons[2]
	
	#will be changed
func handle_death():
	if health < 0:
		get_tree().change_scene("res://Levels/TestWorld.tscn")

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

func take_damage(incoming_damage):
	if hurt == false:
		$OofTimer.start()
		$Oof.play()
		hurt = true
	health -= incoming_damage

#weapon functions
func knife_stab():
	if LMB_cooldown == false:
		if stamina > 0:
			LMB_cooldown = true
			$StabTimer.start()
			anim.play("Stab")
			$StabSound.play()
			stamina -= 5
			for body in StabZone.get_overlapping_bodies():
				if body.is_in_group('Enemy'):
					body.take_damage(knife_damage)
				if body.is_in_group('Destructible'):
					body.take_damage(knife_damage)
	

func _on_StatusTick_timeout():
	status_tick = true


func _on_StabZone_body_entered(body):
	if body.is_in_group("Enemy"):
		print('Stabbable Target!')
		print("Name: " + String(body.Name) + " Health: " + String(body.health))


func _on_StabTimer_timeout():
	LMB_cooldown = false


func _on_OofTimer_timeout():
	hurt = false


func _on_KnifePowerupTimer_timeout():
	knife_damage = 10
