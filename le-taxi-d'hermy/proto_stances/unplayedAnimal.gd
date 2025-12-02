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

@export var PGain := 1.0

@export var IGain := 1.0

@export var DGain := 0.1

var last_D_value = Vector2.ZERO
var integration_stored = Vector2.ZERO
@export var integral_saturation_min_max := Vector2(1.0,1.0)
@export var output_min_max := Vector2(100.0,100.0)


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


func pid_mano(dt, current, target ) -> Vector2:
	# Distance cible punching ball
	var correction = target - current
	
	var p = correction * PGain


	var value_Rate_of_Change = (correction - last_D_value) / dt
	last_D_value = correction
	
	var d = DGain * value_Rate_of_Change
	
	## je sais pas pourquoi le i marche pas je me renseignerai plus tard
	#var i = Vector2.ZERO
	##integration_stored = integration_stored + (correction * dt)
	integration_stored = clamp(integration_stored + (correction * dt), -integral_saturation_min_max,integral_saturation_min_max )
	var i = IGain * integration_stored
	
	var pid = p + i + d
	#print("physic point : ",pid, " | ", correction," | ", target, " | ", current)
	#print(clamp(pid.x, -output_min_max.x,output_min_max.x ),clamp(pid.y, -output_min_max.y,output_min_max.y ))
	return Vector2(clamp(pid.x, -output_min_max.x,output_min_max.x ),clamp(pid.y, -output_min_max.y,output_min_max.y ))


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
