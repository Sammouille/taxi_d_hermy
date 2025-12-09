extends Animal
class_name Ecureuil


@export var puissance_mursaut:= 800.0
@export var mursaut_directionnel:= true
@export var accroche: Curve
@export var puissance_ejection:= 200.0
@export var duree_accroche:= 2.5
var index_accroche:= 0.0

func preparationAnimale():
	sm = StateMachineEcureuil.new()
	sm.setup()

func prendreMouvements(delta: float, velocite: Vector2, on_floor: bool, mur: int) -> Array[Vector2]:
	sm.machine_logic(delta, velocite, on_floor, mur, input_axis)
	
	print(sm.etats.find_key(sm.etat))
	print(name)
	
	var forces : Array[Vector2] = []
	
	match sm.etat :
		sm.etats.tombe:
			forces.append_array(mouvementAerien(delta, velocite))
			if mur == 0 and index_accroche != 0.0:
				index_accroche = 0.0
		sm.etats.saute:
			forces.append_array(mouvementAerien(delta, velocite))
			if mur == 0 and index_accroche != 0.0:
				index_accroche = 0.0
		
		sm.etats.attend:
			forces.append_array(mouvementTerrestre(delta, velocite))
		sm.etats.marche:
			forces.append_array(mouvementTerrestre(delta, velocite))
		
		sm.etats.glisse_mur:
			forces.append_array(mouvementRupestre(delta, velocite, mur))
	
	return forces


func mouvementRupestre(delta:float, velocite:Vector2, mur: int):
	var forces : Array[Vector2] = []
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
		# Si le saut est directionnel on lui donne l'axe de l'input
		if mursaut_directionnel:
			if (input_axis.x < 0.0 and mur == 1) or (input_axis.x > 0.0 and mur == 2):
				forces.append(input_axis.normalized() * puissance_mursaut)
		# Sinon on lui donne simplement une force verticale
		elif mur == 1:
			forces.append((Vector2.UP + Vector2.RIGHT).normalized() * puissance_mursaut)
		elif mur == 1:
			forces.append((Vector2.UP + Vector2.LEFT).normalized() * puissance_mursaut)
	
	if index_accroche < accroche.get_domain_range():
		index_accroche += delta
		forces.append(Vector2(0.0, gravite * delta * masse * masse * (1.0-accroche.sample(index_accroche))))
	else:
		forces.append(Vector2(0.0, gravite * delta * masse * masse))
	
	return forces
