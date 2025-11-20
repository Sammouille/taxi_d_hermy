@tool
extends Node2D
class_name animal_physic

@export var ball : RigidBody2D
@export var gravity_force := Vector2(0.0,-10.0)
@export var center := Vector2(0.0,-20.0)

@export var PGain := 1.0
@export var Ptext : RichTextLabel
@export var IGain := 1.0
@export var Itext : RichTextLabel
@export var DGain := 0.1
@export var Dtext : RichTextLabel
@export var container : Control
var last_D_value = Vector2.ZERO
var integration_stored = Vector2.ZERO
@export var integral_saturation_min_max := Vector2(1.0,1.0)
@export var output_min_max := Vector2(100.0,100.0)

@export var start_frame := 0
@export var nb_frame := 2
@onready var sprite = %Sprite2D
var animal_current : Resource
@export var animaux_tab : Array[Resource]
var is_on_screen = false
var animal_body


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("sifflet"):
		ball.apply_impulse(Vector2(-100.0,-200.0))
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animal_body = get_node("RigidBody2D")
	
func change_sprite(nom_animal):
	animal_current = nom_animal
	start_frame = animal_current.nb_associe
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var feur = pid_mano(delta,ball.position, center)
	
	ball.apply_impulse(feur)
	#container.global_position = Vector2(30.0,80.0)
	#queue_redraw()
	#ball.apply_force(gravity_force)
#func _draw() -> void:
	#draw_line(ball.position,center,Color.REBECCA_PURPLE,8.0)
	#draw_circle(ball.global_position - global_position,20.0,Color.AQUA)


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



func _on_p_gain_value_changed(value: float) -> void:
	PGain = value
	Ptext.text = str(PGain)


func _on_i_gain_value_changed(value: float) -> void:
	IGain = value
	Itext.text = str(IGain)


func _on_d_gain_value_changed(value: float) -> void:
	DGain = value
	Dtext.text = str(DGain)


func _on_change_sprite_timeout() -> void:
	nb_frame = (nb_frame + 1 )% 2
	sprite.frame = start_frame + nb_frame
