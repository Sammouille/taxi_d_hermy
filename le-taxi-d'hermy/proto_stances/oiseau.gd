extends Animal
class_name Oiseau

@export var vitesse := 1000.0
@export var vitesse_planage:= 800.0
@export var puissance_saut:= 700.0
@export var max_battements:= 3
var index_battement:= 0
@export var puissance_battements:= 500.0
@export var planage: Curve
var index_planage:= 0.0

func prendreMouvements(delta: float, velocite: Vector2, on_floor: bool, _mur: int) -> Array[Vector2]:
	var forces : Array[Vector2] = []
	var input_axis := prendreAxeInput()
	
	if on_floor:
		if index_planage:
			index_planage = 0.0
		if velocite.length():
			forces.append(-velocite * frottements_sol * delta)
		if Input.is_action_pressed("saut") and input_axis.y < 0:
			forces.append(input_axis.normalized() * puissance_saut)
		elif input_axis.x:
			forces.append(Vector2(input_axis.x * vitesse * delta, 0.0))
		
	elif Input.is_action_pressed("saut"):
		if index_planage > planage.max_domain and index_battement < max_battements:
			index_planage = 0.0
			forces.append(Vector2(0.0, puissance_battements))
			index_battement += 1
		elif index_planage < planage.max_domain:
			forces.append(Vector2(0.0, gravite * delta * masse * masse * (1.0 - planage.sample(index_planage))))
		else :
			forces.append(Vector2(0.0, gravite * delta * masse * masse))
		index_planage += delta
		
	else: 
		forces.append(Vector2(0.0, gravite * delta * masse * masse))
		if input_axis.x:
			forces.append(Vector2(input_axis.x * vitesse * delta, 0.0))
	return forces
