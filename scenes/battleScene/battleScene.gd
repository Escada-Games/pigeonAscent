extends Control
var playerStamina=0
var enemyStamina=0
var turn=1
func _ready():
	set_process(true)
func _process(delta):
	playerStamina+=global.player.speed*delta*global.scaling.speed
	if playerStamina>100:
		playerStamina=0
		playerAttack()
	enemyStamina+=global.enemy.speed*delta*global.scaling.speed
	if enemyStamina>100:
		enemyStamina=0
		enemyAttack()

func playerAttack():
	var damage=int(rand_range(0.8,1.2)*global.player.strength*global.scaling.strength)
	register(global.player.name + " attacks for " +String(damage)+ " damage")
	pass
func enemyAttack():
	pass

func register(string):
	var message="#"+String(turn)+"> "+string+"\n"
	$marginCtn/vboxCtn/hboxCtnTop/panelContainer/richTextLabel.bufferedMessage+=message
	turn+=1


