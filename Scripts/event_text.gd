extends PanelContainer

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if self.visible == false:
			self.visible = true
		else:
			self.visible = false
