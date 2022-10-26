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
var ammo = 0 
var ammo_in_gun = 0

var status = false


var loaded = true
var mag_size = 12


var sprint = false
var exertion = false #for checking sprint stamina drain
var hurt = false #ticks for hurt sound and possibly stuns?
var dead = false

var disease = false #checked for flesh damage and checked briefly afterwards
var immunity = 20 #out of 100, subtracted from random integers to check infection

var rng = RandomNumberGenerator.new()

var LMB_cooldown = false #when true, cannot attack with left click
var RMB_cooldown = false #when true keeps actions like reloading from stuttering


#weapon values
var knife_damage = 10
var gun_damage = 30
var fairy_damage = 40

var dashing = false

#inventory stuff
var inv_weapons = []
var powerups = 5

#inventory swapping variables
var id = 2
var startid = 3
var item = 0
var command = 0
var swap_equip = false


var examine_text = "Generic Examine"
var dialogue_text = "GenericDialogue"
var status_text = 'GenericStatus'
var interact_cooldown = false

var mouse_hidden = true
var mouse_sensitivity = 0.05

var weapons = ["Handgun", "Knife", "Nothing", "Fairy Wand"]
var equipped = ["Nothing"]

var status_effects = []
var vaccinated = false
var serum_overdose = false
var keycard = false
var dimensional_keys = 0
var hungry = true

#npc relation
var Murders = 0
var blungus_friend = true
var fairy_friend = true
var fairy_quest_failed = false
var fairy_quest_succeeded = false
var goblin_spared = true


signal gunshot #for starting gas fires
var muzzle_coords = Vector3()

var current_level = 0

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()

onready var micro_image = $Head/Camera/MicroscopeImage

onready var head = $Head
onready var hud = $Head/Camera/HUD
onready var knife = $Head/Camera/EquipNode/Knife
onready var anim = $Head/Camera/EquipNode/AnimationPlayer
onready var StabZone = $Head/Camera/EquipNode/StabZone
onready var wand = $Head/Camera/EquipNode/FairyWand
onready var handgun = $Head/Camera/EquipNode/PistolRight

onready var OD = $ODTimer
onready var crunch = $Cronch

onready var interact_range = $Head/Camera/InteractPoint
onready var gun_range = $Head/Camera/GunRayCast
onready var AoE = $Head/Camera/EquipNode/AoE_area

onready var muzzle_explode = preload("res://Effects/GasFirespread.tscn")
# Called when the node enters the scene tree for the first time.

#screen position stuff
var screen_size = OS.get_screen_size()
var window_size = OS.get_window_size()


func _ready():
	current_level = get_parent().current_level
	hud.allow_save() #toggles saving button from menu
	GameManager.current_level = current_level #tells GameManager directory for current level
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	get_start_stats() #grabs starting stats from GameManager
	hud.undie()
	$Head/FluDeath.visible = false
	inv_weapons.append(weapons[2])
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	equipped = weapons[2]
	#print(equipped)

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

func get_start_stats():
	powerups = GameManager.powerups
	inv_weapons = GameManager.unlocked_weapons
	health = GameManager.health
	stamina = GameManager.stamina
	disease = GameManager.disease
	vaccinated = GameManager.vaccinated
	immunity = GameManager.immunity
	serum_overdose = GameManager.serum_overdose
	ammo = GameManager.ammo
	ammo_in_gun = GameManager.ammo_in_gun
	Murders = GameManager.Murders
	keycard = GameManager.keycard
	dimensional_keys = GameManager.dimensional_keys
	
	blungus_friend = GameManager.blungus_friend
	fairy_friend = GameManager.fairy_friend
	fairy_quest_failed = GameManager.fairy_friend
	fairy_quest_succeeded = GameManager.fairy_quest_succeeded
	goblin_spared = GameManager.goblin_spared

func update_stats_GM():
	GameManager.powerups = powerups
	GameManager.unlocked_weapons = inv_weapons
	GameManager.health = health
	GameManager.stamina = stamina
	GameManager.disease = disease
	GameManager.vaccinated = vaccinated
	GameManager.immunity = immunity
	GameManager.serum_overdose = serum_overdose
	GameManager.ammo = ammo
	GameManager.ammo_in_gun = ammo_in_gun
	GameManager.Murders = Murders
	GameManager.keycard = keycard
	GameManager.dimensional_keys = dimensional_keys
	
	GameManager.blungus_friend = blungus_friend
	GameManager.fairy_friend = fairy_friend
	GameManager.fairy_quest_failed = fairy_quest_failed
	GameManager.fairy_quest_succeeded = fairy_quest_succeeded
	GameManager.goblin_spared = goblin_spared

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
		if LMB_cooldown == false:
			#older, known to be functional
			#switch_equipment()
			swap_equipment()
			anim.play("IdleReturn")
	
	if Input.is_action_just_pressed("menu"):
		if mouse_hidden == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_hidden = false
			hud.menu_toggle = true
			hud.menu_visible()
		elif mouse_hidden == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_hidden = true
			hud.menu_toggle = false
			hud.menu_visible()
	if Input.is_action_pressed("jump") and is_on_floor():
		if dead == false:
			sprint_check()
			fall.y += speed
		
	if Input.is_action_pressed("LMB"):
		if dead == false:
			if equipped == "Nothing":
				pass
			elif equipped == "Knife":
				knife_stab()
			elif equipped == "Fairy Wand":
				wand_aoe()
			elif equipped == "Handgun":
				shoot()
	
	if Input.is_action_pressed("RMB"):
		if dead == false:
			if equipped == "Nothing":
				pass 
			elif equipped == "Knife":
				pass
			elif equipped == "Fairy Wand":
				wand_dash()
			elif equipped == "Handgun":
				reload()
	if Input.is_action_just_released("RMB"):
		if dead == false:
			dashing = false
			if equipped == 'Fairy Wand':
				anim.play("IdleReturn")


	if Input.is_action_pressed("forward"):
		if dead == false:
			direction -= transform.basis.z
			sprint_check()
	elif Input.is_action_pressed("backward"):
		if dead == false:
			direction += transform.basis.z
			sprint_check()
	if Input.is_action_pressed("left"):
		if dead == false:
			direction -= transform.basis.x
			sprint_check()
	elif Input.is_action_pressed("right"):
		if dead == false:
			direction += transform.basis.x
			sprint_check()
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)


#Interactable objects must have use() function
func interact_raycast():
	if interact_range.is_colliding():
		var object = interact_range.get_collider()
		var active_interactor = false
		#print(object)
		if object.is_in_group("Interactable"):
			if object.active == true:
				active_interactor = true
			elif object.active == false:
				active_interactor = false
			if active_interactor == true:
				examine_text = object.Name
				hud.see_e()
				if Input.is_action_pressed("interact"):
					if interact_cooldown == false:
						object.use()
						interact_cooldown = true
						$E_cooldown.start()
		else:
			hud.unsee_e()
	else:
		hud.unsee_e()
		


func update_hud():
	hud.examine_text = examine_text
	hud.dialogue_text = dialogue_text
	hud.health = health
	hud.stamina = stamina
	hud.ammo = ammo
	hud.ammo2 = ammo_in_gun
	hud.status = status
	hud.sprint = sprint
	hud.equipped = equipped
	hud.powerups = powerups
	hud.status_text = status_text

func tick_dialogue():
	hud.dialogue()

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
func PickupSound():
	$PickupSound.play()

#determines powerup effect
func use_powerup():
	print(equipped)
	if String(equipped) == "Nothing":
		print("Nothing in hand, major stamina + health gained")
		stamina += 30
		health += 30
		disease = false
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
		equipped = weapons[2]
		knife.visible = false
	print(equipped)
	#will be changed


#leaving old switch_equipment in just in case new version breaks

#	var id = 2
#	var startid = 3
#startid is the weapon id that is currently being searched for in the forloop
#	var item = 0
#	var command = equip_nothing()
#	var swap_equip = true
func swap_equipment():
	#print(String(equipped))
	swap_equip = true
	if equipped == "Nothing":
		startid = 3
	elif equipped == "Fairy Wand":
		startid = 0
	elif equipped == "Handgun":
		startid = 1
	elif equipped == "Knife":
		startid = 2
	#print(startid)
	set_equip_id()
	swap_loop()
	if swap_equip == true:
		swap_shift()
		swap_loop()
		#print('1st loop complete')
	if swap_equip == true:
		swap_shift()
		swap_loop()
	if swap_equip == true:
		swap_shift()
		swap_loop()
	if swap_equip == true:
		swap_equip = false


func swap_loop():
	for n in inv_weapons:
		if swap_equip == true:
			if n == item:
				command
				swap_equip = false
				weapon_chooser()
func swap_shift():
	startid +=1
	if startid == 4:
		startid = 0
	set_equip_id()
	
	#setting functions to variables doesn't work apparently
func set_equip_id():
	var current_loadout = equipped
	if startid == 3:
		item = weapons[3]
		command = equip_wand()
		#print(command)
	elif startid == 2:
		item = weapons[2]
		command = equip_nothing()
	elif startid == 1:
		item = weapons[1]
		command = equip_knife()
	elif startid == 0:
		item = weapons[0]
		command = equip_gun()
	equipped = current_loadout
	if equipped == "Nothing":
		equip_nothing()
	elif equipped == "Handgun":
		equip_gun()
	elif equipped == "Fairy Wand":
		equip_wand()
	elif equipped == "Knife":
		equip_knife()
func equip_gun():
	equipped = weapons[0]
	hide_weapons()
	handgun.visible = true
func equip_knife():
	equipped = weapons[1]
	hide_weapons()
	knife.visible = true
func equip_nothing():
	equipped = weapons[2]
	hide_weapons()
func equip_wand():
	equipped = weapons[3]
	hide_weapons()
	wand.visible = true
func hide_weapons():
	handgun.visible = false
	knife.visible = false
	wand.visible = false

func weapon_chooser():
	if item == "Nothing":
		equip_nothing()
	if item == "Handgun":
		equip_gun()
	elif item == "Knife":
		equip_knife()
	elif item == "Fairy Wand":
		equip_wand()
	
	
func handle_death():
	if health < 0:
		if dead == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			dead = true
			$Head/Camera/EquipNode.visible = false
			status_text = "You are dead!"
			hud.status()
			hud.die()
			if disease == true:
				$Head/FluDeath.visible = true
				print('diseased death')
			powerups = 1
			stamina = 100
			health = 100
			ammo = 0 
			ammo_in_gun = 0
			vaccinated = false
			immunity = 20
			serum_overdose = false
			keycard = false
			dimensional_keys = 0
			hungry = true
			Murders = 0
			inv_weapons = []
			update_stats_GM()



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
	if dead == false:
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
	if LMB_cooldown == false:
		LMB_cooldown = true
		$BetweenShots.start()
		if ammo_in_gun > 0:
			ammo_in_gun -= 1
			anim.play("Shoot")
			muzzle_coords = $Head/Camera/EquipNode/PistolRight.global_transform.origin
			emit_signal("gunshot")
			if gun_range.is_colliding():
				var target = gun_range.get_collider()
				if target.is_in_group('Enemy'):
					target.take_damage(gun_damage)
				elif target.is_in_group("Destructible"):
					target.take_damage(gun_damage)
		elif ammo_in_gun == 0:
			$Click.play()

func muzzle_fire():
	var e = muzzle_explode.instance()
	$Head/Camera/EquipNode.add_child(e)
	

func reload():
	var ejected_mag = 0
	if RMB_cooldown == false:
		if ammo > 0:
			anim.play("Reload")
			LMB_cooldown = true
			RMB_cooldown = true
			if ammo_in_gun == 0:
				print('ejecting empty')
			elif ammo_in_gun > 0:
				ejected_mag = ammo_in_gun
				ammo += ejected_mag
				print('ejected mag' + String(ejected_mag))
				ammo_in_gun = 0
			loaded = false
			$ReloadTimer.start()

func infection_check():
	if disease == false:
		rng.randomize()
		var infection_roll = rng.randi_range(0, 100)
		print(infection_roll)
		var infection_calc = infection_roll - immunity
		print(infection_calc)
		if infection_calc < 0:
			disease = false
			print('Fought off infection')
		elif infection_calc >= 0:
			disease = true
			print('Infected!')
	elif disease == true:
		print('Already infected')
		#pass
		
func _on_StatusTick_timeout():
	status_tick = true


func _on_StabZone_body_entered(body):
	if body.is_in_group("Enemy"):
		#print('Stabbable Target!')
		print("Name: " + String(body.Name) + " Health: " + String(body.health))


func _on_StabTimer_timeout():
	LMB_cooldown = false


func _on_OofTimer_timeout():
	hurt = false


func _on_KnifePowerupTimer_timeout():
	knife_damage = 10


func _on_AoE_area_body_entered(body):
		if body.is_in_group("Enemy"):
			#print('AoE')
			pass


func _on_AoETimer_timeout():
	LMB_cooldown = false
	for body in AoE.get_overlapping_bodies():
		if body.is_in_group('Enemy'):
			body.take_damage(fairy_damage)
		if body.is_in_group('Destructible'):
			body.take_damage(fairy_damage)


func _on_BetweenShots_timeout():
	LMB_cooldown = false


func _on_ReloadTimer_timeout():
	var new_mag = 0
	if ammo < mag_size:
		new_mag = ammo
		ammo = 0
	elif ammo >= mag_size:
		new_mag = mag_size
		ammo -= mag_size
	ammo_in_gun += mag_size
	LMB_cooldown = false
	RMB_cooldown = false
	loaded = true
	#print('loaded')


func _on_E_cooldown_timeout():
	interact_cooldown = false


func _on_DiseaseTimer_timeout():
	if disease == true:
		if vaccinated == false:
			status_text = "You feel an an achey, pulsating chill in your flesh."
			hud.status()
			health -= 1
			if stamina_regen >= -1:
				stamina_regen -= 0.2
		elif vaccinated == true and serum_overdose == false:
			status_text = "You feel an light ache, and somewhat feverish."
			hud.status()
			health -= 0.5
			if stamina_regen >= -1:
				stamina_regen -= 0.05
		elif serum_overdose == true:
			status_text = "You feel incredibly feverish in addition the chills."
			hud.status()
			take_damage(15)
			stamina_regen = -3
	elif disease == false:
		stamina_regen = 1
		if serum_overdose == true:
			status_text = "You feel incredibly feverish, like you're burning up from the inside."
			hud.status()
			take_damage(10)
			stamina_regen = -2


func _on_ODTimer_timeout():
	serum_overdose = false
	print('Outlasted Overdose')
	if disease == true:
		status_text = "Your fever subsides, you feel awful, but the creeping chill is gone."
		disease = false
	elif disease == false:
		status_text = "Your fever subsides and you feel awful."
	hud.status()
	stamina_regen = 1


func _on_HUD_playerupdate():
	update_stats_GM()
