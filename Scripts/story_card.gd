extends Area2D
class_name Card


@onready var card_header = $PanelContainer/MarginContainer/VBoxContainer/CardHeader

##Tells the Card Manager that the card has been clicked
func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):
		EventBus.card_clicked.emit(self)
	
	if Input.is_action_just_pressed("right_click"):
		EventBus.card_right_clicked.emit(self)
