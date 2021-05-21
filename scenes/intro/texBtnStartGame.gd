extends TextureButton

func _ready():
	global.player={
		"name":"Pombo",
		"gold":100,
		"hp":5,"maxHp":5,
		"energy":10,"maxEnergy":10,
		"pointsLeft":5,
		"strength":1,"extraStrength":0,
		"defense":1,"extraDefense":0,
		"speed":1,"extraSpeed":0,
		"class":global.Classes.Normal
	}
	global.level=1
	var _s1=self.connect("pressed",self,"startGame")
	var _s2=self.connect("mouse_entered",global,"createHoverSfx")
func startGame():
	global.player.name=get_parent().get_node("lineEdit").text
	global.addMusicPartyCrasher()
	var _sc1=get_tree().change_scene("res://scenes/root.tscn")
