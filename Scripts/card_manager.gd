extends Node2D

@export var click_to_drop: bool = false

var clicked_cards: Array
var right_clicked_cards: Array
var card_to_open: Card
var selected_card: Card
var dragged_card: Card = null
var dragged_card_return_pos: Vector2
var lerp_speed: int = 25
var mouse_offset: Vector2
@onready var boundary_right = $BoundaryRight
@onready var boundary_left = $BoundaryLeft
@onready var boundary_bottom = $BoundaryBottom
@onready var boundary_top = $BoundaryTop

func _ready():
	EventBus.card_clicked.connect(_on_card_clicked)
	EventBus.card_right_clicked.connect(_on_card_right_clicked)
	EventBus.validate_successful.connect(_on_validate_successful)

func _physics_process(delta):
		if dragged_card != null:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			check_overlapping_cards()
			var target_position = get_global_mouse_position() - mouse_offset
			dragged_card.global_position = lerp(dragged_card.global_position, target_position, lerp_speed * delta)
		
		if click_to_drop == false:
			if Input.is_action_just_released("left_click"):
				drop_card()
		
		if Input.is_action_just_pressed("left_click"):
			if click_to_drop && dragged_card != null:
				drop_card()

func check_overlapping_cards():
		var overlapping_cards = dragged_card.get_overlapping_areas()
		if !overlapping_cards.is_empty():
			get_highest_z_level_card(overlapping_cards)
			dragged_card.z_index = overlapping_cards[0].z_index + 2
		
		if overlapping_cards.is_empty():
			dragged_card.z_index = dragged_card.default_z_index

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
			
			dragged_card_return_pos = dragged_card.global_position
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
			selected_card = card_to_open
			card_to_open = null

func drop_card() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventBus.card_dropped.emit(dragged_card)
	dragged_card = null
	clicked_cards.clear()

##This sorts an array based on Z index. Maybe move this into a utility function in the future? Could be used for multiple things. 
func get_highest_z_level_card(cards: Array):
	cards.sort_custom(func(a, b): return a.z_index > b.z_index)
	
	return cards[0]

##This will fire once for every overlapping card that is clicked on. Therefore we save all the cards in an array	
func _on_card_clicked(card):
	if !card.locked:
		clicked_cards.append(card)

func _on_card_right_clicked(card):
	if dragged_card == null:
		right_clicked_cards.append(card)

func _on_validate_successful(_batch_number, cards):
	for card in cards:
		card.locked = true
	
	if selected_card:
		selected_card.selected_sprite.visible = false

#region Card Boundaries
## These boundaries make sure that the cards don't leave the play area
## There is some weird bug where it's sometimes possible to drag cards outside the bounds but I can't reproduce it reliably
## There is probably a better way to do this, maybe it should be done with coordinates instead of collision?

func _on_boundary_right_area_entered(area):
	if dragged_card && area == dragged_card:
		dragged_card.global_position.x = boundary_right.global_position.x - 80
		drop_card()
		
func _on_boundary_left_area_entered(area):
	if dragged_card && area == dragged_card:
		dragged_card.global_position.x = boundary_left.global_position.x + 80
		drop_card()

func _on_boundary_bottom_area_entered(area):
	if dragged_card && area == dragged_card:
		dragged_card.global_position.y = boundary_bottom.global_position.y - 120
		drop_card()
		
func _on_boundary_top_area_entered(area):
	if dragged_card && area == dragged_card:
		dragged_card.global_position.y = boundary_top.global_position.y + 130
		drop_card()

#endregion
