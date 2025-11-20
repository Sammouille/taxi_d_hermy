extends StaticBody2D

@export var nb_order : int

func _ready() -> void:
	modulate = Color(Color.MEDIUM_SEA_GREEN,0.7)

func _process(_delta: float) -> void:
	if GlobalIsDragging.is_dragging :
		visible = true
	else:
		visible = false
