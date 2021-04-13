extends Control
func _ready():
	if $marginContainer/opponentPanel/twnPosition.is_active():
		$colorRect.modulate.a=0
	#$marginContainer/opponentPanel/twnPosition.connect("tween_all_completed",self,'darkenBg')
	darkenBg()
	$marginContainer/opponentPanel/btnExit/twnPosition.connect("tween_started",self,'lightenBg')
func darkenBg():
	$twn.interpolate_property($colorRect,'modulate:a',$colorRect.modulate.a,0.66,1.0,Tween.TRANS_QUINT,Tween.EASE_IN)
	$twn.start()
func lightenBg():
	$twn.interpolate_property($colorRect,'modulate:a',$colorRect.modulate.a,0,0.33,Tween.TRANS_QUINT,Tween.EASE_IN)
	$twn.start()
