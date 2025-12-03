extends Node2D

@onready var bench_pos = %Bench_Pos
@onready var sprite_sac = %Sprite_Sac
@export var btn : Button
var screen_size 

var tab_animaux : Array[Animal]
var tab_bench : Array[Animal]

signal fin_menu_sac(tab_anim,tab_banc)

func _ready() -> void:
	screen_size = get_viewport_rect().size
	positionAlchemique()
	btn_hide()



func positionAlchemique():
	var benchildren = bench_pos.get_children()
	screen_size = get_viewport_rect().size
	bench_pos.position = Vector2(screen_size.x * 0.7,0.0)
	var i = 0.0
	var j = 0.0
	while i < 16.0 :
		benchildren[i].position = Vector2(0.0,screen_size.y * ((j + 1) * 0.2))
		benchildren[i+1].position = Vector2(0.0,screen_size.y * ((j + 1) * 0.2))
		benchildren[i+2].position = Vector2(128.0,screen_size.y * ((j + 1) * 0.2))
		benchildren[i+3].position = Vector2(128.0,screen_size.y * ((j + 1) * 0.2))
		benchildren[i].sprite_text = null
		benchildren[i+2].sprite_text = null
		benchildren[i].souvenirPositionnel()
		benchildren[i+2].souvenirPositionnel()

		j = j + 1
		i = i + 4.0

func chefdOrganisation(tab_anim,tab_banc):
	positionAlchemique()
	var sacchildren = sprite_sac.get_children()
	var index_sac = 0
	var benchenfant = bench_pos.get_children()
	for i in tab_anim :
		sacchildren[index_sac].sprite_text = i
		sacchildren[index_sac].souvenirPositionnel()
		index_sac = index_sac + 2
	index_sac = 0
	for j in tab_banc :
		benchenfant[index_sac].sprite_text = j
		benchenfant[index_sac].souvenirPositionnel()
		index_sac = index_sac + 2

func btn_show():
	btn.disabled = false
	btn.focus_mode = btn.FOCUS_ALL
	
	
func btn_hide():
	btn.disabled = true
	btn.focus_mode = btn.FOCUS_NONE

func _on_btn_validation_pressed() -> void:
	var dropped_animals = get_tree().get_nodes_in_group("animal_objects")
	tab_animaux.clear()
	tab_animaux.resize(3)
	for i in dropped_animals :
		if not i.hitbox.disabled :
			if i.body_ref == null :
				var hehe = i.area.get_overlapping_bodies()
				i.body_ref = hehe[0]
			if i.body_ref.nb_order <= 2 :
				tab_animaux[i.body_ref.nb_order] = i.sprite_text
			else :
				tab_bench.append(i.sprite_text)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	fin_menu_sac.emit(tab_animaux,tab_bench)
	
