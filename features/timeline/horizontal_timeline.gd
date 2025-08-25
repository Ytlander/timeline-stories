class_name HorizontalTimeline
extends Node2D

@export var card_width: float = 150
@export var spacing: float = 8
@export var left_bound: Node2D
@export var right_bound: Node2D
@export var tween_speed: float = 0.2

var cards: Array[Node2D] = []
var tween_running: bool = false

func _process(_delta: float) -> void:
	# Toggle visibility depending on bounds
	for card in cards:
		card.visible = (
			card.global_position.x >= left_bound.global_position.x - 150
			and card.global_position.x <= right_bound.global_position.x + 150
		)

func place_card(card: Node2D, index: int = -1) -> void:
	if index < 0 or index > cards.size():
		index = cards.size()
	
	cards.insert(index, card)
	_realign_cards()

func remove_card(card: Node2D) -> void:
	if card in cards:
		cards.erase(card)
		_realign_cards()

func move_left() -> void:
	if cards.is_empty():
		return
	if cards.back().global_position.x <= right_bound.global_position.x:
	#if cards.back().position.x - card_width < left_bound.position.x:
		print("Can't scroll further left")
		return
	_shift(-1)

func move_right() -> void:
	if cards.is_empty():
		return
	if cards.front().global_position.x >= left_bound.global_position.x:
	#if cards.front().position.x > right_bound.position.x:
		print("Can't scroll further right")
		return
	_shift(1)

func _realign_cards() -> void:
	if cards.is_empty():
		return
		
	var x = left_bound.global_position.x
	
	for card in cards:
		card.z_index = 0
		card.global_position = Vector2(x, global_position.y)
		x += card_width + spacing

func _shift(dir: int) -> void:
	if tween_running:
		return
	tween_running = true
	var delta_x = card_width * dir
	var tweens: Array[Tween] = []
	for card in cards:
		var tween = create_tween()
		tween.tween_property(card, "global_position", card.global_position + Vector2(delta_x, 0), tween_speed)
		tweens.append(tween)
	
	tweens.back().finished.connect(func(): tween_running = false)
