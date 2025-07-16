extends Area2D
class_name Card

@onready var card_header = $PanelContainer/MarginContainer/VBoxContainer/CardHeader
@onready var selected_sprite = $SelectedSprite

##A multiline export variable allows for a editable textbox where simple formatting can be made
##like line breaks for example. So for text to be shown in the textbox, the export variable needs
##to have text
@export_multiline var body: String = "No text for this card yet, edit the export variable"

# Timeline stuff
var dragged: bool = false
var placed: bool = false
var timeline_slot: int

func _ready():
	selected_sprite.visible = false

##Tells the Card Manager that the card has been clicked
func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):
		EventBus.card_clicked.emit(self)
	
	if Input.is_action_just_pressed("right_click"):
		EventBus.card_right_clicked.emit(self)
