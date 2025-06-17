extends Node2D

@export var click_to_drop: bool = false

var clicked_cards: Array
var dragged_card: Area2D
var lerp_speed: int = 25
var mouse_offset: Vector2

func _ready():
	EventBus.card_clicked.connect(_on_card_clicked)

func _physics_process(delta):
		if dragged_card != null:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			check_overlapping_cards()
			var target_position = get_global_mouse_position() - mouse_offset
			dragged_card.global_position = lerp(dragged_card.global_position, target_position, lerp_speed * delta)
		
		if click_to_drop == false:
			if Input.is_action_just_released("left_click"):
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				dragged_card = null
				clicked_cards.clear()
		
		if Input.is_action_just_pressed("left_click"):
			if click_to_drop && dragged_card != null:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				dragged_card = null
				clicked_cards.clear()

func check_overlapping_cards():
		var overlapping_cards = dragged_card.get_overlapping_areas()
		if !overlapping_cards.is_empty():
			get_highest_z_level_card(overlapping_cards)
			dragged_card.z_index = overlapping_cards[0].z_index + 2
		
		if overlapping_cards.is_empty():
			dragged_card.z_index = 0

## We use the input event to sort the cards so that it doesn't happen every frame like it did when I had this 
## logic in the physics process loop.
func _input(event):
	if Input.is_action_just_pressed("left_click"):
		await get_tree().create_timer(0.001).timeout #If I don't have a delay the array will be empty, what is a more elegant solution?
		if !clicked_cards.is_empty():
			if clicked_cards.size() > 1:
				dragged_card = get_highest_z_level_card(clicked_cards)
			else:
				dragged_card = clicked_cards[0]
		## Getting the mouse offset so that card doesn't snap to the center
		if dragged_card:
			var mouse_position = get_global_mouse_position()
			mouse_offset = mouse_position - dragged_card.global_position

##This sorts an array based on Z index. Maybe move this into a utility function in the future? Could be used for multiple things. 
func get_highest_z_level_card(cards: Array):
	cards.sort_custom(func(a, b): return a.z_index > b.z_index)
	
	return cards[0]

##This will fire once for every overlapping card that is clicked on. Therefore we save all the cards in an array	
func _on_card_clicked(card):
	clicked_cards.append(card)
