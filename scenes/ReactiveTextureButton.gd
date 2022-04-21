extends TextureButton
class_name ReactiveTextureButton
var nTwn := Tween.new()
func _ready() -> void:
	add_child(nTwn)
	var _s1:=self.connect("mouse_entered",self,"_mouseEnter")
	var _s2:=self.connect("mouse_exited",self,"_mouseExit")
	self.rect_pivot_offset = self.rect_size/2
	ready()

func _mouseEnter() -> void:
	global.createHoverSfx()
	var _v1:=nTwn.interpolate_property(self,'rect_scale',Vector2(1,1),Vector2(1,1)*1.1,0.4,Tween.TRANS_BACK,Tween.EASE_OUT)
	var _v2:=nTwn.start()
	mouseEnter()
func _mouseExit() -> void:
	var _v1:=nTwn.interpolate_property(self,'rect_scale',Vector2(1,1)*1.1,Vector2(1,1),0.33,Tween.TRANS_QUAD,Tween.EASE_IN)
	var _v2:=nTwn.start()
	mouseExit()

func ready() -> void:pass
func mouseEnter() -> void:pass
func mouseExit() -> void:pass
