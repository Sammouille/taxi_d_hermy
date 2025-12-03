@abstract
extends Resource
class_name Animal


@export var vitesse:= 1500.0
@export var puissance_saut:= 1000.0
@export var name : String
@export var frottements_sol:= 10.0
@export var frottements_aerien:= 1.0
@export var masse:= 2.0:
	set(value):
		masse = value
		inv_masse = 1.0/value
var inv_masse := 1.0

@export var sprite: Texture
@export var collision_shape: Shape2D

var gravite:= 1.0
var saute:= false

var input_axis:= Vector2.ZERO

func setup(_gravite):
	gravite = _gravite
	preparationAnimale()

func preparationAnimale():
	pass


func prendreMouvements(delta: float, velocite: Vector2, on_floor: bool, _mur: int) -> Array[Vector2]:
	var forces : Array[Vector2] = []
	
	if !on_floor:
		# Frottements fluides
		if velocite.length():
			forces.append(-velocite * frottements_aerien * delta)
		# Gravité
		forces.append(Vector2(0.0, gravite * delta * masse * masse))
	
	else:
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
