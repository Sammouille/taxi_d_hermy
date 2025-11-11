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

var plane:= false


func prendreMouvements(delta: float, velocite: Vector2, on_floor: bool, _mur: int) -> Array[Vector2]:
	var forces : Array[Vector2] = []
	var input_axis := prendreAxeInput()
	
	if on_floor:
		if index_planage:
			index_planage = 0.0
		if index_battement:
			index_battement = 0
		if plane:
			plane = false
		if velocite.length():
			forces.append(-velocite * frottements_sol * delta)
		if Input.is_action_pressed("saut"):
			forces.append(Vector2(0.0, -puissance_saut))
			plane = true
		elif input_axis.x:
			forces.append(Vector2(input_axis.x * vitesse * delta, 0.0))
	
	
	elif Input.is_action_pressed("saut"):
		if input_axis.x:
			forces.append(Vector2(input_axis.x * vitesse_planage * delta, 0.0))
			
		if !plane and index_battement <= max_battements:
			print(index_battement)
			plane = true
			index_planage = 0.0
			index_battement += 1
			forces.append(Vector2(0.0, -puissance_battements))
		
		elif index_planage <= planage.max_domain:
			print(index_planage)
			forces.append(Vector2(0.0, gravite * delta * masse * masse * (1.0 - planage.sample(index_planage))))
			index_planage += delta
		
		else :
			forces.append(Vector2(0.0, gravite * delta * masse * masse))
			plane = false
		
	
	
	else: 
		if plane:
			plane = false
		forces.append(Vector2(0.0, gravite * delta * masse * masse))
		
		if input_axis.x:
			forces.append(Vector2(input_axis.x * vitesse_planage * delta, 0.0))
	return forces
