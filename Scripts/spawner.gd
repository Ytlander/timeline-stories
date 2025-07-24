extends Node



@export var batch_1: Array[PackedScene]
@export var batch_2: Array[PackedScene]
@export var batch_3: Array[PackedScene]
@export var batch_4: Array[PackedScene]
@export var batch_5: Array[PackedScene]
@export var batch_6: Array[PackedScene]

var batch_array: Array[Array]

var spawn_position_array: Array[Node2D]

@onready var spawn_position = $SpawnPosition
@onready var spawn_position_2 = $SpawnPosition2
@onready var spawn_position_3 = $SpawnPosition3
@onready var spawn_position_4 = $SpawnPosition4


func _ready():
	EventBus.validate_successful.connect(_on_validate_successful)
	batch_array = [batch_1, batch_2, batch_3, batch_4, batch_5, batch_6]
	spawn_position_array = [spawn_position, spawn_position_2, spawn_position_3, spawn_position_4]
	
func _on_validate_successful(batch_to_spawn):
	var current_batch = batch_array[batch_to_spawn]
	var card_number = 0
	for packed_card in current_batch:
		var card = packed_card.instantiate()
		self.add_child(card)
		card.global_position = spawn_position_array[card_number].global_position
		card_number += 1
