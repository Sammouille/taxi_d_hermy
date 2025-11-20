extends CharacterBody2D

@export var horizontal_speed := 400
var current_horizontal_speed
@export var jump_speed := -800
var current_jump_speed
@export var jump_speed_grenouille := -1200
@export var horizontal_speed_grenouille_aerial := 200
@export var gravity := 3000
@export_range(0.0,1.0) var friction := 0.1
@export_range(0.0,1.0) var acceleration := 0.25
@export var rotation_pile : Node2D
@export var sprite_main_character : AnimatedSprite2D
@export var current : Resource
@export var all_animaux : Array
var base_sprite = 0
var animals = ["grepouille","grepouille","ecurouille","grepouille"]
@export var animal_physics : Array[animal_physic]

var nb_frame = 2
@export var order_drop : Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("saut"):
		if is_on_floor() or is_on_wall() and (animals.find("ecurouille") == 1  or animals.find("ecurouille") == 2) :
			velocity.y = current_jump_speed

func _ready() -> void:
	order_drop.confirm_ordre.connect(changeOrder.bind())
	current_horizontal_speed = horizontal_speed
	current_jump_speed = jump_speed

func _physics_process(delta: float) -> void:
	deplacement(delta)

	move_and_slide()

func deplacement(delta):
	velocity.y += gravity * delta
	var dir = Input.get_axis("gauche","merde")
	if dir !=0.0 :
		velocity.x = lerp(velocity.x, dir * current_horizontal_speed, acceleration)
	else :
		velocity.x = lerp(velocity.x,0.0,friction)
		

func changeOrder(tab_order):
	all_animaux = tab_order
	current = all_animaux[0]

	var idx_ap = 1
	for i in animal_physics :
		i.change_sprite(all_animaux[idx_ap])
		idx_ap = idx_ap + 1
	
	idx_ap = 0
	for j in all_animaux :
		animals[idx_ap] = j.nom
		idx_ap = idx_ap + 1

	base_sprite = current.nb_associe
	if animals[0] == "grepouille" :
		current_horizontal_speed = horizontal_speed_grenouille_aerial
		current_jump_speed = jump_speed_grenouille
	else : 
		current_horizontal_speed = horizontal_speed
		current_jump_speed = jump_speed
	


func _on_change_sprite_timeout() -> void:
	nb_frame = (nb_frame + 1 ) % 2
	sprite_main_character.frame = base_sprite + nb_frame
