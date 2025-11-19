extends Node2D

@export var ball : RigidBody2D
@export var gravity_force : Vector2
@export var center : Node2D

@export var PGain : float
@export var IGain : float
@export var DGain : float
var last_D_value = Vector2.ZERO
var integration_stored = Vector2.ZERO
@export var integral_saturation_min_max : Vector2

var is_on_screen = false
var animal_body

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animal_body = get_node("RigidBody2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ball.apply_force(pid_mano(delta,ball.position, position))
	#ball.apply_force(gravity_force)

func _apply_force(force : float,pos : Vector2):
	ball.apply_impulse((ball.global_position - pos) * force)

func pid_mano(dt, current, target ) -> Vector2:
	# Distance cible punching ball
	var correction = target - current
	
	var p = correction * PGain

	print(target)
	var value_Rate_of_Change = (correction - last_D_value) / dt
	last_D_value = correction
	
	var d = DGain * value_Rate_of_Change
	
	## je sais pas pourquoi le i marche pas je me renseignerai plus tard
	var i = Vector2.ZERO
	##integration_stored = integration_stored + (correction * dt)
	#integration_stored = clamp(integration_stored + (correction * dt), -integral_saturation_min_max,integral_saturation_min_max )
	#var i = IGain * integration_stored
	
	var pid = p + i + d
	return clamp(pid, -integral_saturation_min_max,integral_saturation_min_max )



func _on_p_gain_value_changed(value: float) -> void:
	PGain = value


func _on_i_gain_value_changed(value: float) -> void:
	IGain = value


func _on_d_gain_value_changed(value: float) -> void:
	DGain = value
