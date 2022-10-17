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
var ammo_in_gun = 0
var sprint = false
var exertion = false #for checking sprint stamina drain
var hurt = false #ticks for hurt sound and possibly stuns?


var LMB_cooldown = false #when true, cannot attack with left click


#weapon values
var knife_damage = 10
var gun_damage = 30
var fairy_damage = 40

var dashing = false

#inventory stuff
var inv_weapons = []
var powerups = 1

var mouse_hidden = true
var mouse_sensitivity = 0.05

var weapons = ["Handgun", "Knife", "Nothing", "Fairy Wand"]
var equipped = ["Nothing"]

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()

onready var head = $Head
onready var hud = $Head/Camera/HUD
onready var knife = $Head/Camera/EquipNode/Knife
onready var anim = $Head/Camera/EquipNode/AnimationPlayer
onready var StabZone = $Head/Camera/EquipNode/StabZone
onready var wand = $Head/Camera/EquipNode/FairyWand
onready var handgun = $Head/Camera/EquipNode/PistolRight

onready var crunch = $Cronch

onready var interact_range = $Head/Camera/InteractPoint
onready var gun_range = $Head/Camera/GunRayCast
onready var AoE = $Head/Camera/EquipNode/AoE_area

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
			bingo()
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
	interact_raycast()
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
		elif equipped == "Fairy Wand":
			wand_aoe()
		elif equipped == "Handgun":
			shoot()
	
	if Input.is_action_pressed("RMB"):
		if equipped == "Nothing":
			pass 
		elif equipped == "Knife":
			pass
		elif equipped == "Fairy Wand":
			wand_dash()
		elif equipped == "Handgun":
			reload()
	
	if Input.is_action_just_released("RMB"):
		dashing = false
		anim.play("IdleReturn")
	
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


#Interactable objects must have use() function
func interact_raycast():
	if interact_range.is_colliding():
		var object = interact_range.get_collider()
		#print(object)
		if object.is_in_group("Interactable"):
			hud.see_e()
			if Input.is_action_pressed("interact"):
				object.use()
		else:
			hud.unsee_e()
	else:
		hud.unsee_e()
		


func update_hud():
	hud.health = health
	hud.stamina = stamina
	hud.ammo = ammo
	hud.ammo2 = ammo_in_gun
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
		stamina += 20
		health +=20
		knife_damage = 20
		$KnifePowerupTimer.start()
	elif String(equipped) == "Fairy Wand":
		print("Fairy wand in hand, huge stamina increase")
		stamina += 60
	elif String(equipped) == "Handgun":
		print("Granted more ammo")
		ammo += 12
	else:
		stamina += 30
		health += 30
#will toggle weapon, will add additional weapons and overhaul this
#0 = handgun 1 = knife 2 = nothing 3 = fairy wand
func switch_equipment():
	if equipped == weapons[2]:
		equipped = weapons[3]
		wand.visible = true
	elif equipped == weapons[3]:
		equipped = weapons[0]
		wand.visible = false
		handgun.visible = true
	elif equipped == weapons[0]:
		equipped = weapons[1]
		handgun.visible = false
		knife.visible = true
	elif equipped == weapons[1]:
		equipped = weapons [2]
		knife.visible = false
	print(equipped)
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

func wand_aoe():
	if LMB_cooldown == false:
		LMB_cooldown = true
		$AoETimer.start()
		anim.play("AoESpell")
		stamina -= 50
		if stamina < 0:
			take_damage(-stamina)

func wand_dash():
	dashing = true
	anim.play("FairyDash")

func shoot():
	anim.play("Shoot")

func reload():
	anim.play("Reload")

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


func _on_AoE_area_body_entered(body):
		if body.is_in_group("Enemy"):
			print('AoE')


func _on_AoETimer_timeout():
	LMB_cooldown = false
	for body in AoE.get_overlapping_bodies():
		if body.is_in_group('Enemy'):
			body.take_damage(fairy_damage)
		if body.is_in_group('Destructible'):
			body.take_damage(fairy_damage)
