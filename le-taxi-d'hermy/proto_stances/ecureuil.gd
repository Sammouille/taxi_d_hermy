extends Animal
class_name Ecureuil

@export var vitesse:= 1000.0
@export var puissance_saut:= 1000.0
@export var puissance_mursaut:= 800.0
@export var accroche: Curve
@export var puissance_ejection:= 200.0
var index_accroche:= 0.0

var input_axis:= Vector2.ZERO

var saute:= false

func prendreInput(_event: InputEvent, actif:= true):
	if actif:
		var _input: Vector2
		_input.x = Input.get_axis("gauche","merde")
		_input.y = Input.get_axis("haut","bas")
		input_axis = _input
		if Input.is_action_just_pressed("saut"):
			saute = true
			return true
	else :
		input_axis = Vector2.ZERO
		saute = false

func prendreMouvements(delta: float, velocite: Vector2, on_floor: bool, mur: int) -> Array[Vector2]:
	var forces : Array[Vector2] = []
	
	if on_floor:
		if index_accroche:
			index_accroche = 0.0
		if velocite.length():
			forces.append(-velocite * frottements_sol * delta)
		if saute and input_axis.y < 0:
			saute = false
			forces.append(input_axis.normalized() * puissance_saut)
		elif input_axis.x:
			forces.append(Vector2(input_axis.x * vitesse * delta, 0.0))
		
	elif mur == 1:
		if input_axis.x < 0.0:
			var accroche_max = accroche.max_domain
			if index_accroche <= accroche_max:
				forces.append(Vector2(0.0, gravite * delta * masse * masse * (1.0 - accroche.sample(index_accroche))))
			else :
				forces.append(Vector2(puissance_ejection, gravite * delta * masse * masse))
			index_accroche += delta
			
		elif saute and input_axis.x > 0.0:
			forces.append(Vector2(puissance_mursaut,-puissance_mursaut))
			saute = false
		else :
			if velocite.length():
				forces.append(-velocite * frottements_aerien * delta)
			forces.append(Vector2(0.0, gravite * delta * masse * masse))
	elif mur == 2:
		if input_axis.x > 0.0:
			var accroche_max = accroche.max_domain
			if index_accroche <= accroche_max:
				forces.append(Vector2(0.0, gravite * delta * masse * masse * (1.0 - accroche.sample(index_accroche))))
			else :
				forces.append(Vector2(-puissance_ejection, gravite * delta * masse * masse))
			index_accroche += delta
			
		elif saute and input_axis.x < 0.0:
			saute = false
			forces.append(Vector2(-puissance_mursaut,-puissance_mursaut))
		else :
			if velocite.length():
				forces.append(-velocite * frottements_aerien * delta)
			forces.append(Vector2(0.0, gravite * delta * masse * masse))
	else:
		if index_accroche:
			index_accroche = 0.0
		if velocite.length():
			forces.append(-velocite * frottements_aerien * delta)
		forces.append(Vector2(0.0, gravite * delta * masse * masse))
	
	return forces
