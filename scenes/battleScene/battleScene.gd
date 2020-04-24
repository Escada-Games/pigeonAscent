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
var durationRecoil=1
var defaultDurationShake=0.5
var turn=1
var fighting=true
var ended=false
var exitButton
var resetButton
var goldToWin=0
var offset=0
var arenaFiles=[
	"res://resource/Arena_Sand.png",
	"res://resource/Arena_Grass.png",
	"res://resource/Arena_Godfight.png"
]
onready var richtextLabel=$marginCtn/battlePanel/vboxCtn/hboxCtnTop/panelContainer/marginContainer/richTextLabel
var particlesImpact=preload("res://scenes/polish/particlesImpact.tscn")
var hitSfx=preload("res://scenes/polish/hitSfx.tscn")
var damageNumbers=preload("res://scenes/polish/damageNumbers.tscn")
func calculateStaminaIncrement(x):
	return 0.9420715 + 0.1041146*x - 0.00172845*pow(x,2)
func _ready():
	if global.level in [1,2,3,4]:$marginCtn/battlePanel/BG.texture=load(arenaFiles[0])
	elif global.level in [5,6,7,8,9]:$marginCtn/battlePanel/BG.texture=load(arenaFiles[1])
	elif global.level in [10]:
		$marginCtn/battlePanel/BG.texture=load(arenaFiles[2])
		enemySpr.self_modulate.a=0
		enemySpr.get_node("sprite").visible=true
#		$marginCtn/battlePanel/vboxCtn/hboxCtnMid/enemyCtn/vboxPlayer.alignment=BoxContainer.ALIGN_END
#		playerSpr.rect_min_size=Vector2(20,20)
#		enemySpr.size_flags_vertical=Control.SIZE_EXPAND_FILL
		
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
	goldToWin=global.enemy.gold
	set_process(true)
	
func _process(delta):
	update()
	if self.offset!=0:
		self.rect_position=offset*Vector2(randf(),randf())
	if fighting:
		playerStamina+=calculateStaminaIncrement(global.player.speed+global.player.extraSpeed)*delta*global.scaling.speed
		if playerStamina>100:
			playerStamina=0
			global.player.energy-=global.level
			global.player.energy=clamp(global.player.energy,0,global.player.maxEnergy)
			playerAttacked=true
			playerAttackAnim()
		enemyStamina+=calculateStaminaIncrement(global.enemy.speed)*delta*global.scaling.speed
		if enemyStamina>100:
			enemyStamina=0
			global.enemy.energy-=global.level
			global.enemy.energy=clamp(global.enemy.energy,0,global.enemy.maxEnergy)
			enemyAttacked=true
			enemyAttackAnim()
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
				resetButton.visible=false
			else:
				registerSameTurn("[center][shake rate=5 level=10]"+global.enemy.name + " won... [/shake][/center]\n")
				registerSameTurn("[center][color=#b0305c]" + "Game Over." + "[/color][/center]\n\n")
				registerSameTurn("[center] Retry? [/center]")
				ended=true
				$twnBackButton.interpolate_property(resetButton,"rect_global_position:y",OS.window_size.y*1.2,OS.window_size.y*0.66,0.5,Tween.TRANS_BACK,Tween.EASE_OUT)
				$twnBackButton.start()
				resetButton.modulate.a=0
				resetButton.visible=true
				exitButton.visible=false
		else:
			exitButton.modulate.a+=0.1
			resetButton.modulate.a+=0.1
#			if global.player.hp>0:
#				exitButton.modulate.a+=0.1
#			elif global.enemy.hp>0:
#				resetButton.modulate.a+=0.1

func playerAttack():
	var damage=calculateDamage(global.player.strength+global.player.extraStrength,global.enemy.defense)
	var bbName=global.player.name
	var isCritical=false
	if randf()>0.9 or global.enemy.energy<=0:
		damage*=2
		isCritical=true
		registerFast("[shake rate=20 level=10]CRITICAL HIT![/shake]")
		registerSameTurn(bbName + " attacks for " +String(damage)+ " damage")
		shakeEnemyHpBar(15)
	else:
		register(bbName + " attacks for " +String(damage)+ " damage")
		shakeEnemyHpBar()
		enemySpr.hit()
#	playerAttackAnim()
	global.enemy.hp-=damage
	createDamageNumbers(enemySpr.rect_global_position+enemySpr.rect_size/2,1,damage,isCritical)
	if global.enemy.hp<=0:
		exitButton.rect_global_position.y=OS.window_size.y*1.2
		fighting=false
#	playerAttacked=true
	
func enemyAttack():
	var damage=calculateDamage(global.enemy.strength,global.player.defense+global.player.extraDefense)
	var bbName=colorizeString(global.enemy.name,"#eb564b")#"[color=#eb564b]"+global.enemy.name+"[/color]"
	var isCritical=false
	if randf()>0.9 or global.player.energy<=0:
		damage*=2
		isCritical=true
		registerFast("[shake rate=20 level=10]CRITICAL HIT![/shake]")
		registerSameTurn( bbName + " attacks for " +String(damage)+ " damage")
		shakePlayerHpBar(15)
	else:
		register(bbName + " attacks for " +String(damage)+ " damage")
		shakePlayerHpBar()
		playerSpr.hit()
#	enemyAttackAnim()
	global.player.hp-=damage
	createDamageNumbers(playerSpr.rect_global_position+playerSpr.rect_size/2,-1,damage,isCritical)
	if global.player.hp<=0:
		exitButton.rect_global_position.y=OS.window_size.y*1.2
		fighting=false
#	enemyAttacked=true

func calculateDamage(strength,defense,minDamage=1):
	return int(max(rand_range(1.0,1.2)*strength*global.scaling.strength-defense*global.scaling.defense,minDamage))

func attackFinished(h,m):
	if playerAttacked:
#		$twnAttack.interpolate_property(playerSpr,"rect_global_position",Vector2(-1.33,1)*playerSpr.rect_size,playerDefaultPos,durationReturn,Tween.TRANS_BACK,Tween.EASE_OUT)
#		$twnAttack.start()
		playerAttack()
		playerAttacked=false
		playerSpr.rect_global_position.y*=rand_range(0.7,1.1)
		$twnRecoil.interpolate_property(playerSpr,"rect_global_position",playerSpr.rect_global_position,playerDefaultPos,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
		$twnRecoil.start()
		effects('a')
	if enemyAttacked:
#		$twnAttack.interpolate_property(enemySpr,"rect_global_position:x",enemyDefaultPos.x+1.33*enemySpr.rect_size.x,enemyDefaultPos.x,durationReturn,Tween.TRANS_BACK,Tween.EASE_OUT)
#		$twnAttack.start()
		enemyAttack()
		enemySpr.rect_global_position.y*=rand_range(0.7,1.1)
		$twnRecoil.interpolate_property(enemySpr,"rect_global_position",enemySpr.rect_global_position,enemyDefaultPos,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
		$twnRecoil.start()
		effects('a')
		enemyAttacked=false
func playerAttackAnim():
	$twnRecoil.stop(playerSpr)
#	$twnAttack.stop_all()
	$twnAttack.interpolate_property(playerSpr,"rect_global_position",playerSpr.rect_global_position,enemySpr.rect_global_position,durationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
	$twnAttack.start()
func enemyAttackAnim():
	$twnRecoil.stop(enemySpr)
#	$twnAttack.stop_all()
	$twnAttack.interpolate_property(enemySpr,"rect_global_position",enemySpr.rect_global_position,playerSpr.rect_global_position,durationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
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
	self.set_process(false)
	if global.level==11:
		get_tree().change_scene("res://scenes/end.tscn")
	global.player.extraStrength=0
	global.player.extraDefense=0
	global.player.extraSpeed=0
	self.mouse_filter=Control.MOUSE_FILTER_IGNORE
	if(global.level==4):
		global.createEvolvePanel()
	elif(global.level==7):
		global.createEvolvePanel()
	$twnSelfPos.connect("tween_completed",self,"killMe")
	$twnSelfPos.interpolate_property($marginCtn,"rect_global_position:y",$marginCtn.rect_global_position.y,-$marginCtn.rect_size.y,0.4,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$twnSelfPos.start()
	$twnColorRectTransparency.interpolate_property($colorRect,"modulate:a",0.85,0,0.3,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$twnColorRectTransparency.start()
func applyDamage(target,damage):
	target.hp-=damage
func killMe(h,m):
	self.queue_free()
func gameOver():
	#TODO:CHANGE TO GOING BACK TO THE TITLE SCREEN
#	get_tree().quit()
	get_tree().change_scene("res://scenes/intro.tscn")
	self.queue_free()
func effects(area):
	particlesAndWindowshake(area)
	knockback()
#	createDamageNumbers()
func createDamageNumbers(position,direction,damage,critical=false):
	var i=damageNumbers.instance()
	i.global_position=position
	i.direction=direction
	i.damage=damage
	i.critical=critical
	add_child(i)
func knockback():
	if playerAttacked:
		playerAttack()
		playerAttacked=false
	elif enemyAttacked:
		enemyAttack()
		enemyAttacked=false
	$twnAttack.stop_all()
	randomize()
	playerSpr.rect_global_position.y*=rand_range(0.7,1.1)
	$twnRecoil.interpolate_property(playerSpr,"rect_global_position",playerSpr.rect_global_position,playerDefaultPos,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
	enemySpr.rect_global_position.y*=rand_range(0.7,1.1)
	$twnRecoil.interpolate_property(enemySpr,"rect_global_position",enemySpr.rect_global_position,enemyDefaultPos,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
	$twnRecoil.start()
func particlesAndWindowshake(area):
	createHitSfx()
	particles(area)
	windowShake()
func particles(area):
	var i=particlesImpact.instance()
#	i.global_position.x=(playerSpr.rect_size.x/2)+(playerSpr.rect_global_position.x+enemySpr.rect_global_position.x)/2.0
#	i.global_position.y=playerSpr.rect_global_position.y+playerSpr.rect_size.y/2
	i.global_position=0.5*($marginCtn/battlePanel/vboxCtn/hboxCtnMid/playerCtn/vboxPlayer/playerSpr/area2D.global_position+$marginCtn/battlePanel/vboxCtn/hboxCtnMid/enemyCtn/vboxPlayer/textureRect/area2D.global_position)
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
	return "[color="+color+"]"+String(string)+"[/color]"
