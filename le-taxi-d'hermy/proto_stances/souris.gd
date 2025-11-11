extends Animal
class_name Souris

@export var vitesse:= 1500.0

var input_axis:= Vector2.ZERO

func prendreInput(_event: InputEvent, actif:= true):
	if actif:
		var _input: Vector2
		_input.x = Input.get_axis("gauche","merde")
		_input.y = Input.get_axis("haut","bas")
		input_axis = _input

func prendreMouvements(delta: float, velocite: Vector2, on_floor: bool, _mur: int) -> Array[Vector2]:
	var forces : Array[Vector2] = []
	
	if !on_floor:
		
		if velocite.length():
			forces.append(-velocite * frottements_aerien * delta)
		forces.append(Vector2(0.0, gravite * delta * masse * masse))
	
	else:
		if velocite.length():
			forces.append(-velocite * frottements_sol * delta)
		if input_axis.x:
			forces.append(Vector2(input_axis.x * vitesse * delta, 0.0))
	
	return forces
