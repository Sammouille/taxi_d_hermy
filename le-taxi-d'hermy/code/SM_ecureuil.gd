extends StateMachineAnimal
class_name StateMachineEcureuil

var duree_renard_mur:= 0.2
var index_renard_mur:= 0.0

func setup() -> void:
	add_etat("glisse_mur")
	super()

func machine_logic(delta: float, velocite: Vector2, on_floor: bool, mur: int, input_axis: Vector2):
	super(delta, velocite, on_floor, mur, input_axis)
	if etat == etats.tombe:
		if der_etat == etats.glisse_mur:
			if index_renard_mur < duree_renard_mur:
				index_renard_mur += delta
				set_etat(etats.marche)
	elif etat == etats.marche or etat == etats.attend:
		if index_renard_mur != 0.0:
			index_renard_mur = 0.0


func _state_logic(_delta):
	pass

func alchimieTemporelleCoyotesqueRupestre(delta: float, mur: int, input_axis: Vector2) -> bool:
	if etat == etats.glisse_mur:
		if !(input_axis.x < 0.0 and mur == 1) or (input_axis.x > 0.0 and mur == 2):
			if index_renard_mur != 0.0:
				index_renard_mur = 0.0
		else:
			index_renard_mur += delta
			if index_renard_mur > duree_renard_mur:
				return false
	
	return true

func _get_transition(_delta: float, velocite: Vector2, on_floor: bool, mur: int, input_axis: Vector2):
	match etat:
		etats.attend:
			if on_floor:
				if abs(velocite.x) > 0.0:
					return etats.marche
				else:
					return etats.attend
			else:
				if velocite.y < 0.0:
					return etats.saute
				else:
					return etats.tombe
		etats.marche:
			if on_floor:
				if abs(velocite.x) > 0.0:
					return etats.marche
				else:
					return etats.attend
			else:
				if velocite.y < 0.0:
					return etats.saute
				else:
					return etats.tombe
		etats.saute:
			if on_floor:
				if abs(velocite.x) > 0.0:
					return etats.marche
				else:
					return etats.attend
			elif (input_axis.x < 0.0 and mur == 1) or (input_axis.x > 0.0 and mur == 2):
				return etats.glisse_mur
			else:
				if velocite.y < 0.0:
					return etats.saute
				else:
					return etats.tombe
		etats.tombe:
			if on_floor:
				if abs(velocite.x) > 0.0:
					return etats.marche
				else:
					return etats.attend
			elif (input_axis.x < 0.0 and mur == 1) or (input_axis.x > 0.0 and mur == 2):
				return etats.glisse_mur
			else:
				if velocite.y < 0.0:
					return etats.saute
				else:
					return etats.tombe
		etats.glisse_mur:
			if on_floor:
				return etats.attend
			elif (input_axis.x < 0.0 and mur == 1) or (input_axis.x > 0.0 and mur == 2):
				return null
			elif velocite.y < 0:
				return etats.saute
			else:
				return etats.tombe
