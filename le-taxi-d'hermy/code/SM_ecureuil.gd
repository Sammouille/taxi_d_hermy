extends StateMachine

func _ready() -> void:
	add_etat("attend")
	add_etat("marche")
	add_etat("tombe")
	add_etat("saute")
	add_etat("glisse_mur")
	
	call_deferred("set_etat", etats.attend)

func _state_logic(delta):
	pass

func _get_transition(delta: float, velocite: Vector2, on_floor: bool, mur: int):
	match etat:
		etats.attend:
			if detenteur
			pass
