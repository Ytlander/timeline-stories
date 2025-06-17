extends Node2D

var clicked_cards: Array
var dragged_card
var lerp_speed: int = 25

func _ready():
	EventBus.card_clicked.connect(_on_card_clicked)

func _physics_process(delta):
	if !clicked_cards.is_empty():
		clicked_cards[0].global_position = lerp(clicked_cards[0].global_position, get_global_mouse_position(), lerp_speed * delta)
		
		if Input.is_action_just_released("left_click"):
			clicked_cards.clear()

func _on_card_clicked(card):
	clicked_cards.append(card)
	print(clicked_cards)
