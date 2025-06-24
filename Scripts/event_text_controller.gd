extends Control

@onready var header = $EventText/MarginContainer/VBoxContainer/Header
@onready var text = $EventText/MarginContainer/VBoxContainer/Text
@onready var event_text = $EventText


func _ready():
	EventBus.connect("display_text", _on_display_text)
	EventBus.connect("close_textbox", _on_close_textbox)
	
func _on_display_text(card):
	self.visible = true
	self.header.text = card.card_header.text
	#Inject text body here when that is implemented on card

func _on_close_textbox():
	self.visible = false
