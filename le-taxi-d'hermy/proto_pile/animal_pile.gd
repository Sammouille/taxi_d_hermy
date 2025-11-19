extends CharacterBody2D

@export var horizontal_speed := 400
@export var jump_speed := -800
@export var gravity := 3000
@export_range(0.0,1.0) var friction := 0.1
@export_range(0.0,1.0) var acceleration := 0.25
@export var rotation_pile : Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("saut"):
		velocity.y = jump_speed

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	deplacement(delta)
	
	move_and_slide()

func deplacement(delta):
	velocity.y += gravity * delta
	var dir = Input.get_axis("gauche","merde")
	if dir !=0.0 :
		velocity.x = lerp(velocity.x, dir * horizontal_speed, acceleration)
	else :
		velocity.x = lerp(velocity.x,0.0,friction)
