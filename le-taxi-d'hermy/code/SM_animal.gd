extends StateMachine
class_name StateMachineAnimal

var duree_renard:= 0.2
var index_renard:= 0.0

func setup():
	add_etat("attend")
	add_etat("marche")
	add_etat("tombe")
	add_etat("saute")
	
	set_etat(etats.attend)
	#call_deferred("set_etat", etats.attend)

#func machine_logic(delta: float, velocite: Vector2, on_floor: bool, mur: int):
	#on_floor = alchimieTemporelleCoyotesque(delta,on_floor)
	#super(delta, velocite, on_floor, mur)

func _get_transition(_delta: float, velocite: Vector2, on_floor: bool, _mur: int):
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
			else:
				if velocite.y < 0.0:
					return etats.saute
				else:
					return etats.tombe


func alchimieTemporelleCoyotesque(delta: float, on_floor: bool) -> bool:
	if etat == etats.attend or etat == etats.marche:
		if on_floor:
			if index_renard != 0.0:
				index_renard = 0.0
		else:
			index_renard += delta
			if index_renard > duree_renard:
				return false
	
	return true

func _etat_logic(_delta: float): pass

func _enter_etat(_nouveau_etat, _prec_etat): pass

func _exit_etat(_prec_etat, _nouveau_etat): pass
