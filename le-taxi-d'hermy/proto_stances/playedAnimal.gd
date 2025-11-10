extends CharacterBody2D

@export var animaux : Array[Animal]
var active_animal : Animal 

var vitesse:= 8.0
var frottements:= 0.1
var masse:= 1.0
var inv_masse := 1.0

var velocite:= Vector2.ZERO
var acceleration:= Vector2.ZERO

var gravite: float

func _ready() -> void:
	active_animal = animaux[0]
	gravite = get_tree().root.get_child(0).gravite
	active_animal.setup(gravite)
	masse = active_animal.masse
	inv_masse = active_animal.inv_masse

func appliquerForce(force: Vector2):
	acceleration += force * inv_masse

func magieDeMarche():
	velocite += acceleration
	acceleration *= 0.0
	velocity = velocite
	move_and_slide()

func _physics_process(delta: float) -> void:
	var mur:= 0
	if is_on_wall():
		if (get_last_slide_collision().get_position() - global_position).x < 0.0:
			mur = 1
		else:
			mur = 2
	for force in active_animal.prendreMouvements(delta, velocite, is_on_floor(), mur):
		appliquerForce(force)
	magieDeMarche()
