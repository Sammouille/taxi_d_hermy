extends Node2D


@export var btn : Button
var ordre_animaux : Array[Animal]
var order_drop_in_or_out = true

signal confirm_ordre

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("choisis"):
		changeOrderVisibility()

func verifieSiPLeins() -> bool:
	var dropped_animals = get_tree().get_nodes_in_group("animal_select")
	ordre_animaux.clear()
	ordre_animaux.resize(dropped_animals.size())
	for i in dropped_animals :
		if not i.is_inside_drop_zone:
			return false
		ordre_animaux[i.body_ref.nb_order] = i.sprite_text
	return true

func btn_show():
	btn.disabled = false
	btn.focus_mode = btn.FOCUS_ALL
	
	
func btn_hide():
	btn.disabled = true
	btn.focus_mode = btn.FOCUS_NONE

func changeOrderVisibility():
	var tween = get_tree().create_tween()
	if order_drop_in_or_out :
		tween.tween_property(self,"modulate",Color(Color.WHITE,1.0),0.1)
		btn_show()
	else :
		tween.tween_property(self,"modulate",Color(Color.WHITE,0.0),0.1)
		btn_hide()
	order_drop_in_or_out = !order_drop_in_or_out

func _on_btn_valide_pressed() -> void:
	if verifieSiPLeins() :
		changeOrderVisibility()
		confirm_ordre.emit(ordre_animaux)
		
