extends PanelContainer
var offset=0
var duration=0.75
var defaultPos=Vector2()
export(bool) var entering=false
export(bool) var showStats=false
export(bool) var compact=false
export(bool) var checkVisibility=false
var targetPos=Vector2()
var durationEnter=2
func _ready():
	var _s1=$twnOffset.connect("tween_completed",self,"resetProcess")
	defaultPos=$marginContainer/vbox/vboxBars/hpBox.rect_position
	set_process(false)
	if compact:
		$marginContainer/vbox/invSep2.visible=false
		$marginContainer/vbox/abilities.visible=false
		$marginContainer/vbox/abilitiesText.visible=false
	else:
		$marginContainer/vbox/invSep2.visible=true
		$marginContainer/vbox/abilities.visible=true
		$marginContainer/vbox/abilitiesText.visible=true
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
func shakeHp(newOffset=5):
	offset=newOffset#*sign(randf()-0.5)
	$twnOffset.interpolate_property(self,"offset",self.offset,0,self.duration,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$twnOffset.start()
	set_process(true)
func resetProcess():
	return
#	set_process(false)
