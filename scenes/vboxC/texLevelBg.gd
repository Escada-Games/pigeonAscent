extends TextureRect
const textureNormal:=preload("res://resource/Tunnel.png")
const textureGod:=preload("res://resource/Boss_Board.png")
func _ready() -> void:
	set_process(true)
func _process(_delta:float) -> void:
	if global.level==10:
		self.texture=textureGod
	else:
		self.texture=textureNormal
