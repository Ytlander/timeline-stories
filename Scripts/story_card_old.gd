extends Node2D

@export var click_to_drop: bool = false

@export var selected: bool = false
var lerp_speed: int = 25

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):
		select_and_deselect()
	
	#Click to pick up, click to drop
	#if click_to_drop:
		#if Input.is_action_just_pressed("left_click"):
			#if selected == false:
				#selected = true
			#elif selected == true:
				#selected = false
	#Click and hold to drag and and release to drop
	#if click_to_drop == false:
		#if Input.is_action_pressed("left_click"):
			#selected = true

func select_and_deselect():
	if click_to_drop:
		if click_to_drop:
			if selected:
				selected = false
			else:
				for node in get_tree().get_nodes_in_group("story_card"):
					node.selected = false
					
				self.selected = true
				
	if !click_to_drop:
		for node in get_tree().get_nodes_in_group("story_card"):
			node.selected = false
			
		self.selected = true
		
func _physics_process(delta):
	if selected:
		self.global_position = lerp(self.global_position, get_global_mouse_position(), lerp_speed * delta)
		#Click and hold functionality
		if click_to_drop == false:
			if Input.is_action_just_released("left_click"):
				selected = false
