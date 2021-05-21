extends TextureButton
func _ready():
	self.connect("pressed",global,"fight")
	self.connect("mouse_entered",global,"createHoverSfx")
	self.connect("button_down",global,"createSelectSfx")
