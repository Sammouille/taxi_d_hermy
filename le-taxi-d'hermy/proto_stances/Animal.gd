@abstract
extends Resource
class_name Animal

@export var name : String
@export_category("Physique")
@export var vitesse:= 1500.0
@export var puissance_saut:= 1000.0
@export var frottements_sol:= 10.0
@export var frottements_aerien:= 1.0
@export var masse:= 2.0:
	set(value):
		masse = value
		inv_masse = 1.0/value
var inv_masse := 1.0

@export_category("Visuel")
@export var sprite: Texture
@export var collision_shape: Shape2D

var gravite:= 1.0
var saute:= false

var sm : StateMachine
var input_axis:= Vector2.ZERO

func setup(_gravite):
	gravite = _gravite
	preparationAnimale()

func preparationAnimale():
	sm = StateMachineAnimal.new()
	sm.setup()


func prendreMouvements(delta: float, velocite: Vector2, on_floor: bool, mur: int) -> Array[Vector2]:
	sm.machine_logic(delta, velocite, on_floor, mur)
	
	var forces : Array[Vector2] = []
	
	match sm.etat :
		[sm.etats.saute, sm.etats.tombe]:
			# Frottements fluides
			if velocite.length():
				forces.append(-velocite * frottements_aerien * delta)
			# Gravité
			forces.append(Vector2(0.0, gravite * delta * masse * masse))
		[sm.etats.attend, sm.etats.marche]:
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
				forces.append(input_axis.normalized() * puissance_saut)
	
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
