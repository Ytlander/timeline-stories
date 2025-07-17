extends Area2D

@export var card_width: float = 150
@export var padding: float = 20

var placed_cards: Array[Card] = []

func _ready() -> void:
	EventBus.card_dropped.connect(_on_card_dropped)
	EventBus.card_dragged.connect(_on_card_dragged)
	
func _on_card_dropped(dropped_card: Card):
	if dropped_card in get_overlapping_areas():
		placed_cards.append(dropped_card)
		organize_cards()

func _on_card_dragged(dragged_card: Card):
	if dragged_card not in placed_cards:
		return
	placed_cards.erase(dragged_card)
	organize_cards()

func organize_cards():
	var total_width: float = $CollisionShape2D.shape.size.x
	var left_edge: float = global_position.x - total_width / 2
	
	var i: int = 0
	
	if placed_cards.is_empty():
		return
		
	for placed_card in placed_cards:
		placed_card.global_position = Vector2(left_edge + card_width * i + padding, global_position.y)
		i += 1
