extends Control
var playerStamina=0
var enemyStamina=0
var playerSpr=TextureRect.new()
var enemySpr=TextureRect.new()
var playerDefaultPos
var enemyDefaultPos
var playerAttacked=false
var enemyAttacked=false
var durationAttack=0.7
var durationReturn=0.3
var durationShake=0.5
var durationRecoil=0.6
var defaultDurationShake=0.5
var turn=1
var fighting=true
var ended=false
var exitButton
var resetButton
var goldToWin=0
var offset=0
onready var richtextLabel=$marginCtn/battlePanel/vboxCtn/hboxCtnTop/panelContainer/marginContainer/richTextLabel
var particlesImpact=preload("res://scenes/polish/particlesImpact.tscn")
var hitSfx=preload("res://scenes/polish/hitSfx.tscn")
func _ready():
	$colorRect.modulate.a=0
	$twnColorRectTransparency.interpolate_property($colorRect,"modulate:a",0,0.85,0.6,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$twnColorRectTransparency.start()
	randomize()
	$twnAttack.connect("tween_completed",self,"attackFinished")
	$twnBack
	playerDefaultPos=playerSpr.rect_global_position
	enemyDefaultPos=enemySpr.rect_global_position
	var pos=$marginCtn.rect_global_position
	$marginCtn.rect_global_position.y=-$marginCtn.rect_size.y
	$twnSelfPos.interpolate_property($marginCtn,"rect_global_position:y",-$marginCtn.rect_size.y,pos.y,0.4,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$twnSelfPos.start()
	goldToWin=100
	set_process(true)
	
func _process(delta):
	print(playerSpr.rect_global_position)
	if self.offset!=0:
		self.rect_position=offset*Vector2(randf(),randf())
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
#		if abs(playerSpr.rect_global_position.x-enemySpr.rect_global_position.x)<50:
#			print("?")
	else:
		if not ended:
			if global.player.hp>0:
				global.player.gold+=goldToWin
				global.level+=1
				global.player.pointsLeft+=3
				registerSameTurn("[center][wave amp=100 freq=5]"+global.player.name + " won! [/wave][/center]\n")
				registerSameTurn("[center]You got [color=#ffe478]" + String(goldToWin) + "[/color] gold.[/center]")#
				ended=true
				$twnBackButton.interpolate_property(exitButton,"rect_global_position:y",OS.window_size.y*1.2,OS.window_size.y*0.66,0.5,Tween.TRANS_BACK,Tween.EASE_OUT)
				$twnBackButton.start()
				exitButton.modulate.a=0
				exitButton.visible=true
				resetButton.queue_free()
			else:
				registerSameTurn("[center][shake rate=5 level=10]"+global.enemy.name + " won... [/shake][/center]\n")
				registerSameTurn("[center][color=#b0305c]" + "Game Over." + "[/color][/center]\n\n")
				registerSameTurn("[center] Retry? [/center]")
				ended=true
				$twnBackButton.interpolate_property(resetButton,"rect_global_position:y",OS.window_size.y*1.2,OS.window_size.y*0.66,0.5,Tween.TRANS_BACK,Tween.EASE_OUT)
				$twnBackButton.start()
				resetButton.modulate.a=0
				resetButton.visible=true
				exitButton.queue_free()
		else:
			if global.player.hp>0:
				exitButton.modulate.a+=0.1
			elif global.enemy.hp>0:
				resetButton.modulate.a+=0.1

func playerAttack():
	var damage=calculateDamage(global.player.strength,global.enemy.defense)
	var bbName=global.player.name
	if randf()>0.9 or global.enemy.energy<=0:
		damage*=2
		registerFast("[shake rate=20 level=10]CRITICAL HIT![/shake]")
		registerSameTurn(bbName + " attacks for " +String(damage)+ " damage")
		shakeEnemyHpBar(15)
	else:
		register(bbName + " attacks for " +String(damage)+ " damage")
		shakeEnemyHpBar()
	playerAttackAnim()
	global.enemy.hp-=damage
	if global.enemy.hp<=0:
		exitButton.rect_global_position.y=OS.window_size.y*1.2
		fighting=false
	playerAttacked=true
	
func enemyAttack():
	var damage=calculateDamage(global.enemy.strength,global.player.defense)
	var bbName=colorizeString(global.enemy.name,"#eb564b")#"[color=#eb564b]"+global.enemy.name+"[/color]"
	if randf()>0.9 or global.player.energy<=0:
		damage*=2
		registerFast("[shake rate=20 level=10]CRITICAL HIT![/shake]")
		registerSameTurn( bbName + " attacks for " +String(damage)+ " damage")
		shakePlayerHpBar(15)
	else:
		register(bbName + " attacks for " +String(damage)+ " damage")
		shakePlayerHpBar()
	enemyAttackAnim()
	global.player.hp-=damage
	if global.player.hp<=0:
		exitButton.rect_global_position.y=OS.window_size.y*1.2
		fighting=false
	enemyAttacked=true

func calculateDamage(strength,defense,minDamage=1):
	return int(max(rand_range(1.0,1.2)*strength*global.scaling.strength-defense*global.scaling.defense,minDamage))

func attackFinished(h,m):
	if playerAttacked:
		$twnAttack.interpolate_property(playerSpr,"rect_global_position:x",-1.33*playerSpr.rect_size.x,playerDefaultPos.x,durationReturn,Tween.TRANS_BACK,Tween.EASE_OUT)
		$twnAttack.start()
		playerAttacked=false
	if enemyAttacked:
		$twnAttack.interpolate_property(enemySpr,"rect_global_position:x",enemyDefaultPos.x+1.33*enemySpr.rect_size.x,enemyDefaultPos.x,durationReturn,Tween.TRANS_BACK,Tween.EASE_OUT)
		$twnAttack.start()
		enemyAttacked=false
func playerAttackAnim():
	$twnAttack.interpolate_property(playerSpr,"rect_global_position:x",playerDefaultPos.x,enemyDefaultPos.x,durationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
	$twnAttack.start()
func enemyAttackAnim():
	$twnAttack.interpolate_property(enemySpr,"rect_global_position:x",enemyDefaultPos.x,playerDefaultPos.x,durationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
	$twnAttack.start()
func shakePlayerHpBar(intensity=5):
	$marginCtn/battlePanel/vboxCtn/hboxCtnTop/playerStats.shakeHp(intensity)
func shakeEnemyHpBar(intensity=5):
	$marginCtn/battlePanel/vboxCtn/hboxCtnTop/enemyStats.shakeHp(intensity)
func register(string):
	var message="#"+String(turn)+"> "+string+"\n"#colorizeString("#"+String(turn)+"> "+string,"#3ca370")+"\n"
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
	$twnSelfPos.connect("tween_completed",self,"killMe")
	$twnSelfPos.interpolate_property($marginCtn,"rect_global_position:y",$marginCtn.rect_global_position.y,-$marginCtn.rect_size.y,0.4,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$twnSelfPos.start()
	$twnColorRectTransparency.interpolate_property($colorRect,"modulate:a",0.85,0,0.3,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$twnColorRectTransparency.start()
func killMe(h,m):
	self.queue_free()
func gameOver():
	#TODO:CHANGE TO GOING BACK TO THE TITLE SCREEN
	get_tree().quit()
func effects(area):
	particlesAndWindowshake(area)
	knockback()
func knockback():
	$twnAttack.stop_all()
	randomize()
	playerSpr.rect_global_position.y*=rand_range(0.7,1.1)
	$twnRecoil.interpolate_property(playerSpr,"rect_global_position",playerSpr.rect_global_position,playerDefaultPos,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
	enemySpr.rect_global_position.y*=rand_range(0.7,1.1)
	$twnRecoil.interpolate_property(enemySpr,"rect_global_position",enemySpr.rect_global_position,enemyDefaultPos,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
	$twnRecoil.start()
	pass
func particlesAndWindowshake(area):
	createHitSfx()
	particles(area)
	windowShake()
func particles(area):
	var i=particlesImpact.instance()
	i.global_position.x=(playerSpr.rect_global_position.x+enemySpr.rect_global_position.x)/2.0
	i.global_position.y=playerSpr.rect_global_position.y+playerSpr.rect_size.y/2
	i.emitting=true
	add_child(i)
func windowShake(newOffset=10):
	self.offset=newOffset
	$twnShake.interpolate_property(self,"offset",self.offset,0,self.durationShake,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$twnShake.start()
	durationShake=defaultDurationShake*rand_range(0.7,1.0)
func createHitSfx():
	self.add_child(hitSfx.instance())
func colorizeString(string,color="#ffffff"):
	return "[color="+color+"]"+String(string)+"[/color] "
