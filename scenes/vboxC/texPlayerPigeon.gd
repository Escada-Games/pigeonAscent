extends TextureRect
func _ready():global.connect("PlayerEvolved",self,'changeTexture')
func changeTexture():self.texture=load(global.pigeonDict[global.player["class"]].sprite)
