extends TextureRect
const textureNormal=preload("res://resource/Tunnel.png")
const textureGod=preload("res://resource/Boss_Board.png")
func _ready():set_process(true)
func _process(_delta):
	if global.level==10:
		self.texture=textureGod
	else:
		self.texture=textureNormal
