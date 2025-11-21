extends CharacterBody2D

var animal : Animal 
var index_animal:= 0

var vitesse:= 8.0
var frottements:= 0.1
var masse:= 1.0
var inv_masse := 1.0

var velocite:= Vector2.ZERO
var acceleration:= Vector2.ZERO

var gravite: float

func _ready() -> void:
	gravite = get_tree().root.get_child(2).gravite
	transformationAnimale()

func _unhandled_input(event: InputEvent) -> void:
	animal.prendreInput(event, false)

func transformationAnimale():
	animal.setup(gravite)
	masse = animal.masse
	inv_masse = animal.inv_masse
	$Sprite2D.texture = animal.sprite
	$CollisionShape2D.shape = animal.collision_shape
	

func appliquerForce(force: Vector2):
	acceleration += force * inv_masse

func magieDeMarche():
	velocite += acceleration
	acceleration *= 0.0
	velocity = velocite
	if move_and_slide():
		velocite = velocity

func _physics_process(delta: float) -> void:
	var mur:= 0
	if is_on_wall():
		if (get_last_slide_collision().get_position() - global_position).x < 0.0:
			mur = 1
		else:
			mur = 2
	for force in animal.prendreMouvements(delta, velocite, is_on_floor(), mur):
		appliquerForce(force)
	magieDeMarche()
