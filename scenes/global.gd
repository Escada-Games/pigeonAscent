extends Node

var player={
	"name":"Pombo",
	"gold":300,
	"hp":10,"maxHp":10,
	"energy":10,"maxEnergy":10,
	"pointsLeft":30,
	"strength":1,
	"defense":1,
	"speed":1.0
}

var enemy={
	"name":"Pombo",
	"gold":300,
	"hp":10,"maxHp":10,
	"energy":10,"maxEnergy":10,
	"pointsLeft":3,
	"strength":1,
	"defense":1,
	"speed":1.0
}

var level=1

var scaling={
	"strength":1.2,
	"defense":1,
	"speed":33,
	"hp":5,
	"food":2
}

func calculateHp(strength,defense):
	strength-=1
	defense-=1
	return 10+self.scaling.hp*(strength+2*defense)
func calculateFood(strength,speed):
	strength-=1
	speed-=1
	return 10+self.scaling.food*(strength+2*speed)
func updatePlayerHp():
	var oldMaxHp=self.player.maxHp
	self.player.maxHp=calculateHp(self.player.strength,self.player.defense)
	self.player.hp=(self.player.hp/oldMaxHp)*self.player.maxHp
func updatePlayerFood():
	var oldMaxEnergy=self.player.maxEnergy
	self.player.maxEnergy=calculateFood(self.player.strength,self.player.speed)
	self.player.energy=self.player.energy*self.player.maxEnergy/oldMaxEnergy
func updatePlayerHpAndFood():
	self.updatePlayerHp()
	self.updatePlayerFood()
var currentUpgrade
var shopDescription
var opponents=preload("res://scenes/opponentPanel.tscn")
var battleScene=preload("res://scenes/battleScene.tscn")
func _ready():set_process(true)
func _process(delta):
	print(String(self.player.hp)+"/"+String(self.player.maxHp))
	OS.set_window_title("Pigeon Ascent -- " + String(Engine.get_frames_per_second()) + "FPS")
func fight():
	get_tree().root.add_child(opponents.instance())
func battle(nextEnemyDict):
	self.enemy=nextEnemyDict
	var i=battleScene.instance()
	get_tree().root.add_child(i)

var listOfNames=[
	"Rick Jim",
	"Sucraiso",
	"Drachydios",
	"Boon Obatsug",
	"Delta Chave",
	"Clyde",
	"Chaos",
	"Master P.",
	"B.O.B.",
	"G-Pots",
	"Bonnie",
	"Discordia",
	"Cocoa",
	"Gaia",
	"Steve",
	"Recks Finkel",
	"Andreas",
	"Gabs",
	"Arkansas",
	"Sabin",
	"Ladder",
	"Allllan",
	"Tobias",
	"Funke",
	"Fleetwood"
]
