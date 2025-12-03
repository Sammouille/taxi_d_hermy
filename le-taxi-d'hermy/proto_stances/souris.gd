extends Animal
class_name Souris

# Hermy n'est jamais laché
func prendreInput(_event: InputEvent, actif:= true):
	if actif:
		var _input: Vector2
		_input.x = Input.get_axis("gauche","merde")
		_input.y = Input.get_axis("haut","bas")
		input_axis = _input
		if Input.is_action_just_pressed("saut"):
			saute = true
	else :
		input_axis = Vector2.ZERO
		saute = false
