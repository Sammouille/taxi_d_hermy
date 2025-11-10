extends Animal
class_name Souris

@export var vitesse:= 1500.0

func prendreMouvements(delta: float, velocite: Vector2, on_floor: bool, _mur: int) -> Array[Vector2]:
	var forces : Array[Vector2] = []
	
	if !on_floor:
		
		if velocite.length():
			forces.append(-velocite * frottements_aerien * delta)
		forces.append(Vector2(0.0, gravite * delta * masse * masse))
	
	else:
		if velocite.length():
			forces.append(-velocite * frottements_sol * delta)
		var input_axis := prendreAxeInput()
		if input_axis.x:
			forces.append(Vector2(input_axis.x * vitesse * delta, 0.0))
	
	return forces
