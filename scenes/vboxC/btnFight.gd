extends TextureButton
func _ready():
	var _v1=self.connect("pressed",global,"fight")
	var _v2=self.connect("mouse_entered",global,"createHoverSfx")
	var _v3=self.connect("button_down",global,"createSelectSfx")
