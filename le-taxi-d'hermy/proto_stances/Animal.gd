@abstract
extends Resource
class_name Animal

@export var name : String
@export_category("Physique")
@export var vitesse:= 1500.0
@export var puissance_saut:= 1000.0
@export var saut_directionnel:= true
@export var frottements_sol:= 10.0
@export var frottements_aerien:= 1.0
@export var masse:= 2.0:
	set(value):
		masse = value
		inv_masse = 1.0/value
var inv_masse := 1.0
@export var fast_fall:= 1.0

@export_category("Visuel")
@export var sprite: Texture
@export var collision_shape: Shape2D

var gravite:= 4.0
var saute:= false

var sm : StateMachine
var input_axis:= Vector2.ZERO

func setup(_gravite):
	gravite = _gravite
	preparationAnimale()

func preparationAnimale():
	sm = StateMachineAnimal.new()
	sm.setup()


func mouvementTerrestre(delta: float, velocite: Vector2):
	var forces : Array[Vector2] = []
	# Frottements statiques et fluides
	if velocite.length():
		forces.append(-velocite * frottements_sol * delta)
		forces.append(-velocite * frottements_aerien * delta)
	# Input Déplacement
	if input_axis.x:
		forces.append(Vector2(input_axis.x * vitesse * delta, 0.0))
	# Input Saut
	if saute:
		saute = false
		# Si le saut est directionnel on lui donne l'axe de l'input
		if saut_directionnel:
			forces.append(input_axis.normalized() * puissance_saut)
		# Sinon on lui donne simplement une force verticale
		else:
			forces.append(Vector2.UP * puissance_saut)
	
	return forces

func mouvementAerien(delta: float, velocite: Vector2):
	if saute:
		saute = false
	var forces : Array[Vector2] = []
	# Frottements fluides
	if velocite.length():
		forces.append(-velocite * frottements_aerien * delta)
	# Gravité
	forces.append(Vector2(0.0, gravite * delta * masse * masse))
	if input_axis.y > 0.0:
		forces.append(Vector2(0.0, fast_fall * delta * input_axis.y))
	
	return forces

func prendreMouvements(delta: float, velocite: Vector2, on_floor: bool, mur: int) -> Array[Vector2]:
	sm.machine_logic(delta, velocite, on_floor, mur, input_axis)
	
	print(sm.etats.find_key(sm.etat))
	print(name)
	
	var forces : Array[Vector2] = []
	
	match sm.etat :
		sm.etats.tombe:
			forces.append_array(mouvementAerien(delta, velocite))
		sm.etats.saute:
			forces.append_array(mouvementAerien(delta, velocite))
		
		sm.etats.attend:
			forces.append_array(mouvementTerrestre(delta, velocite))
		sm.etats.marche:
			forces.append_array(mouvementTerrestre(delta, velocite))
	
	return forces


func prendreInput(_event: InputEvent, actif:= true):
	if actif:
		var _input: Vector2
		_input.x = Input.get_axis("gauche","merde")
		_input.y = Input.get_axis("haut","bas")
		input_axis = _input
		if Input.is_action_just_pressed("saut"):
			saute = true
			# A partir du moment où l'animal saute il sera laché au prochain switch
			return true
	else :
		input_axis = Vector2.ZERO
		saute = false
