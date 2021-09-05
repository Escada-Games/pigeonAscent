extends PanelContainer
var offset:=0
var duration:=1.0
var defaultPos:=Vector2()
export(bool) var entering:=false
export(bool) var showStats:=false
export(bool) var compact:=false
export(bool) var checkVisibility:=false
export(bool) var bIsPlayerStats:=false
var targetPos:=Vector2()
var durationEnter:=2

onready var nLifebar=$marginContainer/vbox/vboxBars/hpBox/vbox/lifebar
func _ready():
	if bIsPlayerStats:
		$marginContainer/vbox/strName.bIsPlayerStats=true
		$marginContainer/vbox/vboxBars/hpBox/vbox/lifebar.bIsPlayerStats=true
		$marginContainer/vbox/vboxBars/hpBox/vbox/strLife.bIsPlayerStats=true
		$marginContainer/vbox/vboxBars/foodBox/vbox/foodBar.bIsPlayerStats=true
		$marginContainer/vbox/vboxBars/foodBox/vbox/strFood.bIsPlayerStats=true
		$marginContainer/vbox/strSkill.bIsPlayerStats=true
	
	if checkVisibility:var _s1=get_tree().root.connect("size_changed",global,"shouldIBeInvisible",[self])
	var _s2=$twnOffset.connect("tween_completed",self,"resetProcess")
	defaultPos=$marginContainer/vbox/vboxBars/hpBox.rect_position
	set_process(false)
	if entering:
		randomize()
		duration*=rand_range(0.5,1.5)
		targetPos=self.rect_global_position
		self.rect_global_position.y=-1.5*self.rect_size.y
		var twnEnter=Tween.new()
		add_child(twnEnter)
		twnEnter.interpolate_property(self,"rect_global_position:y",self.rect_global_position.y,targetPos.y,durationEnter,Tween.TRANS_QUART,Tween.EASE_OUT)
		twnEnter.start()

func _process(_delta):
	$marginContainer/vbox/vboxBars/hpBox.rect_position=defaultPos+offset*Vector2(randf()-0.5,randf()-0.5)
	
func shakeHp(newOffset=32):
	offset=newOffset*(-1 if randf()<0.5 else 1)
	$twnOffset.interpolate_property(self,
									"offset",
									self.offset,
									0,
									self.duration,
									Tween.TRANS_QUAD,
									Tween.EASE_OUT)
	$twnOffset.start()
	set_process(true)
func resetProcess(_a=0,_b=0):
	set_process(false)
