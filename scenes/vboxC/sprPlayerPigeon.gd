extends Sprite
func _ready():
	var _v1=global.connect("PlayerEvolved",self,'changeTexture')
	var _v2=global.connect("PlayerStatsUpdated",self,'growABit')
func growABit() -> void:
	self.scale*=Vector2(1.02,1.02)
	pass
func changeTexture() -> void:
#	self.position.y-=10
	self.scale*=Vector2(1.1,1.1)
	self.texture=load(global.pigeonDict[global.player["class"]].sprite)
