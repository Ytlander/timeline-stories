extends Area2D

@onready var htl: HorizontalTimeline = $HorizontalTimeLine

var card_batch: int = 1

func _ready() -> void:
	EventBus.card_dropped.connect(_on_card_dropped)
	#EventBus.card_dragged.connect(_on_card_dragged)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_left"):
		htl.move_left()
	if event.is_action_pressed("scroll_right"):
		htl.move_right()

func _on_card_dropped(dropped_card: Card) -> void:
	if dropped_card in get_overlapping_areas():
		if htl.cards.is_empty():
			htl.place_card(dropped_card)
			return
		
		for placed_card in htl.cards:
			if dropped_card.global_position.x < placed_card.global_position.x:
				var insert_index: int = htl.cards.find(placed_card)
				htl.place_card(dropped_card, insert_index)
				return
		
		htl.place_card(dropped_card)
		return
	htl.remove_card(dropped_card)
	htl._realign_cards()

#func _on_card_dragged(dragged_card: Card) -> void:
	#if dragged_card not in htl.cards:
		#return
	#htl.remove_card(dragged_card)

# Example validation logic
func _on_check_button_pressed() -> void:
	var all_cards = get_tree().get_nodes_in_group("story_card")
	for story_card in all_cards:
		if story_card not in htl.cards:
			show_message("Not all cards are placed on the timeline", "Error")
			return
	
	var stored_event: int = -1
	for card in htl.cards:
		if card.event_number < stored_event:
			show_message("Wrong order, try again!", "Incorrect")
			return
		if card == htl.cards.back():
			if card_batch == 6:
				show_message("Good job, you placed all the cards in the correct order!", "Win")
				return
			EventBus.validate_successful.emit(card_batch, htl.cards)
			card_batch += 1
			return
		stored_event = card.event_number

func show_message(text: String, title: String):
	$AcceptDialog.title = title
	$AcceptDialog.dialog_text = text
	$AcceptDialog.popup_centered()
