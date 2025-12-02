extends CharacterBody2D

@export var animaux : Array[Animal]
var active_animal : Animal 
var index_animal:= 0

@export var sifflet := true

@export var menu : Node2D
@export var bag_menu : Node2D
var tab_base_animaux : Array[Animal]
var scene_animal_pas_joue:= preload("res://proto_stances/animal_pas_joue.tscn")

var vitesse:= 8.0
var frottements:= 0.1
var masse:= 1.0
var inv_masse := 1.0

var velocite:= Vector2.ZERO
var acceleration:= Vector2.ZERO

var gravite: float

var va_passer:= false

var banc_interactif 
#signal bag_menu_opened(tab_team,tab_bench)

func _ready() -> void:
	gravite = get_tree().root.get_child(2).gravite
	transformationAnimale()
	menu.confirm_ordre.connect(magieReconstructiveMenu.bind())
	
	tab_base_animaux = animaux.duplicate()
	print(animaux," alors ", tab_base_animaux)
	for i in get_tree().get_nodes_in_group("bench"):
		i.sitting.connect(gestionBanc.bind())
	bag_menu.fin_menu_sac.connect(gestionFinBanc.bind())

func lacherAnimal(index: int):
	if sifflet:
		var animal_lache:= scene_animal_pas_joue.instantiate()
		animal_lache.animal = animaux[index]
		%BoiteAnimaux.add_child(animal_lache)
		animal_lache.global_position = global_position
		
		animaux.remove_at(index)

func transformationAnimale(suite:= 0):
	print(index_animal)
	var ancien_index = index_animal
	index_animal += suite
	if index_animal >= animaux.size():
		index_animal -= animaux.size()
	elif index_animal < 0:
		index_animal += animaux.size()
		
	active_animal = animaux[index_animal]
	if suite != 0 and va_passer:
		va_passer = false
		lacherAnimal(ancien_index)
		index_animal = animaux.find(active_animal)
	
	active_animal.setup(gravite)
	masse = active_animal.masse
	inv_masse = active_animal.inv_masse
	$Sprite2D.texture = active_animal.sprite
	$CollisionShape2D.shape = active_animal.collision_shape

func prendreAxeInput() -> Vector2:
	var _input: Vector2
	_input.x = Input.get_axis("gauche","merde")
	_input.y = Input.get_axis("haut","bas")
	return _input

func appliquerForce(force: Vector2):
	acceleration += force * inv_masse

func magieDeMarche():
	velocite += acceleration
	acceleration *= 0.0
	velocity = velocite
	if move_and_slide():
		velocite = velocity

func recupereAnimal():
	if sifflet:
		var index_proche:= -1
		var plus_proche:= -1
		var i:= 0
		for animal in %BoiteAnimaux.get_children():
			if animal is CharacterBody2D and animal.animal:
				print((animal.position - position).length())
				if plus_proche == -1:
					index_proche = i
					plus_proche = (animal.position - position).length()
				elif (animal.position - position).length() < plus_proche:
					index_proche = i
					plus_proche = (animal.position - position).length()
				i += 1
		if index_proche != -1:
			animaux.append(%BoiteAnimaux.get_children()[index_proche].animal)
			%BoiteAnimaux.get_children()[index_proche].queue_free()

func recupereAnimaux():
	if sifflet :
		animaux = tab_base_animaux
		print(animaux)
		for i in %BoiteAnimaux.get_children().size():
			print("FEUR " , i, " animaux : ", %BoiteAnimaux.get_children()[i])
			%BoiteAnimaux.get_children()[i].queue_free()
		
func _unhandled_input(event: InputEvent) -> void:
	if active_animal.prendreInput(event):
		va_passer = true
	if Input.is_action_just_pressed("switch_apres"):
		if animaux.size() > 1:
			transformationAnimale(1)
	elif Input.is_action_just_pressed("switch_avant"):
		if animaux.size() > 1:
			transformationAnimale(-1)
	elif Input.is_action_just_pressed("sifflet") and is_on_floor():
		#recupereAnimal()
		recupereAnimaux()
	
	if Input.is_action_pressed("grossir"):
		scale *= 1.1
		print(scale)
	elif Input.is_action_pressed("reduire"):
		scale *= 0.9
		print(scale)
	if event.is_action_pressed("debug"):
		for i in animaux :
			print("test resource ", i.name)

func _physics_process(delta: float) -> void:
	var mur:= 0
	if is_on_wall():
		if (get_last_slide_collision().get_position() - global_position).x < 0.0:
			mur = 1
		else:
			mur = 2
	for force in active_animal.prendreMouvements(delta, velocite, is_on_floor(), mur):
		appliquerForce(force)
	magieDeMarche()

func gestionBanc(anim_banc,banc):
	if animaux == tab_base_animaux :
		var mini_tab : Array[Animal]
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		var tween = get_tree().create_tween()
		tween.tween_property(bag_menu,"modulate:a",1.0,0.3)
		bag_menu.btn_show()
		banc_interactif = banc
		for i in animaux:
			if i.name != "hermy":
				mini_tab.append(i)
				
		bag_menu.chefdOrganisation(mini_tab,anim_banc)
		#bag_menu_opened.emit(mini_tab,anim_banc)
	
func gestionFinBanc(tab_anim,tab_banc):
	var tween = get_tree().create_tween()
	tween.tween_property(bag_menu,"modulate:a",0.0,0.3)
	bag_menu.btn_hide()
	magieReconstructiveMenu(tab_anim)
	banc_interactif.animaux_bench = tab_banc.duplicate()
	banc_interactif = null
	
func magieReconstructiveMenu(ordre):
	var hermy = null
	for i in animaux :
		if i.name == "hermy": 
			hermy = i
	var temp_tab = ordre.duplicate()
	tab_base_animaux = ordre.duplicate()
	animaux.clear()
	animaux.push_front(hermy)
	for i in temp_tab :
		if i != null:
			animaux.append(i)
	tab_base_animaux = animaux.duplicate()
