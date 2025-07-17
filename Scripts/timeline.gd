extends Area2D

func _ready() -> void:
	EventBus.card_dropped.connect(_on_card_dropped)
	
func _on_card_dropped(dropped_card: Card):
	if dropped_card in get_overlapping_areas():
		dropped_card.global_position = global_position
