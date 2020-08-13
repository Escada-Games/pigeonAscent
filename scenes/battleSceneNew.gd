extends Control
var playerStamina=0
var enemyStamina=0
var playerSpr:=Sprite.new()
var enemySpr:=Sprite.new()
var playerDefaultPos
var enemyDefaultPos
var playerAttacked=false
var enemyAttacked=false
const durationAttack:=0.7
const durationReturn:=0.3
const durationRecoil:=1
const defaultDurationShake:=0.5
const hungryStaminaScaling:=0.75
var durationShake:=0.5
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

var playerAttacking=false
var enemyAttacking=false

var particlesImpactGPU=preload("res://scenes/polish/particlesImpactGPU.tscn")
var particlesImpact=preload("res://scenes/polish/particlesImpact.tscn")
var hitSfx=preload("res://scenes/polish/hitSfx.tscn")
var damageNumbers=preload("res://scenes/polish/damageNumbers.tscn")
const pigeonRectOffset=Vector2(0,30)
onready var battleLogText=get_node("marginCtn/battlePanel/battlePanelMargin/hboxCtn/battleLog/battleLog/marginContainer/richTextLabel")
onready var bgNode=get_node("marginCtn/battlePanel/battlePanelMargin/BG")


func calculateStaminaIncrement(x,isHungry=false):
	var staminaScaling=hungryStaminaScaling if isHungry else 1
	var externalScaling=1
	return externalScaling*(3.79643 + (0.9834812 - 3.79643)/(1 + pow((x/22.7243),1.642935))*staminaScaling)

func _ready():
	randomize()
	# Set battle arena texture
	if global.level in [1,2,3,4]:bgNode.texture=load(arenaFiles[0])
	elif global.level in [5,6,7,8,9]:bgNode.texture=load(arenaFiles[1])
	elif global.level in [10]:
		bgNode.texture=load(arenaFiles[2])
		enemySpr.self_modulate.a=0;enemySpr.get_node("sprite").visible=true
	# Dunno
	$colorRect.modulate.a=0
	$twnColorRectTransparency.interpolate_property($colorRect,"modulate:a",0,0.85,0.6,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$twnColorRectTransparency.start()
	# Holding default positions for playerSpr and enemySpr
#	playerDefaultPos=playerSpr.global_position
#	enemyDefaultPos=enemySpr.global_position
	# Tween to inside the game's viewport
	var pos=$marginCtn.rect_global_position
	$marginCtn.rect_global_position.y=-$marginCtn.rect_size.y
	$twnSelfPos.interpolate_property($marginCtn,"rect_global_position:y",-$marginCtn.rect_size.y,pos.y,0.4,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$twnSelfPos.start()
	# Gold to be added at the end of the fight
	goldToWin=global.enemy.gold
	# Detection for when an attack finished
#	$twnAttack.connect("tween_completed",self,"attackFinished")
#	$twnPlayer.connect("tween_completed",self,"attackFinished")
#	$twnEnemy.connect("tween_completed",self,"attackFinished")
	# Set process true
	set_process(true)

func attackFinished(a,b):
	return
	if a==playerSpr:
		print_debug("Player finished attacking.")
		playerAttacking=false
		$twnPlayer.interpolate_property(playerSpr,"rect_position",playerSpr.rect_position,playerDefaultPos,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_IN)
		$twnPlayer.start()
#		$twnAttack.interpolate_property(playerSpr,"rect_position",playerSpr.rect_position,playerDefaultPos,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_IN)
#		$twnAttack.interpolate_property(playerSpr,"rect_position",playerSpr.rect_position,pigeonRectOffset,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_IN)
#		$twnAttack.start()
	else:
		print_debug("Enemy finished attacking.")
		$twnAttack.interpolate_property(enemySpr,"rect_position",enemySpr.rect_position,pigeonRectOffset,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_IN)
		$twnAttack.start()

func _process(delta):
#	playerSpr.global_position=playerDefaultPos
#	enemySpr.global_position=enemyDefaultPos
#	return
	global.player.energy=clamp(global.player.energy,0,global.player.maxEnergy)
	global.enemy.energy=clamp(global.enemy.energy,0,global.enemy.maxEnergy)
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
#		enemyStamina+=calculateStaminaIncrement(global.enemy.speed,global.enemy.energy<=0)*delta*global.scaling.speed
		if enemyStamina>100:
			enemyStamina=0
			global.enemy.energy-=global.level
			global.enemy.energy=clamp(global.enemy.energy,0,global.enemy.maxEnergy)
			enemyAttacked=true
			enemyAttackAnim()
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

func playerAttack():
	var block=(1-(global.enemy.defense)*global.scaling.defenseBlock/global.limits.defense)
	var damage=max(ceil(calculateDamage(global.player.strength+global.player.extraStrength,global.enemy.defense)*block),1)
	var foodDamage=ceil(max(0,global.player.speed+global.player.extraSpeed-global.enemy.speed)*global.scaling.foodDamage)
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
	
	global.enemy.hp-=int(damage)
	global.enemy.energy-=foodDamage
	createDamageNumbers(enemySpr.global_position,1,damage,isCritical,"Player")
	if global.enemy.hp<=0:
		exitButton.rect_global_position.y=OS.window_size.y*1.2
		fighting=false
		enemySpr.dead=true
	
func enemyAttack():
	var damage=max(floor(calculateDamage(global.enemy.strength,global.player.defense+global.player.extraDefense)*(1-(global.player.defense+global.player.extraDefense)*global.scaling.defenseBlock/global.limits.defense)),1)
	var foodDamage=floor(max(0,global.enemy.speed-global.player.speed-global.player.extraSpeed)*global.scaling.foodDamage)
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
	global.player.hp-=int(damage)
	global.player.energy-=foodDamage
	createDamageNumbers(playerSpr.global_position,-1,damage,isCritical,"Enemy")
	if global.player.hp<=0:
		exitButton.rect_global_position.y=OS.window_size.y*1.2
		fighting=false
		playerSpr.dead=true

func calculateDamage(strength,defense,minDamage=1):
	return int(max(rand_range(1.0,1.2)*strength*global.scaling.strength-defense*global.scaling.defense,minDamage))

func playerAttackAnim():
	if not playerAttacking:
		playerAttacking=true
		var localDurationAttack=durationAttack*(1+global.player.speed/30)
		var isAtEnemy=false#is_equal_approx(playerSpr.global_position.x,enemyDefaultPos.x)
		var targetPosition=enemyDefaultPos if not isAtEnemy else playerDefaultPos#enemyDefaultPos if not isAtEnemy else playerDefaultPos
		$twnPlayer.interpolate_property(playerSpr,"global_position",playerSpr.global_position,targetPosition,localDurationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
		$twnPlayer.start()
		print_debug(isAtEnemy)
#	$twnRecoil.stop(playerSpr)
#	$twnRecoil.interpolate_property(playerSpr,"rect_position",playerSpr.rect_position,Vector2(),durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
#	$twnRecoil.start()
#	var localDurationAttack=durationAttack*(1+global.player.speed/30)
#	$twnAttack.interpolate_property(playerSpr,"rect_global_position",playerSpr.rect_global_position,enemyDefaultPos,localDurationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
#	$twnAttack.start()
func enemyAttackAnim():
	if not enemyAttacking:
		enemyAttacking=true
		var localDurationAttack=durationAttack*(1+global.enemy.speed/30)
		var isAtPlayer=is_equal_approx(playerSpr.global_position.x,enemyDefaultPos.x)
		var targetPosition=playerDefaultPos if not isAtPlayer else enemyDefaultPos
		$twnEnemy.interpolate_property(enemySpr,"global_position",enemySpr.global_position,targetPosition,localDurationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
		$twnEnemy.start()
#	$twnRecoil.stop(enemySpr)
##	$twnRecoil.interpolate_property(enemySpr,"rect_position",enemySpr.rect_position,Vector2(),durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
##	$twnRecoil.start()
#	var localDurationAttack=durationAttack*(1+global.enemy.speed/30)
#	$twnAttack.interpolate_property(enemySpr,"rect_global_position",enemySpr.rect_global_position,playerDefaultPos,localDurationAttack,Tween.TRANS_BACK,Tween.EASE_IN)
#	$twnAttack.start()

func register(string):
	var message="#"+String(turn)+"> "+string+"\n"#colorizeString("#"+String(turn)+"> "+string,"#3ca370")+"\n"
	battleLogText.bbcode_text+=message
	turn+=1

func registerSameTurn(string):
	var message= " "+string+"\n"
	battleLogText.bbcode_text+=message

func registerSameTurnNoLineBreak(string):
	var message= " "+string
	battleLogText.bbcode_text+=message

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
	
func applyDamage(target,damage):target.hp-=damage
	
func killMe(h,m):self.queue_free()

func createDamageNumbers(position,direction,damage,critical=false,origin=""):
	var i=damageNumbers.instance()
	i.global_position=position
	i.direction=direction
	i.damage=damage
	i.critical=critical
	i.origin=origin
	add_child(i)

func effects(area):
	particlesAndWindowshake(area)
	knockback()

func knockback():
	if playerAttacked:
		playerAttack()
		playerAttacked=false
		playerAttacking=false
	elif enemyAttacked:
		enemyAttack()
		enemyAttacked=false
		enemyAttacking=false
#	$twnAttack.stop_all()
	randomize()
	playerSpr.global_position.y*=rand_range(0.9,1.1)
	enemySpr.global_position.y*=rand_range(0.9,1.1)
#	playerAttacking=false
	$twnPlayer.interpolate_property(playerSpr,"global_position",playerSpr.global_position*Vector2(rand_range(0.9,1.1),rand_range(0.9,1.1)),playerDefaultPos,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
	$twnPlayer.start()
	$twnEnemy.interpolate_property(enemySpr,"global_position",enemySpr.global_position*Vector2(rand_range(0.9,1.1),rand_range(0.9,1.1)),enemyDefaultPos,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
	$twnEnemy.start()
	
	
#	$twnRecoil.interpolate_property(playerSpr,"rect_position",playerSpr.rect_position,pigeonRectOffset,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
#	$twnRecoil.interpolate_property(enemySpr,"rect_position",enemySpr.rect_position,pigeonRectOffset,durationRecoil*rand_range(0.8,1.2),Tween.TRANS_BACK,Tween.EASE_OUT)
#	$twnRecoil.start()

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
	
func createHitSfx():self.add_child(hitSfx.instance())
func colorizeString(string,color="#ffffff"):return "[color="+color+"]"+String(string)+"[/color]"
func shakePlayerHpBar(intensity=5):$"marginCtn/battlePanel/battlePanelMargin/hboxCtn/battleArea/battleArea/playerCtn/playerStats".shakeHp(intensity)
func shakeEnemyHpBar(intensity=5):$"marginCtn/battlePanel/battlePanelMargin/hboxCtn/battleArea/battleArea/enemyCtn/enemyStats".shakeHp(intensity)

func gameOver():
	global.level=1
	get_tree().change_scene("res://scenes/intro.tscn")
	self.queue_free()
