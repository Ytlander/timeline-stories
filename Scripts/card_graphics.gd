##This script is used to handle all graphical changes on cards

extends Node

func _ready():
	EventBus.validate_successful.connect(_on_validate_successful)

func _on_validate_successful(_batch, cards):
	for card in cards:
		card.modulate = Color.GAINSBORO
