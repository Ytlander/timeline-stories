extends Control

@onready var header = $EventText/MarginContainer/VBoxContainer/Header
@onready var event_text = $EventText
@onready var body = $EventText/MarginContainer/VBoxContainer/Body


func _ready():
	EventBus.connect("display_text", _on_display_text)
	EventBus.connect("close_textbox", _on_close_textbox)
	EventBus.connect("validate_successful", _on_validate_successful)
	
##Grabbing both the header text and the text body from the card that is past in through this signal
func _on_display_text(card):
	self.visible = true
	self.header.text = card.card_header.text
	self.body.text = card.body

func _on_close_textbox():
	self.visible = false

func _on_validate_successful(_batch_number):
	self.visible = true
	self.header.text = "Success!"
	self.body.text = "You placed all events in the correct order, you have been given new events, now place them in chronological order as well."
