extends Node

func _ready():
	EventBus.connect("display_text", _on_display_text)

func _on_display_text(card):
	print("Animation controller received card: ", card)
