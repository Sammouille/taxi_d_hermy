@abstract
extends Resource
class_name Animal

@export var frottements_sol:= 10.0
@export var frottements_aerien:= 1.0
@export var masse:= 2.0:
	set(value):
		masse = value
		inv_masse = 1.0/value
var inv_masse := 1.0

@export var sprite: Texture
@export var collision_shape: Shape2D

var gravite:= 1.0

func setup(_gravite):
	gravite = _gravite
	preparationAnimale()

func preparationAnimale():
	pass

func prendreAxeInput() -> Vector2:
	var _input: Vector2
	_input.x = Input.get_axis("gauche","merde")
	_input.y = Input.get_axis("haut","bas")
	return _input

@abstract func prendreMouvements(delta: float, velocite: Vector2, on_floor: bool, mur: int) -> Array[Vector2]

func prendreInput(_event: InputEvent) -> void:
	pass
