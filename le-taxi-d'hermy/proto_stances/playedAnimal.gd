extends CharacterBody2D

@export var animaux : Array[Animal]
var active_animal : Animal 
var index_animal:= 0

var vitesse:= 8.0
var frottements:= 0.1
var masse:= 1.0
var inv_masse := 1.0

var velocite:= Vector2.ZERO
var acceleration:= Vector2.ZERO

var gravite: float

func _ready() -> void:
	gravite = get_tree().root.get_child(0).gravite
	transformationAnimale()

func transformationAnimale():
	active_animal = animaux[index_animal]
	active_animal.setup(gravite)
	masse = active_animal.masse
	inv_masse = active_animal.inv_masse
	$Sprite2D.texture = active_animal.sprite
	$CollisionShape2D.shape = active_animal.collision_shape
	

func appliquerForce(force: Vector2):
	acceleration += force * inv_masse

func magieDeMarche():
	velocite += acceleration
	acceleration *= 0.0
	velocity = velocite
	if move_and_slide():
		velocite = velocity

func _unhandled_input(event: InputEvent) -> void:
	active_animal.prendreInput(event)
	if Input.is_action_just_pressed("switch_apres"):
		index_animal += 1
		if index_animal >= animaux.size():
			index_animal -= animaux.size()
		transformationAnimale()
	elif Input.is_action_just_pressed("switch_avant"):
		index_animal -= 1
		if index_animal < 0:
			index_animal += animaux.size()
		transformationAnimale()

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
