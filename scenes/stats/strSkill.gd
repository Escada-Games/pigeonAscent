extends Label
var bIsPlayerStats:=false
func _ready():set_process(true)
func _process(delta):
	if bIsPlayerStats:
		self.text=global.pigeonDict[global.player['class']]['skill']
		self.hint_tooltip=global.pigeonDict[global.player['class']]['skillDescription']
	else:
		self.text=global.pigeonDict[global.enemy['class']]['skill']
		self.hint_tooltip=global.pigeonDict[global.enemy['class']]['skillDescription']
