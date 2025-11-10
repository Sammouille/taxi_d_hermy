extends Animal
class_name Grenouille

@export var courbe_charge_saut : Curve
@export var puissance_max_saut := 1500
@export var duree_max_charge := 2.0:
	set(value):
		duree_max_charge = value
		inv_duree = 1.0/value
var inv_duree := 0.5
var charge_saut := 0.0
var index_charge := 0.0

func preparationAnimale():
	inv_duree = 1.0/duree_max_charge

func prendreMouvements(delta: float, velocite: Vector2, on_floor: bool, _mur: int) -> Array[Vector2]:
	var forces : Array[Vector2] = []
	
	if on_floor:
		if velocite.length():
			forces.append(-velocite * frottements_sol * delta)
		
		if Input.is_action_pressed("saut") and courbe_charge_saut:
			if index_charge < duree_max_charge:
				charge_saut = courbe_charge_saut.sample(index_charge * inv_duree)
				index_charge += delta
			else :
				charge_saut = 1.0
		
		elif charge_saut > 0.0:
			var input_axis = prendreAxeInput()
			if input_axis.y < 0.0:
				forces.append(input_axis.normalized() * puissance_max_saut * charge_saut)
				charge_saut = 0.0
				index_charge = 0.0
	else:
		if velocite.length():
			forces.append(-velocite * frottements_aerien * delta)
		forces.append(Vector2(0.0, gravite * delta * masse * masse))
		
	
	return forces
