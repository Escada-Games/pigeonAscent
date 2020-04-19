extends Control
var playerStamina=0
var enemyStamina=0
var playerSpr
var enemySpr
var playerDefaultPos
var enemyDefaultPos
var playerAttacked=false
var enemyAttacked=false
var durationAttack=0.5
var durationReturn=0.3
var turn=1
var fighting=true
var ended=false
var exitButton
var goldToWin=0
onready var richtextLabel=$marginCtn/battlePanel/vboxCtn/hboxCtnTop/panelContainer/marginContainer/richTextLabel
func _ready():
	randomize()
	$twnAttack.connect("tween_completed",self,"attackFinished")
	playerDefaultPos=playerSpr.rect_global_position
	enemyDefaultPos=enemySpr.rect_global_position
	var pos=$marginCtn.rect_global_position
	$marginCtn.rect_global_position.y=-$marginCtn.rect_size.y
	$twnSelfPos.interpolate_property($marginCtn,"rect_global_position:y",-$marginCtn.rect_size.y,pos.y,0.4,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$twnSelfPos.start()
	goldToWin=100
	set_process(true)
func _process(delta):
	if fighting:
		playerStamina+=global.player.speed*delta*global.scaling.speed
		if playerStamina>100:
			playerStamina=0
			global.player.energy-=1
			playerAttack()
		enemyStamina+=global.enemy.speed*delta*global.scaling.speed
		if enemyStamina>100:
			enemyStamina=0
			global.enemy.energy-=1
			enemyAttack()
	else:
		exitButton.modulate.a+=0.1
		if not ended:
			global.player.gold+=goldToWin
			registerSameTurn("[center][wave amp=100 freq=5]"+global.player.name + " won! [/wave][/center]\n")
			registerSameTurn("[center]You got [color=#ffe478]" + String(goldToWin) + "[/color] gold.[/center]")#
			ended=true
			$twnBackButton.interpolate_property(exitButton,"rect_global_position:y",OS.window_size.y*1.2,OS.window_size.y*0.66,0.5,Tween.TRANS_BACK,Tween.EASE_OUT)
			$twnBackButton.start()
			exitButton.modulate.a=0
			exitButton.visible=true

func playerAttack():
	var damage=int(rand_range(1.0,1.2)*global.player.strength*global.scaling.strength)
	damage*=10
	var bbName=global.player.name
	if randf()>0.9 or global.enemy.energy<=0:
		damage*=2
		registerFast("[shake rate=20 level=10]CRITICAL HIT![/shake]")
		registerSameTurn(bbName + " attacks for " +String(damage)+ " damage")
	else:
		register(bbName + " attacks for " +String(damage)+ " damage")
	$twnAttack.interpolate_property(playerSpr,"rect_global_position:x",playerDefaultPos.x,enemyDefaultPos.x,durationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
	$twnAttack.start()
	global.enemy.hp-=damage
	if global.enemy.hp<=0:
		exitButton.rect_global_position.y=OS.window_size.y*1.2
		fighting=false
	playerAttacked=true
	
func enemyAttack():
	var damage=int(rand_range(1.0,1.2)*global.enemy.strength*global.scaling.strength)
	var bbName="[color=#eb564b]"+global.enemy.name+"[/color]"
	if randf()>0.9 or global.player.energy<=0:
		damage*=2
		registerFast("[shake rate=20 level=10]CRITICAL HIT![/shake]")
		registerSameTurn( bbName + " attacks for " +String(damage)+ " damage")
	else:
		register(bbName + " attacks for " +String(damage)+ " damage")
	$twnAttack.interpolate_property(enemySpr,"rect_global_position:x",enemyDefaultPos.x,playerDefaultPos.x,durationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
	$twnAttack.start()
	global.player.hp-=damage
	if global.player.hp<=0:
		exitButton.rect_global_position.y=OS.window_size.y*1.2
		fighting=false
	enemyAttacked=true

func attackFinished(h,m):
	if playerAttacked:
		$twnAttack.interpolate_property(playerSpr,"rect_global_position:x",-1.33*playerSpr.rect_size.x,playerDefaultPos.x,durationReturn,Tween.TRANS_BACK,Tween.EASE_OUT)
		$twnAttack.start()
		playerAttacked=false
	if enemyAttacked:
		$twnAttack.interpolate_property(enemySpr,"rect_global_position:x",enemyDefaultPos.x+1.33*enemySpr.rect_size.x,enemyDefaultPos.x,durationReturn,Tween.TRANS_BACK,Tween.EASE_OUT)
		$twnAttack.start()
		enemyAttacked=false
	
func register(string):
	var message="#"+String(turn)+"> "+string+"\n"
	richtextLabel.bbcode_text+=message
	turn+=1

func registerSameTurn(string):
	var message= " "+string+"\n"
	richtextLabel.bbcode_text+=message
	turn+=1

func registerFast(string):
	var message="#"+String(turn)+"> "+string
	richtextLabel.bbcode_text+=message

func exitBattle():
	self.mouse_filter=Control.MOUSE_FILTER_IGNORE
	$twnSelfPos.interpolate_property($marginCtn,"rect_global_position:y",$marginCtn.rect_global_position.y,-$marginCtn.rect_size.y,0.4,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$twnSelfPos.start()
	yield(get_tree().create_timer(5.0),"timeout")
	self.queue_free()
