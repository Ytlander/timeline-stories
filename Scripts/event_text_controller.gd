extends Control

@onready var header = $EventText/MarginContainer/VBoxContainer/Header
@onready var event_text = $EventText
@onready var body = $EventText/MarginContainer/VBoxContainer/Body


func _ready():
	EventBus.connect("display_text", _on_display_text)
	EventBus.connect("close_textbox", _on_close_textbox)
	EventBus.connect("validate_successful", _on_validate_successful)
	EventBus.connect("error_message", _on_error_message)
	
##Grabbing both the header text and the text body from the card that is past in through this signal
func _on_display_text(card):
	self.visible = true
	self.header.text = card.card_header.text
	self.body.text = card.body

func _on_close_textbox():
	pass
	#self.visible = false

func _on_validate_successful(batch_number, _cards):
	if batch_number < 6:
		self.header.text = "Success!"
		self.body.text = "You placed all events in the correct order, you have been given new events, now place them in chronological order as well."
	else:
		self.header.text = "Win!"
		self.body.text = "[left]Congratulations, you completed the game![/left]"
		
func _on_error_message(header, message):
	self.header.text = header
	self.body.text = message
