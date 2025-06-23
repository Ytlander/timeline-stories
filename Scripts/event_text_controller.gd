extends Control

@onready var header = $EventText/MarginContainer/VBoxContainer/Header
@onready var text = $EventText/MarginContainer/VBoxContainer/Text

func _ready():
	EventBus.connect("display_text", _on_display_text)
	
func _on_display_text(card):
	self.header.text = card.card_header.text
	#Inject text here when that is implemented on card
