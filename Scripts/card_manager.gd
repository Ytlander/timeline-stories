extends Node2D

@export var click_to_drop: bool = false

var clicked_cards: Array
var right_clicked_cards: Array
var card_to_open: Area2D
var dragged_card: Area2D = null
var lerp_speed: int = 25
var mouse_offset: Vector2

func _ready():
	EventBus.card_clicked.connect(_on_card_clicked)
	EventBus.card_right_clicked.connect(_on_card_right_clicked)

func _physics_process(delta):
		if dragged_card != null:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			check_overlapping_cards()
			var target_position = get_global_mouse_position() - mouse_offset
			dragged_card.global_position = lerp(dragged_card.global_position, target_position, lerp_speed * delta)
		
		if click_to_drop == false:
			if Input.is_action_just_released("left_click"):
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				EventBus.card_dropped.emit(dragged_card)
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
		await get_tree().process_frame #Need to wait for the clicked_cards array to populate
		if !clicked_cards.is_empty():
			if clicked_cards.size() > 1:
				dragged_card = get_highest_z_level_card(clicked_cards)
			else:
				dragged_card = clicked_cards[0]
		## Getting the mouse offset so that card doesn't snap to the center
		if dragged_card:
			EventBus.card_dragged.emit(dragged_card)
			var mouse_position = get_global_mouse_position()
			mouse_offset = mouse_position - dragged_card.global_position
	
	##Getting the top card when right clicking a stack
	##Sends a signal that we have a card that we want to open
	##This signal is received by the Animation Controller and the Event Text Controller
	if Input.is_action_just_pressed("right_click"):
		await  get_tree().process_frame #Need to wait for the right_clicked_cards array to populate
		if !right_clicked_cards.is_empty():
			if right_clicked_cards.size() > 1:
				card_to_open = get_highest_z_level_card(right_clicked_cards)
			else:
				card_to_open = right_clicked_cards[0]
		if card_to_open:
			EventBus.display_text.emit(card_to_open)
			right_clicked_cards.clear()
			card_to_open = null


##This sorts an array based on Z index. Maybe move this into a utility function in the future? Could be used for multiple things. 
func get_highest_z_level_card(cards: Array):
	cards.sort_custom(func(a, b): return a.z_index > b.z_index)
	
	return cards[0]

##This will fire once for every overlapping card that is clicked on. Therefore we save all the cards in an array	
func _on_card_clicked(card):
	clicked_cards.append(card)

func _on_card_right_clicked(card):
	if dragged_card == null:
		right_clicked_cards.append(card)
