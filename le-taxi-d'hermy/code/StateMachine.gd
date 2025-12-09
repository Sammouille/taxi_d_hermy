@abstract
extends RefCounted
class_name StateMachine

var etat = null
var der_etat = null
var etats = {}

func machine_logic(delta: float, velocite: Vector2, on_floor: bool, mur: int, input_axis: Vector2):
	if etat != null :
		_etat_logic(delta)
		var transition = _get_transition(delta, velocite, on_floor, mur, input_axis)
		if transition != null and transition != etat :
			set_etat(transition)

func set_etat(nouveau_etat):
	der_etat = etat
	etat = nouveau_etat
	
	if der_etat != null :
		_exit_etat(der_etat, nouveau_etat)
	if nouveau_etat != null :
		_enter_etat(nouveau_etat, der_etat)

func get_etat():
	return etat

func get_der_etat():
	return der_etat

func add_etat(etat_name):
	etats[etat_name] = etats.size()

@abstract func setup()

@abstract func _etat_logic(delta: float)

@abstract func _get_transition(delta: float, velocite: Vector2, on_floor: bool, mur: int, input_axis: Vector2)

@abstract func _enter_etat(_nouveau_etat, _prec_etat)

@abstract func _exit_etat(_prec_etat, _nouveau_etat)
