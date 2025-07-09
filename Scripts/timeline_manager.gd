extends Node2D

@export var slot_spacing: int = 150
@export var max_slots: int = 4
@export var slot_start_pos: Vector2 = Vector2(100, 600)
@export var slot_size: Vector2 = Vector2(110, 180)

var slots: Array = []
var occupied: Array = []

func _ready() -> void:
	create_slots()
		
func try_place_card(card: Area2D):
	var local_mouse_pos = to_local(get_global_mouse_position())
	
	var closest_slot: int = 0
	var min_distance = INF
	
	# Determine closest slot
	for i in range (slots.size()):
		var dist = slots[i].distance_to(local_mouse_pos)
		if dist < min_distance:
			min_distance = dist
			closest_slot = i
	
	# Place card if room, else try to shift already placed card 
	if occupied[closest_slot] == null:
		place_card_in_slot(card, closest_slot)
	else:
		var shifted = try_shift_and_place(card, closest_slot)
		if not shifted:
			print("No room to place card")
			
func place_card_in_slot(card: Area2D, slot: int):
	card.global_position = to_global(slots[slot])
	occupied[slot] = card
	
func try_shift_and_place(card: Area2D, slot: int):
	# Right
	for i in range (slot + 1, max_slots):
		if occupied[i] == null:
			for j in range (i, slot, -1):
				move_card_to_slot(occupied[j - 1], j)
				place_card_in_slot(card, slot)
				return true
				
	# Left
	for i in range (slot - 1, -1, -1):
		if occupied[i] == null:
			for j in range (i, slot):
				move_card_to_slot(occupied[j + 1], j)
				place_card_in_slot(card, slot)
				return true
	
	# If no room
	return false
				
func move_card_to_slot(card: Area2D, slot: int):
	if card == null:
		return
	card.global_position = to_global(slots[slot])
	if card.has_meta("slot_index"):
		var old_index = card.get_meta("slot_index")
		occupied[old_index] = null
	occupied[slot] = card
	card.set_meta("slot_index", slot)
	
func remove_card(card: Area2D):
	if card.has_meta("slot_index"):
		var index = card.get_meta("slot_index")
		if occupied[index] == card:
			occupied[index] = null
			card.set_meta("slot_index", null)

func create_slots():
	for i in range(max_slots):
		var slot = ColorRect.new()
		slot.color = Color(1, 1, 1, 0.1)
		slot.size = slot_size
		slot.position = slot_start_pos + Vector2(i * slot_spacing, 0)
		slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		add_child(slot)
		slots.append(slot.global_position)
		occupied.append(null)
