extends Node

var slots: int = 0
var slot_positions: Array[Vector2] = []

@export var card_size: Vector2 = Vector2(100,150)
@export var card_padding: float = 20.0


func _ready() -> void:
	EventBus.card_dragged.connect(_on_card_dragged)
	EventBus.card_dropped.connect(_on_card_dropped)
	
	
func _on_card_dragged(dragged_card: Card):
	dragged_card.dragged = true
	if dragged_card.placed:
		dragged_card.placed = false
		dragged_card.timeline_slot = -1

func _on_card_dropped(dropped_card: Card):
	dropped_card.dragged = false
