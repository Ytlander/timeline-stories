extends Area2D

@export var card_width: float = 150
@export var padding: float = 20

var placed_cards: Array[Card] = []
var visible_cards: Array[int] = [0,1,2,3]

var card_batch: int = 1

func _ready() -> void:
	EventBus.card_dropped.connect(_on_card_dropped)
	EventBus.card_dragged.connect(_on_card_dragged)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_left"):
		if visible_cards[0] == 0:
			print("Already scrolled all the way to the left")
			return
		for i in range(visible_cards.size()):
			visible_cards[i] -= 1
		organize_cards("left")
	if event.is_action_pressed("scroll_right"):
		if visible_cards.back() == placed_cards.size() or visible_cards.size() > placed_cards.size():
			print("Already scrolled all the way to the right")
			return
		for i in range(visible_cards.size()):
			visible_cards[i] += 1
		organize_cards("right")
	
func _on_card_dropped(dropped_card: Card):
	if dropped_card in get_overlapping_areas():
		if placed_cards.is_empty():
			placed_cards.append(dropped_card)
			organize_cards()
			return
		for placed_card in placed_cards:
			if dropped_card.global_position.x < placed_card.global_position.x:
				var insert_index: int = placed_cards.find(placed_card)
				placed_cards.insert(insert_index, dropped_card)
				organize_cards()
				return
		placed_cards.append(dropped_card)
		organize_cards()
	else:
		organize_cards()

func _on_card_dragged(dragged_card: Card):
	if dragged_card not in placed_cards:
		return
	placed_cards.erase(dragged_card)

func organize_cards(dir: String = "none"):
	var total_width: float = $CollisionShape2D.shape.size.x
	var left_edge: float = global_position.x - total_width / 2
	var offset: float = left_edge + padding + card_width / 2
	
	var i: int = 0
	
	if placed_cards.is_empty():
		return
		
	for placed_card in placed_cards:
		if placed_cards.find(placed_card) not in visible_cards:
			placed_card.visible = false
		else:
			var target_pos = Vector2(card_width * i + offset, global_position.y)
			placed_card.visible = true
			placed_card.z_index = 0 #This places them behind the left/right covers
			match dir:
				"none":
					placed_card.global_position = target_pos
				"left":
					var tween = create_tween()
					placed_card.global_position = Vector2(card_width * (i - 1) + offset, global_position.y)
					tween.tween_property(placed_card, "global_position", target_pos, 0.5)
				"right":
					var tween = create_tween()
					placed_card.global_position = Vector2(card_width * (i + 1) + offset, global_position.y)
					tween.tween_property(placed_card, "global_position", target_pos, 0.5)
			i += 1
			

func _on_check_button_pressed() -> void:
	var all_cards = get_tree().get_nodes_in_group("story_card")
	for story_card in all_cards:
		if story_card not in placed_cards:
			show_message("Not all cards are placed on the timeline", "Error")
			return
	
	var stored_event: int = -1
	for placed_card in placed_cards:
		if placed_card.event_number < stored_event:
			show_message("Wrong order, try again!", "Incorrect")
			return
		if placed_card == placed_cards.back():
			#The success message is now handled by the reading area
			#show_message("Good job, you placed the cards in the correct order!", "Success")
			EventBus.validate_successful.emit(card_batch)
			card_batch += 1
			return
		if placed_card.event_number > stored_event:
			stored_event = placed_card.event_number

func show_message(text: String, title: String):
	$AcceptDialog.title = title
	$AcceptDialog.dialog_text = text
	$AcceptDialog.popup_centered()
