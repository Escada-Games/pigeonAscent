extends Control
func _ready():
	if $marginContainer/opponentPanel/twnPosition.is_active():
		$colorRect.modulate.a=0
	darkenBg()
	var _s1 = $marginContainer/opponentPanel/btnExit/twnPosition.connect("tween_started",self,'lightenBg')
func darkenBg():
	$twn.interpolate_property($colorRect,'modulate:a',$colorRect.modulate.a,0.66,1.0,Tween.TRANS_QUINT,Tween.EASE_IN)
	$twn.start()
func lightenBg():
	$twn.interpolate_property($colorRect,'modulate:a',$colorRect.modulate.a,0,0.33,Tween.TRANS_QUINT,Tween.EASE_IN)
	$twn.start()
