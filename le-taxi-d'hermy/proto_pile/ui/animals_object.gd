extends Node2D

@export var sprite_text : Resource
var draggable = false
var is_inside_drop_zone = false
var body_ref
var offset : Vector2
var initial_pos : Vector2
@onready var sprite = %Choix_sprite

func _ready() -> void:
	sprite.texture = sprite_text.frame1
	initial_pos = global_position
func _process(_delta: float) -> void:
	if draggable :
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
			GlobalIsDragging.is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			GlobalIsDragging.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_drop_zone :
				tween.tween_property(self,"position",body_ref.position,0.2).set_ease(Tween.EASE_OUT)
			else :
				tween.tween_property(self,"global_position",initial_pos,0.2).set_ease(Tween.EASE_OUT)
func _on_area_2d_mouse_entered() -> void:
	if not GlobalIsDragging.is_dragging :
		draggable = true
		scale = Vector2(1.05,1.05)


func _on_area_2d_mouse_exited() -> void:
	if not GlobalIsDragging.is_dragging :
		draggable = false
		scale = Vector2(1.0,1.0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("dropable_place"):
		is_inside_drop_zone = true
		body.modulate = Color(Color.MEDIUM_SEA_GREEN,1.0)
		body_ref = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("dropable_place"):
		is_inside_drop_zone = false
		body.modulate = Color(Color.MEDIUM_SEA_GREEN,0.7)
