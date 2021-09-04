extends Label
var bIsPlayerStats:=false
func _ready():
	self.rect_pivot_offset=self.rect_size/2
	set_process(true)
func _process(_delta):
	if bIsPlayerStats:
		self.text=global.pigeonDict[global.player['class']]['skill']
		self.hint_tooltip=global.pigeonDict[global.player['class']]['skillDescription']
	else:
		self.text=global.pigeonDict[global.enemy['class']]['skill']
		self.hint_tooltip=global.pigeonDict[global.enemy['class']]['skillDescription']


func _on_strSkill_mouse_entered():
	$twn.stop_all()
	$twn.interpolate_property(self,'rect_scale',self.rect_scale,Vector2(1.02,1.02),0.33,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$twn.start()


func _on_strSkill_mouse_exited():
	$twn.stop_all()
	$twn.interpolate_property(self,'rect_scale',self.rect_scale,Vector2(1,1),0.33,Tween.TRANS_QUINT,Tween.EASE_IN)
	$twn.start()


