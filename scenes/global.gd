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
	"I wonder if you can carry a coconut till you reach England!",
	"Even a turtle would beat you up"
]

# Player items
var hasWings=false
var hasIce=false
var hasSword=false
# Classes enum
enum Classes{
	Baker,
	Bat,
	Charlie,
	Crusader,
	Egirl,
	Fridgeon,
	GodPigeon,
	Hatoshi,
	Infiltrator,
	Kawaii,
	Knight,
	Mimic,
	Normal,
	PIgeon,
	Selfie,
	Sink,
	Stronga,
	Whey,
	Winged,
	Winged2,
	Wizard,
	Wyrm,
	Platy,
}
var nCurrentMusic:AudioStreamPlayer
#const pigeonClassesAndSprites={
const pigeonDict={
	Classes.Baker:
		{"sprite":"res://resource/sprites/Baker_Pigeon.png",
		"portrait":"res://resource/portraits/Baker_Pigeon_Port.png",
		'skill':'Bread baking',
		'skillDescription':'Loved both by pigeons and ducks'
	},
	Classes.Bat:
		{"sprite":"res://resource/sprites/BatPigeon.png",
		"portrait":"res://resource/portraits/BatPigeon_Port.png",
		'skill':'Blood sucker',
		'skillDescription':'Not a sucker, but sucks blood'
	},
	Classes.Charlie:
		{"sprite":"res://resource/sprites/Charlie_Pigeon.png",
		"portrait":"res://resource/portraits/Charlie_Pigeon_Port.png",
		'skill':'Sk8 4 l1fe',
		'skillDescription':'High speed rolling'
	},
	Classes.Crusader:
		{"sprite":"res://resource/sprites/Crusader_Pigeon.png",
		"portrait":"res://resource/portraits/Crusader_Pigeon_Port.png",
		'skill':'Pigod VULT',
		'skillDescription':'Nothing can stop it\'s quest for Pigeoralem'
	},
	Classes.Egirl:
		{"sprite":"res://resource/sprites/E-girl_Pigeon.png",
		"portrait":"res://resource/portraits/E-girl_Pigeon_Port.png",
		'skill':'Support from the fans',
		'skillDescription':'"Hey, thanks for the superchat, anonymous!"'
	},
	Classes.Fridgeon:
		{"sprite":"res://resource/sprites/Fridgeon.png",
		"portrait":"res://resource/portraits/Fridgeon_Port.png",
		'skill':'The cold shoulder',
		'skillDescription':'Its insides are also cold as ice'
	},
	Classes.GodPigeon:
		{"sprite":"res://resource/sprites/God_Pigeon_Mirrored.png",
		"portrait":"res://resource/portraits/God_Pigeon_Port.png",
		'skill':'Ascended',
		'skillDescription':'Can you reject another pigeon?'
	},
	Classes.Mimic:
		{"sprite":"res://resource/sprites/God_Pigeon_Mirrored.png",
		"portrait":"res://resource/portraits/God_Pigeon_Port.png",
		'skill':'Ditto you',
		'skillDescription':'Could it be you were the reflection all along?'
	},
	Classes.Hatoshi:
		{"sprite":"res://resource/sprites/Hatoshi.png",
		"portrait":"res://resource/portraits/Hatoshi_Port.png",
		'skill':'Ancient arts',
		'skillDescription':'Better not be in the path of its blade'
	},
	Classes.Infiltrator:
		{"sprite":"res://resource/sprites/Infiltrator.png",
		"portrait":"res://resource/portraits/Infiltrator_Port.png",
		'skill':'Honk for Chen',
		'skillDescription':'Go for the rake in the lake'
	},
	Classes.Kawaii:
		{"sprite":"res://resource/sprites/Kawaii_Pigeon.png",
		"portrait":"res://resource/portraits/Kawaii_Pigeon_Port.png",
		'skill':'Anime eyes',
		'skillDescription':'With those big eyes, seeing attacks is easier'
	},
	Classes.Knight:
		{"sprite":"res://resource/sprites/Knight_Pigeon.png",
		"portrait":"res://resource/portraits/Knight_Pigeon_Port.png",
		'skill':'Magic wall',
		'skillDescription':'Adevo grav tera'
	},
#	Classes.Mimic:
#		{"sprite":"res://resource/sprites/Mimic_Pigeon.png",
#		"portrait":"res://resource/portraits/Mimic_Pigeon_Port.png",
#
#	},
	Classes.Normal:
		{"sprite":"res://resource/sprites/Normal_Pigeon.png",
		"portrait":"res://resource/portraits/Normal_Pigeon_Port.png",
		'skill':'City survivor',
		'skillDescription':'This skill protects the pigeon from critical hits.'
	},
	Classes.PIgeon:
		{"sprite":"res://resource/sprites/PIgeon.png",
		"portrait":"res://resource/portraits/PIgeon_Port.png",
		'skill':'Irrational till the end',
		'skillDescription':'About 22/7 with great precision'
	},
	Classes.Selfie:
		{"sprite":"res://resource/sprites/Selfie_Pigeon.png",
		"portrait":"res://resource/portraits/Selfie_Pigeon_Port.png",
		'skill':'Memory creator',
		'skillDescription':'Be sure to not run out on space on your device'
	},
	Classes.Sink:
		{"sprite":"res://resource/sprites/Sink_Pigeon.png",
		"portrait":"res://resource/portraits/Sink_Pigeon_Port.png",
		'skill':'This is draining me',
		'skillDescription':'Some losses are inevitable'
	},
	Classes.Stronga:
		{"sprite":"res://resource/sprites/Stronga_Pigeon.png",
		"portrait":"res://resource/portraits/Stronga_Pigeon_Port.png",
		'skill':'The strongest survives',
		'skillDescription':'Well, actually the most adaptable survives...'
	},
	Classes.Whey:
		{"sprite":"res://resource/sprites/Whey_Pigeon.png",
		"portrait":"res://resource/portraits/Whey_Pigeon_Port.png",
		'skill':'BIRL',
		'skillDescription':'Be strong IRL too'
	},
	Classes.Winged:
		{"sprite":"res://resource/sprites/Winged_Pigeon.png",
		"portrait":"res://resource/portraits/Winged_Pigeon_Port.png",
		'skill':'Winged creature',
		'skillDescription':'More wings = better flight'
	},
	Classes.Winged2:
		{"sprite":"res://resource/sprites/Winged_Pigeon_With_Wings.png",
		"portrait":"res://resource/portraits/Winged_Pigeon_With_Wings_Port.png",
		'skill':'Winged wings',
		'skillDescription':'Wings with wings = even better flight somehow'
	},
	Classes.Wizard:
		{"sprite":"res://resource/sprites/Wizard_Pigeon.png",
		"portrait":"res://resource/portraits/Wizard_Pigeon_Port.png",
		'skill':'"You are a wizard"',
		'skillDescription':'This pigeon\'s dream was to be named Tim'
	},
	Classes.Wyrm:
		{"sprite":"res://resource/sprites/Wrym_Pigeon.png",
		"portrait":"res://resource/portraits/Wrym_Pigeon_Port.png",
		'skill':'Mythical dragon creature',
		'skillDescription':'Dragons are actually quite small'
	},
	Classes.Platy:
		{"sprite":"res://resource/sprites/Platypigeon.png",
		"portrait":"res://resource/portraits/Selfie_Pigeon_Port.png",
		'skill':'Trade of all jacks',
		'skillDescription':'Master of all jacks too, idk'
	},
}

var commonEnemyPigeons=[
	self.Classes.Baker,
	self.Classes.Charlie,
	self.Classes.Egirl,
	self.Classes.Wizard,
	self.Classes.Kawaii,
	self.Classes.Selfie,
	self.Classes.Sink,
	self.Classes.Wizard,
	self.Classes.Normal,
	self.Classes.Infiltrator,
	self.Classes.PIgeon
]

var firstEvoPigeons=[
	self.Classes.Winged,
	self.Classes.PIgeon,
	self.Classes.Stronga,
	self.Classes.Knight,
	self.Classes.Platy
]

var secondEvoPigeons=[
	self.Classes.Winged2,
	self.Classes.Hatoshi,
	self.Classes.Whey,
	self.Classes.Wyrm,
	self.Classes.Crusader,
	self.Classes.Fridgeon,
	self.Classes.Bat
]

var uncommonEvoPigeons=[
	self.Classes.Hatoshi,
	self.Classes.Wyrm,
	self.Classes.Fridgeon,
	self.Classes.Bat
]

# Player pigeon object
var player={
	"name":"Pombo",
	"gold":100,
	"hp":5,"maxHp":5,
	"energy":10,"maxEnergy":10,
	"pointsLeft":5,#3,
	"strength":1,"extraStrength":0,
	"defense":1,"extraDefense":0,
	"speed":1,"extraSpeed":0,
	"class":self.Classes.Normal
}
# Current enemy object
var enemy={
	"name":"PomboEnemy",
	"gold":100,
	"hp":5,"maxHp":5,
	"energy":10,"maxEnergy":10,
	"pointsLeft":3,
	"strength":1,"extraStrength":0,
	"defense":0,"extraDefense":0,
	"speed":1.0,"extraSpeed":0,
	"class":self.Classes.Normal
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
const evolvePanel:=preload("res://scenes/evolvePannel.tscn")
const musicEvolution:=preload("res://scenes/musics/musicEvolution.tscn")
signal PlayerEvolved
func createEvolvePanel():
	get_tree().root.get_node("/root/root").add_child(evolvePanel.instance())
func addEvolutionMusic():
	pass
func firstEvolution():
	if self.player.strength>self.player.defense and self.player.strength>self.player.speed:
		self.player["class"]=self.Classes.Stronga
	elif self.player.defense>self.player.strength and self.player.defense>self.player.speed:
		self.player["class"]=self.Classes.Knight
	elif self.player.speed>self.player.strength and self.player.speed>self.player.defense:
		self.player["class"]=self.Classes.Winged
	else:
		self.player["class"]=self.Classes.Platy
	emit_signal("PlayerEvolved")
	add_child(musicEvolution.instance())
func secondEvolution():
	if self.player["class"]==self.Classes.Stronga:
		self.player["class"]=self.Classes.Wyrm if self.hasWings else self.Classes.Whey
	elif self.player["class"]==self.Classes.Knight:
		self.player["class"]=self.Classes.Fridgeon if self.hasIce else self.Classes.Crusader
	elif self.player["class"]==self.Classes.Winged:
		self.player["class"]=self.Classes.Hatoshi if self.hasSword else self.Classes.Winged2
	emit_signal("PlayerEvolved")
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
	return int(5+self.scaling.hp*(strength+2*defense))
func calculateFood(strength,speed):
	strength-=1
	speed-=1
	return int(10+self.scaling.food*(strength+2*speed))
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
const opponents=preload("res://scenes/opponentPanel.tscn")
const battleScene=preload("res://scenes/battleScene.tscn")
const battleSceneNew=preload("res://scenes/battleSceneNew.tscn")
const music:=preload("res://scenes/music.tscn")
const musicFireSword:=preload("res://scenes/musics/musicFireSword.tscn")
const musicPartyCrasher:=preload("res://scenes/musics/musicPartyCrasher.tscn")
const musicFinalBoss:=preload("res://scenes/musics/musicLastOpponent.tscn")
var enemiesForBattle=[]

func _ready():
#	if not OS.is_debug_build():
#		add_child(music.instance())
	set_process(true)
var muted=false
func addMusicPartyCrasher():
	var i:=musicPartyCrasher.instance()
	i.name='music'
	self.nCurrentMusic=i
	add_child(i)
func addMusicFireSword():
	var i:=musicFireSword.instance()
	i.name='music'
	self.nCurrentMusic=i
	add_child(i)
func addMusicLastOpponent():
	var i:=musicFinalBoss.instance()
	i.name='music'
	self.nCurrentMusic=i
	add_child(i)
func _process(_delta):
	player.energy=max(player.energy,0)
	if Input.is_action_just_pressed("ui_debug"):debugInput()
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
#		global.player.pointsLeft+=10
#		global.player.strength+=10
		global.player.defense+=10
		global.player.speed+=10
		global.incrementLevel()
		#global.level=int(clamp(global.level+1,0,10))
		global.player.gold+=1000
func fadeMusicAway():
	if OS.has_feature("standalone"):
		var t:=Tween.new()
		add_child(t)
		t.interpolate_property(self.nCurrentMusic,'volume_db',self.nCurrentMusic.volume_db,-100,4.0,Tween.TRANS_QUINT,Tween.EASE_IN)
		t.start()
		yield(t,"tween_all_completed")
		self.nCurrentMusic.queue_free()
		t.queue_free()
func incrementLevel():
	print_debug('Level: '+str(self.level))
	self.level+=1
	if self.level==5:
		var t:=Tween.new()
		add_child(t)
		t.interpolate_property(self.nCurrentMusic,'volume_db',self.nCurrentMusic.volume_db,-100,4.0,Tween.TRANS_QUINT,Tween.EASE_IN)
		t.start()
		yield(t,"tween_all_completed")
		self.nCurrentMusic.queue_free()
		t.queue_free()
		addMusicFireSword()
	elif self.level==10:
		var t:=Tween.new()
		add_child(t)
		t.interpolate_property(self.nCurrentMusic,'volume_db',self.nCurrentMusic.volume_db,-100,4.0,Tween.TRANS_QUINT,Tween.EASE_IN)
		t.start()
		yield(t,"tween_all_completed")
		self.nCurrentMusic.queue_free()
		t.queue_free()
		addMusicLastOpponent()
	elif self.level==11:
		var t:=Tween.new()
		add_child(t)
		t.interpolate_property(self.nCurrentMusic,'volume_db',self.nCurrentMusic.volume_db,-100,4.0,Tween.TRANS_QUINT,Tween.EASE_IN)
		t.start()
		yield(t,"tween_all_completed")
		self.nCurrentMusic.queue_free()
		t.queue_free()
		
func getBgTexture():
	var playerClass=global.player["class"]
	var newTexture
	if playerClass==global.Classes.Normal:newTexture=load("res://resource/BG_Stats_N1.png")
	elif playerClass==global.Classes.Platy:newTexture=load("res://resource/BG_Stats_N2.png")
	elif playerClass==global.Classes.Stronga:newTexture=load("res://resource/BG_Stats_R1.png")
	elif playerClass==global.Classes.Whey:newTexture=load("res://resource/BG_Stats_R2.png")
	elif playerClass==global.Classes.Wyrm:newTexture=load("res://resource/BG_Stats_R3.png")
	elif playerClass==global.Classes.Knight:newTexture=load("res://resource/BG_Stats_B1.png")
	elif playerClass==global.Classes.Crusader:newTexture=load("res://resource/BG_Stats_B2.png")
	elif playerClass==global.Classes.Fridgeon:newTexture=load("res://resource/BG_Stats_B3.png")
	elif playerClass==global.Classes.Winged:newTexture=load("res://resource/BG_Stats_G1.png")
	elif playerClass==global.Classes.Winged2:newTexture=load("res://resource/BG_Stats_G2.png")
	elif playerClass==global.Classes.Hatoshi:newTexture=load("res://resource/BG_Stats_G3.png")
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
	"Gustabo",
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
	"Dr. Hyde", #New entries for 1.5
	"Mr. Jekyll",
	"Corujante",
	"Kaputter",
	"Lazzor",
	"Park St. Pigeon",
	"Naoto",
	"~Shinigami~",
	"Pombo-sama",
	"Vhaldemar",
	"Primitai",
	"Savant",
	"Sutton Frii",
	"BEAK",
	"Crumb Breaker",
	"Wallker",
	"Mizuni",
	"Diver Pigeon",
	"Oreon",
	"Beatrex",
	"J. James",
	"E Paulo",
	"Bubbles",
	"J-roc",
	"Lahey",
	"J. Lyne",
	"No name here",
	"PigeonCase",
	"Chi-Boon",
	"Peckinton",
	"Tim"
]
