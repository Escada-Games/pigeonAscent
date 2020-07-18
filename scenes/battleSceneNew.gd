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
var particlesImpactGPU=preload("res://scenes/polish/particlesImpactGPU.tscn")
var particlesImpact=preload("res://scenes/polish/particlesImpact.tscn")
var hitSfx=preload("res://scenes/polish/hitSfx.tscn")
var damageNumbers=preload("res://scenes/polish/damageNumbers.tscn")
const pigeonRectOffset=Vector2(0,30)
onready var battleLogText=get_node("marginCtn/battlePanel/battlePanelMargin/hboxCtn/battleLog/battleLog/marginContainer/richTextLabel")
onready var bgNode=get_node("marginCtn/battlePanel/battlePanelMargin/BG")
const hungryStaminaScaling:=0.75
func calculateStaminaIncrement(x,isHungry=false):
	var staminaScaling=hungryStaminaScaling if isHungry else 1
	return 3.79643 + (0.9834812 - 3.79643)/(1 + pow((x/22.7243),1.642935))*staminaScaling
	#Original:
	#return 0.9420715 + 0.1041146*x - 0.00172845*pow(x,2)
func _ready():
	randomize()
	if global.level in [1,2,3,4]:bgNode.texture=load(arenaFiles[0])
	elif global.level in [5,6,7,8,9]:bgNode.texture=load(arenaFiles[1])
	elif global.level in [10]:
		bgNode.texture=load(arenaFiles[2])
		enemySpr.self_modulate.a=0;enemySpr.get_node("sprite").visible=true
	$colorRect.modulate.a=0
	$twnColorRectTransparency.interpolate_property($colorRect,"modulate:a",0,0.85,0.6,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$twnColorRectTransparency.start()
	playerDefaultPos=playerSpr.rect_global_position
	enemyDefaultPos=enemySpr.rect_global_position
	var pos=$marginCtn.rect_global_position
	$marginCtn.rect_global_position.y=-$marginCtn.rect_size.y
	$twnSelfPos.interpolate_property($marginCtn,"rect_global_position:y",-$marginCtn.rect_size.y,pos.y,0.4,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$twnSelfPos.start()
	goldToWin=global.enemy.gold
	$twnAttack.connect("tween_completed",self,"attackFinished")
	get_tree().get_root().connect("size_changed", self, "updateDefaultPositions")
	set_process(true)

func updateDefaultPositions():
	print_debug("Window size changed")
	var change=max((OS.window_size/global.defaultResolution).length(),1)
#	playerSpr.rect_scale=Vector2(change,change)
#	enemySpr.rect_scale=Vector2(change,change)
	get_node("marginCtn/battlePanel/battlePanelMargin/hboxCtn/battleArea/battleArea/topPadding").set("custom_constants/separation",change*66)
#	if OS.window_size.length()>global.defaultResolution.length()*1.2:
#		get_node("marginCtn/battlePanel/battlePanelMargin/hboxCtn/battleArea/battleArea/topPadding").set("custom_constants/separation",66*2)
#		playerSpr.rect_scale=Vector2(2,2)
#		enemySpr.rect_scale=Vector2(2,2)

func _process(delta):
	if self.offset!=0:
		self.rect_position=offset*Vector2(randf(),randf())
	if fighting:
		playerStamina+=calculateStaminaIncrement(global.player.speed+global.player.extraSpeed,global.player.energy<=0)*delta*global.scaling.speed
		if playerStamina>100:
			playerStamina=0
			global.player.energy-=global.level
			global.player.energy=clamp(global.player.energy,0,global.player.maxEnergy)
			playerAttacked=true
			playerAttackAnim()
		enemyStamina+=calculateStaminaIncrement(global.enemy.speed,global.enemy.energy<=0)*delta*global.scaling.speed
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
				registerSameTurn("[center][shake rate=15 level=10]"+global.enemy.name + " won... [/shake][/center]\n")
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
	var block=(1-(global.enemy.defense)*global.scaling.defenseBlock/global.limits.defense)
	var damage=max(floor(calculateDamage(global.player.strength+global.player.extraStrength,global.enemy.defense)*block),1)
	var foodDamage=floor(max(0,global.player.speed+global.player.extraSpeed-global.enemy.speed)*global.scaling.foodDamage)
	var bbName=global.player.name
	var isCritical=false
	if randf()>0.9 or global.enemy.energy<=0:
		damage*=2
		damage*=1 if global.player.energy>0 else 0.5
		isCritical=true
		registerFast("[shake rate=20 level=10]CRITICAL HIT![/shake]")
		if foodDamage>0:
			registerSameTurnNoLineBreak(bbName + " attacks for " +String(damage)+ " damage")
			registerSameTurn("and " +String(foodDamage)+ " food damage")
		else:
			registerSameTurn(bbName + " attacks for " +String(damage)+ " damage")
		shakeEnemyHpBar(25)
	else:
		damage*=1 if global.player.energy>0 else 0.5
		register(bbName + " attacks for " +String(damage)+ " damage")
		if foodDamage>0:registerSameTurn(" and " +String(foodDamage)+ " food damage")
		shakeEnemyHpBar()
		enemySpr.hit()
	
#	playerAttackAnim()
	global.enemy.hp-=damage
	global.enemy.energy-=foodDamage
	createDamageNumbers(enemySpr.rect_global_position+enemySpr.rect_size/2,1,damage,isCritical,"Player")
	if global.enemy.hp<=0:
		exitButton.rect_global_position.y=OS.window_size.y*1.2
		fighting=false
#		$twnAttack.stop(enemySpr)
#		$twnRecoil.stop(enemySpr)
#		enemySpr.dead=true
#		$twn.interpolate_property(enemySpr,"rect_global_position:x",enemySpr.rect_global_position.x,enemySpr.rect_global_position.x+333,1,Tween.TRANS_QUINT,Tween.EASE_OUT)
#		$twn.interpolate_property(enemySpr,"rect_global_position:y",enemySpr.rect_global_position.y,enemySpr.rect_global_position.y+OS.window_size.y,1,Tween.TRANS_BACK,Tween.EASE_IN)
#		$twn.interpolate_property(enemySpr,"rect_rotation",enemySpr.rect_rotation,100*PI,10,Tween.TRANS_QUINT,Tween.EASE_OUT)
#		$twn.start()
#	playerAttacked=true
	
func enemyAttack():
	var damage=max(ceil(calculateDamage(global.enemy.strength,global.player.defense+global.player.extraDefense)*(1-(global.player.defense+global.player.extraDefense)*global.scaling.defenseBlock/global.limits.defense)),1)
	var foodDamage=ceil(max(0,global.enemy.speed-global.player.speed-global.player.extraSpeed)*global.scaling.foodDamage)
	var bbName=colorizeString(global.enemy.name,"#eb564b")#"[color=#eb564b]"+global.enemy.name+"[/color]"
	var isCritical=false
	if randf()>0.9 or global.player.energy<=0:
		damage*=2
		damage*=1 if global.enemy.energy>0 else 0.5
		isCritical=true
		registerFast("[shake rate=20 level=10]CRITICAL HIT![/shake]")
		
		if foodDamage>0:
			registerSameTurnNoLineBreak(bbName + " attacks for " +String(damage)+ " damage")
			registerSameTurn(" and " +String(foodDamage)+ " food damage")
		else:
			registerSameTurn(bbName + " attacks for " +String(damage)+ " damage")
		shakePlayerHpBar(25)
	else:
		damage*=1 if global.enemy.energy>0 else 0.5
		register(bbName + " attacks for " +String(damage)+ " damage")
		if foodDamage>0:registerSameTurn(" and " +String(foodDamage)+ " food damage")
		shakePlayerHpBar()
		playerSpr.hit()
#	if foodDamage>0:registerSameTurn(bbName + " attacks for " +String(foodDamage)+ " food damage")
#	enemyAttackAnim()
	global.player.hp-=damage
	global.player.energy-=foodDamage
	createDamageNumbers(playerSpr.rect_global_position+playerSpr.rect_size/2,-1,damage,isCritical,"Enemy")
	if global.player.hp<=0:
		exitButton.rect_global_position.y=OS.window_size.y*1.2
		fighting=false
#	enemyAttacked=true

func calculateDamage(strength,defense,minDamage=1):
	return int(max(rand_range(1.0,1.2)*strength*global.scaling.strength-defense*global.scaling.defense,minDamage))

func playerAttackAnim():
	$twnRecoil.stop(playerSpr)
#	$twnAttack.interpolate_property(playerSpr,"rect_global_position",playerSpr.rect_global_position,enemySpr.rect_global_position,durationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
	$twnAttack.interpolate_property(playerSpr,"rect_global_position",playerSpr.rect_global_position,enemyDefaultPos,durationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
	$twnAttack.start()
func enemyAttackAnim():
	$twnRecoil.stop(enemySpr)
#	$twnAttack.interpolate_property(enemySpr,"rect_global_position",enemySpr.rect_global_position,playerSpr.rect_global_position,durationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
	$twnAttack.interpolate_property(enemySpr,"rect_global_position",enemySpr.rect_global_position,playerDefaultPos,durationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
	$twnAttack.start()
func shakePlayerHpBar(intensity=5):
	$"marginCtn/battlePanel/battlePanelMargin/hboxCtn/battleArea/battleArea/playerCtn/playerStats".shakeHp(intensity)
func shakeEnemyHpBar(intensity=5):
	$"marginCtn/battlePanel/battlePanelMargin/hboxCtn/battleArea/battleArea/enemyCtn/enemyStats".shakeHp(intensity)
func register(string):
	var message="#"+String(turn)+"> "+string+"\n"#colorizeString("#"+String(turn)+"> "+string,"#3ca370")+"\n"
	battleLogText.bbcode_text+=message
	turn+=1

func registerSameTurn(string):
	var message= " "+string+"\n"
	battleLogText.bbcode_text+=message
#	turn+=1

func registerSameTurnNoLineBreak(string):
	var message= " "+string
	battleLogText.bbcode_text+=message
#	turn+=1

func registerFast(string):
	var message="#"+String(turn)+"> "+string
	battleLogText.bbcode_text+=message

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
func createDamageNumbers(position,direction,damage,critical=false,origin=""):
	var i=damageNumbers.instance()
	i.global_position=position
	i.direction=direction
	i.damage=damage
	i.critical=critical
	i.origin=origin
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
	playerSpr.rect_global_position.y*=rand_range(0.9,1.1)
	enemySpr.rect_global_position.y*=rand_range(0.9,1.1)
	$twnRecoil.interpolate_property(playerSpr,"rect_position",playerSpr.rect_position,pigeonRectOffset,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
	$twnRecoil.interpolate_property(enemySpr,"rect_position",enemySpr.rect_position,pigeonRectOffset,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
	$twnRecoil.start()
func particlesAndWindowshake(area):
	createHitSfx()
	particles(area)
	windowShake()
func particles(area):
	var i=particlesImpact.instance()
	i.global_position=0.5*(playerSpr.get_node("area2D").global_position+enemySpr.get_node("area2D").global_position)
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
