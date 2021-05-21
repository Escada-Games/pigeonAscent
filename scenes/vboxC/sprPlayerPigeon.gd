extends Sprite
func _ready():
	global.connect("PlayerEvolved",self,'changeTexture')
func changeTexture():
#	self.position.y-=10
	self.scale*=Vector2(1.2,1.2)
	self.texture=load(global.pigeonDict[global.player["class"]].sprite)
