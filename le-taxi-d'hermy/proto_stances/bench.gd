extends Area2D

@export var animaux_bench : Array[Animal]
@export var bag_menu : Node2D
var can_seat = false

signal sitting(anim_bench,banc)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("banc") and can_seat :
		sitting.emit(animaux_bench,self)


func _on_body_entered(body: Node2D) -> void:
	if str(body).get_slice(":",0) == "AnimalJoue" :
		can_seat = true
	


func _on_body_exited(body: Node2D) -> void:
	if str(body).get_slice(":",0) == "AnimalJoue" :
		can_seat = false
