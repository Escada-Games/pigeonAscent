extends HBoxContainer

func _ready()->void:
	self.rect_pivot_offset=self.rect_size/2
	pass

func _on_hpBox_mouse_entered()->void:
	$twn.stop_all()
	$twn.interpolate_property(self,'rect_scale',self.rect_scale,Vector2(1.02,1.02),0.33,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$twn.start()

func _on_hpBox_mouse_exited()->void:
	$twn.stop_all()
	$twn.interpolate_property(self,'rect_scale',self.rect_scale,Vector2(1,1),0.33,Tween.TRANS_QUINT,Tween.EASE_IN)
	$twn.start()
