extends Node
const rerollPrice=100
const defaultResolution=Vector2(1024,600)

const phrases=[
	"Yo mamma so fat she's a duck",
	"I've seem squirrels fly better than you",
	"I bet you're bad even at delivering letters",
	"How do you even managed to get in the game?",
	"I think you have two left wings mate",
	"...have I seen you before?",
	"You were expecting Dio, but it's me!",
	"FYI, my grandgrandfather was a dragon.",
	"You reek of birdseed, eugh",
	"Just give up, I'm four parallel universes ahead of you right now.",
	"You don't want to see me use my Ultra Instinct.",
	"Get ready for my Gear Second!",
	"Beware: I learned to fight by watching anime.",
	""
]

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
		{"sprite":"res://resource/sprites/God_Pigeon_Mirrored.png",
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
	"gold":100,
	"hp":5,"maxHp":5,
	"energy":10,"maxEnergy":10,
	"pointsLeft":5,#3,
	"strength":1,"extraStrength":0,
	"defense":1,"extraDefense":0,
	"speed":1,"extraSpeed":0,
	"class":self.c_normal
}
var hasWings=false
var hasIce=false
var hasSword=false
var enemy={
	"name":"PomboEnemy",
	"gold":100,
	"hp":5,"maxHp":5,
	"energy":10,"maxEnergy":10,
	"pointsLeft":3,
	"strength":1,
	"defense":0,
	"speed":1.0,
	"class":"normal"
}

var level=1
var rerolls=1
var scaling={
	"strength":1.12,
	"defense":1,
	"speed":64,#64,#30,#33
	"hp":1,
	"food":2,
	"foodDamage":0.5,
	"defenseBlock":0.5
}
var limits={
	"defense":30
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
	elif self.player["class"]==self.c_winged:
		self.player["class"]=self.c_hatoshi if self.hasSword else self.c_winged2
var hoverSfx=preload("res://scenes/polish/hoverSfx.tscn")
var selectSfx=preload("res://scenes/polish/selectSfx.tscn")
var clickUnableSfx=preload("res://scenes/polish/clickUnableSfx.tscn")
func createClickUnableSfx():
	add_child(clickUnableSfx.instance())
func createHoverSfx():
	add_child(hoverSfx.instance())
func createSelectSfx(type=""):
	var i=selectSfx.instance()
	var pitchIncrement=0.0
	if type=="":pass
	elif type=="attack":pitchIncrement=self.player.strength/75.0
	elif type=="defense":pitchIncrement=self.player.defense/75.0
	elif type=="speed":pitchIncrement=self.player.speed/75.0
	i.pitch_scale+=pitchIncrement
	add_child(i)
func calculateHp(strength,defense):
	strength-=1;defense-=1
	return 5+self.scaling.hp*(strength+2*defense)
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
func isGameCompact():return OS.window_size.x<OS.min_window_size.y
func shouldIBeVisible(node):node.visible=node.get_viewport_rect().size.x>OS.min_window_size.y
func shouldIBeInvisible(node):node.visible=node.get_viewport_rect().size.x<OS.min_window_size.y
const resolution=Vector2(16,9)
var currentUpgrade
var shopDescription
var opponents=preload("res://scenes/opponentPanel.tscn")
var battleScene=preload("res://scenes/battleScene.tscn")
var battleSceneNew=preload("res://scenes/battleSceneNew.tscn")
var music=preload("res://scenes/music.tscn")
var enemiesForBattle=[]
func _ready():
	OS.min_window_size=Vector2(360,640)
	if not OS.is_debug_build():add_child(music.instance())
	set_process(true)
var muted=false
func _process(_delta):
#	print_debug(global.enemiesForBattle.size())
	player.energy=max(player.energy,0)
	if Input.is_action_just_pressed("ui_debug"):
		debugInput()
	if Input.is_action_just_pressed("ui_mute"):
		muted=!muted
		AudioServer.set_bus_mute(0,muted)
#	OS.set_window_title("Pigeon Ascent -- " + String(Engine.get_frames_per_second()) + "FPS")
func fight(doTween=true):
	var i=opponents.instance()
	i.get_node("marginContainer/opponentPanel").doTween=doTween
	get_tree().root.add_child(i)
func battle(nextEnemyDict):
	enemiesForBattle=[]
	self.enemy=nextEnemyDict
	var i=battleSceneNew.instance()
	get_tree().root.add_child(i)
func debugInput():
	if not OS.has_feature("standalone"): #if OS.is_debug_build()...
		global.player.pointsLeft+=10
		global.level=int(clamp(global.level+1,0,10))
		global.player.gold+=1000

func getBgTexture():
	var playerClass=global.player["class"]
	var newTexture
	if playerClass==global.c_normal:newTexture=load("res://resource/BG_Stats_N1.png")
	elif playerClass==global.c_platy:newTexture=load("res://resource/BG_Stats_N2.png")
	elif playerClass==global.c_stronga:newTexture=load("res://resource/BG_Stats_R1.png")
	elif playerClass==global.c_whey:newTexture=load("res://resource/BG_Stats_R2.png")
	elif playerClass==global.c_wyrm:newTexture=load("res://resource/BG_Stats_R3.png")
	elif playerClass==global.c_knight:newTexture=load("res://resource/BG_Stats_B1.png")
	elif playerClass==global.c_crusader:newTexture=load("res://resource/BG_Stats_B2.png")
	elif playerClass==global.c_fridgeon:newTexture=load("res://resource/BG_Stats_B3.png")
	elif playerClass==global.c_winged:newTexture=load("res://resource/BG_Stats_G1.png")
	elif playerClass==global.c_winged2:newTexture=load("res://resource/BG_Stats_G2.png")
	elif playerClass==global.c_hatoshi:newTexture=load("res://resource/BG_Stats_G3.png")
	return newTexture
	
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
