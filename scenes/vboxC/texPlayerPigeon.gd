extends TextureRect
func _ready():
	var _v1=global.connect("PlayerEvolved",self,'changeTexture')
func changeTexture():self.texture=load(global.pigeonDict[global.player["class"]].sprite)
