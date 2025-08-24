class_name HorizontalTimeline
extends Node

@export var width_of_the_things: float
@export var how_far_apart: float
@export var position_of_first_thing: Node2D
@export var position_of_last_thing: Node2D


var all_the_things: Array
var max_visible_x
var min_visible_x

func _ready() -> void:
	max_visible_x = position_of_last_thing.global_position.x + how_far_apart + width_of_the_things
	min_visible_x = position_of_first_thing.global_position.x - how_far_apart - width_of_the_things
	
func _process(delta: float) -> void:
	for thing in all_the_things:
		thing.visible = (thing.global_position.x >= min_visible_x and thing.global_position.x <= max_visible_x)

func place_thing(thing, index: int = 0):
	if all_the_things.is_empty():
		thing.global_position = position_of_first_thing.global_position
	else:
		for i in range(index, all_the_things.size()):
			all_the_things[i].global_position = all_the_things[i].global_position + Vector2(width_of_the_things + how_far_apart, 0)
		thing.global_position = all_the_things[index - 1].global_position + Vector2(width_of_the_things + how_far_apart, 0)
	all_the_things.insert(index, thing)
	
func remove_thing(thing):
	if thing in all_the_things:
		all_the_things.erase(thing)

func move_things_left():
	if all_the_things.is_empty():
		return
	if all_the_things.back().global_position.x <= position_of_first_thing.global_position.x:
		print("Can't scroll further to the left yo")
		return
	for thing in all_the_things:
		var target_pos_x = thing.global_position.x - width_of_the_things - how_far_apart
		var tween = create_tween()
		tween.tween_property(thing, "global_position", Vector2(target_pos_x, thing.global_position.y), 0.5)
		
func move_things_right():
	if all_the_things.is_empty():
		return
	if all_the_things.front().global_position.x >= position_of_last_thing.global_position.x:
		print("Can't scroll further to the right yo")
		return
	for thing in all_the_things:
		var target_pos_x = thing.global_position.x + width_of_the_things + how_far_apart
		var tween = create_tween()
		tween.tween_property(thing, "global_position", Vector2(target_pos_x, thing.global_position.y), 0.5)
