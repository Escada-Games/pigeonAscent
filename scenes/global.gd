extends Node

var pigeonClassesAndSprites={
	"baker":
		{"sprite":"res://resource/sprites/Baker_Pigeon.png",
		"portrait":"res://resource/portraits/Baker_Pigeon_Port.png"
	},
	"batPigeon":
		{"sprite":"res://resource/sprites/BatPigeon.png",
		"portrait":"res://resource/portraits/BatPigeon_Port.png"
	},
	"charlie":
		{"sprite":"res://resource/sprites/Charlie_Pigeon.png",
		"portrait":"res://resource/portraits/Charlie_Pigeon_Port.png"
	},
	"crusader":
		{"sprite":"res://resource/sprites/Crusader_Pigeon.png",
		"portrait":"res://resource/portraits/Crusader_Pigeon_Port.png"
	},
	"e-girl":
		{"sprite":"res://resource/sprites/E-girl_Pigeon.png",
		"portrait":"res://resource/portraits/E-girl_Pigeon_Port.png"
	},
	"fridgeon":
		{"sprite":"res://resource/sprites/Fridgeon.png",
		"portrait":"res://resource/portraits/Fridgeon_Port.png"
	},
	"godPigeon":
		{"sprite":"res://resource/sprites/God_Pigeon.png",
		"portrait":"res://resource/portraits/God_Pigeon_Port.png"
	},
	"hatoshi":
		{"sprite":"res://resource/sprites/Hatoshi.png",
		"portrait":"res://resource/portraits/Hatoshi_Port.png"
	},
	"infiltrator":
		{"sprite":"res://resource/sprites/Infiltrator.png",
		"portrait":"res://resource/portraits/Infiltrator_Port.png"
	},
	"kawaii":
		{"sprite":"res://resource/sprites/Kawaii_Pigeon.png",
		"portrait":"res://resource/portraits/Kawaii_Pigeon_Port.png"
	},
	"knight":
		{"sprite":"res://resource/sprites/Knight_Pigeon.png",
		"portrait":"res://resource/portraits/Knight_Pigeon_Port.png"
	},
	"mimic":
		{"sprite":"res://resource/sprites/Mimic_Pigeon.png",
		"portrait":"res://resource/portraits/Mimic_Pigeon_Port.png"
	},
	"normal":
		{"sprite":"res://resource/sprites/Normal_Pigeon.png",
		"portrait":"res://resource/portraits/Normal_Pigeon_Port.png"
	},
	"PIgeon":
		{"sprite":"res://resource/sprites/PIgeon.png",
		"portrait":"res://resource/portraits/PIgeon_Port.png"
	},
	"selfie":
		{"sprite":"res://resource/sprites/Selfie_Pigeon.png",
		"portrait":"res://resource/portraits/Selfie_Pigeon_Port.png"
	},
	"sink":
		{"sprite":"res://resource/sprites/Sink_Pigeon.png",
		"portrait":"res://resource/portraits/Sink_Pigeon_Port.png"
	},
	"stronga":
		{"sprite":"res://resource/sprites/Stronga_Pigeon.png",
		"portrait":"res://resource/portraits/Stronga_Pigeon_Port.png"
	},
	"whey":
		{"sprite":"res://resource/sprites/Whey_Pigeon.png",
		"portrait":"res://resource/portraits/Whey_Pigeon_Port.png"
	},
	"winged":
		{"sprite":"res://resource/sprites/Winged_Pigeon.png",
		"portrait":"res://resource/portraits/Winged_Pigeon_Port.png"
	},
	"winged2":
		{"sprite":"res://resource/sprites/Winged_Pigeon_With_Wings.png",
		"portrait":"res://resource/portraits/Winged_Pigeon_With_Wings_Port.png"
	},
	"wizard":
		{"sprite":"res://resource/sprites/Wizard_Pigeon.png",
		"portrait":"res://resource/portraits/Wizard_Pigeon_Port.png"
	},
	"wyrm":
		{"sprite":"res://resource/sprites/Wrym_Pigeon.png",
		"portrait":"res://resource/portraits/Wrym_Pigeon_Port.png"
	},
	"platy":
		{"sprite":"res://resource/sprites/Platypigeon.png",
		"portrait":"res://resource/portraits/Selfie_Pigeon_Port.png"
	}
}

var c_baker="baker"
var c_batPigeon="batPigeon"
var c_charlie="charlie"
var c_crusader="crusader"
var c_egirl="e-girl"
var c_fridgeon="fridgeon"
var c_godPigeon="godPigeon"
var c_hatoshi="hatoshi"
var c_infiltrator="infiltrator"
var c_kawaii="kawaii"
var c_knight="knight"
var c_mimic="mimic"
var c_normal="normal"
var c_PIgeon="PIgeon"
var c_selfie="selfie"
var c_sink="sink"
var c_stronga="stronga"
var c_whey="whey"
var c_winged="winged"
var c_winged2="winged2"
var c_wizard="wizard"
var c_wyrm="wyrm"
var c_platy="platy"

var commonEnemyPigeons=[
	self.c_baker,
	self.c_charlie,
	self.c_egirl,
	self.c_wizard,
	self.c_kawaii,
	self.c_selfie,
	self.c_sink,
	self.c_wizard,
	self.c_normal
]

var firstEvoPigeons=[
	self.c_winged,
	self.c_PIgeon,
	self.c_stronga,
	self.c_knight,
	self.c_platy
]

var secondEvoPigeons=[
	self.c_winged2,
	self.c_hatoshi,
	self.c_whey,
	self.c_wyrm,
	self.c_crusader,
	self.c_fridgeon,
	self.c_batPigeon
]

var uncommonEvoPigeons=[
	self.c_hatoshi,
	self.c_wyrm,
	self.c_fridgeon,
	self.c_batPigeon
]



var player={
	"name":"Pombo",
	"gold":0,
	"hp":10,"maxHp":10,
	"energy":10,"maxEnergy":10,
	"pointsLeft":3,
	"strength":50,"extraStrength":0,
	"defense":1,"extraDefense":0,
	"speed":1,"extraSpeed":0,
	"class":self.c_normal
}
var hasWings=false
var hasIce=false
var hasSword=true
var enemy={
	"name":"PomboEnemy",
	"gold":100,
	"hp":10,"maxHp":10,
	"energy":10,"maxEnergy":10,
	"pointsLeft":3,
	"strength":1,
	"defense":1,
	"speed":1.0,
	"class":"normal"
}

var level=3

var scaling={
	"strength":1.2,
	"defense":1,
	"speed":30,#33
	"hp":5,
	"food":2
}
var currentItem
var evolvePanel=preload("res://scenes/evolvePannel.tscn")
func createEvolvePanel():
	get_tree().root.get_node("/root/root").add_child(evolvePanel.instance())
func firstEvolution():
	if self.player.strength>self.player.defense and self.player.strength>self.player.speed:
		self.player["class"]=self.c_stronga
	elif self.player.defense>self.player.strength and self.player.defense>self.player.speed:
		self.player["class"]=self.c_knight
	elif self.player.speed>self.player.strength and self.player.speed>self.player.defense:
		self.player["class"]=self.c_winged
	else:
		self.player["class"]=self.c_platy
func secondEvolution():
	if self.player["class"]==self.c_stronga:
		self.player["class"]=self.c_wyrm if self.hasWings else self.c_whey
	elif self.player["class"]==self.c_knight:
		self.player["class"]=self.c_fridgeon if self.hasIce else self.c_crusader
	if self.player["class"]==self.c_winged:
		self.player["class"]=self.c_hatoshi if self.hasSword else self.c_winged2
	else:
		self.player["class"]=self.c_platy
var hoverSfx=preload("res://scenes/polish/hoverSfx.tscn")
var selectSfx=preload("res://scenes/polish/selectSfx.tscn")
func createHoverSfx():
	add_child(hoverSfx.instance())
func createSelectSfx():
	add_child(selectSfx.instance())
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
	self.player.hp=int((1.0*self.player.hp/oldMaxHp)*1.0*self.player.maxHp)
func updatePlayerFood():
	var oldMaxEnergy=self.player.maxEnergy
	self.player.maxEnergy=calculateFood(self.player.strength,self.player.speed)
	self.player.energy=int(1.0*self.player.energy*self.player.maxEnergy/oldMaxEnergy)
func updatePlayerHpAndFood():
	self.updatePlayerHp()
	self.updatePlayerFood()
var currentUpgrade
var shopDescription
var opponents=preload("res://scenes/opponentPanel.tscn")
var battleScene=preload("res://scenes/battleScene.tscn")
func _ready():set_process(true)
func _process(delta):
	pass
#	OS.set_window_title("Pigeon Ascent -- " + String(Engine.get_frames_per_second()) + "FPS")
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
	"Ladder",
	"Allllan",
	"Tobias",
	"Funke",
	"Fleetwood",
	"Big Pedro", 
	"Uncle Sam",
	"Ice Head",
	"Adam Carl",
	"Narcejo",
	"Prupru",
	"Mayoral",
	"Solino",
	"Papagalo",
	"Shuri",
	"Gustavo",
	"Piombo",
	"Mizuni",
	"Pericles",
	"Angry Pigeon",
	"CJ",
	"Dr.P.Ombo",
	"Astera",
	"Pigeon Gates",
	"Mark Pigeonberg",
	"Pigeon Crews",
	"Robert Pigeon Jr.",
	"Scarlet Pigeoson",
	"Peewee",
	"Gordon Pigeon",
	"Pigeonvanni",
	"DIO",
	"JOTARO",
	"Geralt of Osasco",
	"Noegip",
]
