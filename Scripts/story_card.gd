extends Area2D

var selected: bool = false

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):
		if selected == false:
			selected = true
		elif selected == true:
			selected = false
		
func _physics_process(delta):
	if selected:
		self.global_position = lerp(self.global_position, get_global_mouse_position(), 25 * delta)
