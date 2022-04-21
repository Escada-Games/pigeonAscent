extends ReactiveTextureButton
func ready():
	var _s1=self.connect("pressed",global,"fight")
	var _s2=self.connect("mouse_entered",global,"createHoverSfx")
	var _s3=self.connect("button_down",global,"createSelectSfx")
