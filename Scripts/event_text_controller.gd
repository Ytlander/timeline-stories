extends Control

@onready var header = $EventText/MarginContainer/VBoxContainer/Header
@onready var event_text = $EventText
@onready var body = $EventText/MarginContainer/VBoxContainer/Body


func _ready():
	EventBus.connect("display_text", _on_display_text)
	EventBus.connect("close_textbox", _on_close_textbox)
	
##Grabbing both the header text and the text body from the card that is past in through this signal
func _on_display_text(card):
	self.visible = true
	self.header.text = card.card_header.text
	self.body.text = card.body

func _on_close_textbox():
	self.visible = false
