extends Animal
class_name Oiseau


@export var vitesse_planage:= 800.0
@export var max_battements:= 3
var index_battement:= 0
@export var puissance_battements:= 500.0
@export var planage: Curve
var index_planage:= 0.0
@export var force_planage:= 400.0

var plane:= false

@export var battement_directionnel:= false

func mouvementTerrestre(delta: float, velocite: Vector2):
	if index_battement != 0:
		index_battement = 0
	if index_planage != 0:
		index_planage = 0.0
	return super(delta, velocite)

func mouvementAerien(delta: float, velocite: Vector2):
	var forces : Array[Vector2] = []
	# Frottements fluides
	if velocite.length():
		forces.append(-velocite * frottements_aerien * delta)
	# Gravité
	forces.append(Vector2(0.0, gravite * delta * masse * masse))
	if input_axis.y > 0.0:
		forces.append(Vector2(0.0, fast_fall * delta * input_axis.y))
	
	if plane or saute:
		# Input Déplacement
		if input_axis.x:
			forces.append(Vector2(input_axis.x * vitesse_planage * delta, 0.0))
		# Input Saut
		if saute:
			if index_battement < max_battements:
				index_battement += 1
				index_planage = 0.0
				saute = false
				# Si le saut est directionnel on lui donne l'axe de l'input
				if battement_directionnel:
					forces.append(input_axis.normalized() * puissance_battements)
				# Sinon on lui donne simplement une force verticale
				else:
					forces.append(Vector2.UP * puissance_battements)
		elif plane:
			if index_planage <= planage.get_domain_range():
				forces.append(Vector2.UP * force_planage * planage.sample(index_planage))
				index_planage += delta
				
	
	return forces

func prendreInput(_event: InputEvent, actif:= true):
	if actif:
		var _input: Vector2
		_input.x = Input.get_axis("gauche","merde")
		_input.y = Input.get_axis("haut","bas")
		input_axis = _input
		
		if Input.is_action_just_pressed("saut"):
			saute = true
			plane = true
			return true
		elif Input.is_action_just_released("saut"):
			plane = false
	else :
		input_axis = Vector2.ZERO
		saute = false
