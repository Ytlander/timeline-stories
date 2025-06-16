extends Area2D

var selected: bool = false
var lerp_speed: int = 25

func _on_input_event(viewport, event, shape_idx):
	#Click to pick up, click to drop
	#if Input.is_action_just_pressed("left_click"):
		#if selected == false:
			#selected = true
		#elif selected == true:
			#selected = false
	#Click and hold to drag and and release to drop
	if Input.is_action_pressed("left_click"):
		selected = true

		
func _physics_process(delta):
	if selected:
		self.global_position = lerp(self.global_position, get_global_mouse_position(), lerp_speed * delta)
		#Click and hold functionality
		if Input.is_action_just_released("left_click"):
			selected = false
