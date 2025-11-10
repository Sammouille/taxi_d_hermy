extends Animal
class_name Ecureuil

@export var vitesse:= 1000.0
@export var puissance_saut:= 1000.0
@export var puissance_mursaut:= 800.0
@export var accroche: Curve
@export var puissance_ejection:= 200.0
var index_accroche:= 0.0

func prendreMouvements(delta: float, velocite: Vector2, on_floor: bool, mur: int) -> Array[Vector2]:
	var forces : Array[Vector2] = []
	var input_axis := prendreAxeInput()
	
	if on_floor:
		if index_accroche:
			index_accroche = 0.0
		if velocite.length():
			forces.append(-velocite * frottements_sol * delta)
		if Input.is_action_pressed("saut") and input_axis.y < 0:
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
			
		elif Input.is_action_pressed("saut") and input_axis.x > 0.5:
			forces.append(input_axis.normalized() * puissance_mursaut)
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
			
		elif Input.is_action_pressed("saut") and input_axis.x :
			forces.append(input_axis.normalized() * puissance_mursaut)
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
