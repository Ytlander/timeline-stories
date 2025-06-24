extends Control

@onready var header = $EventText/MarginContainer/VBoxContainer/Header
@onready var text = $EventText/MarginContainer/VBoxContainer/Text
@onready var event_text = $EventText

#Uncomment all lines using the slide in and slide out variables to see a non functioning slide effect
#@export var slide_in: bool = false
#var slide_out: bool = false
#@export var speed = 900

func _ready():
	EventBus.connect("display_text", _on_display_text)
	EventBus.connect("close_textbox", _on_close_textbox)
	
#func _process(delta):
	#if slide_in:
		#position.x -= speed * delta
		#if position.x <= 900:
			#slide_in = false
	#
	#if slide_out:
		#position.move_toward(Vector2.RIGHT, 30 * delta)
		#position.x += speed * delta
		#if position.x >= 1400:
			#slide_out = false
	
func _on_display_text(card):
	#slide_in = true
	self.visible = true
	self.header.text = card.card_header.text
	#Inject text body here when that is implemented on card

func _on_close_textbox():
	self.visible = false
	#slide_out = true
