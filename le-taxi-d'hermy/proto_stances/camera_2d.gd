extends Camera2D

@export var cible: Node2D
@export var vitesse:= 1.0

func _process(delta: float) -> void:
	if cible:
		if cible.position != position:
			position += (cible.position - position) * delta * vitesse
