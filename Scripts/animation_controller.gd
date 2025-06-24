extends Node

var previous_card

func _ready():
	EventBus.connect("display_text", _on_display_text)

func _on_display_text(card):
	if previous_card:
		previous_card.selected_sprite.visible = false
		
	card.selected_sprite.visible = true
	
	if card == previous_card:
		card.selected_sprite.visible = false
		EventBus.close_textbox.emit()
		previous_card = null
	
	else:
		previous_card = card
