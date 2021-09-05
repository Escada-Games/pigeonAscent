extends RigidBody2D
var duration=0.4
var direction=1
var damage=1
var origin=""
var critical=false
func _ready():
	#print_debug(self.origin)
	if critical:
		$label.text=$label.text+"!"
		self.scale*=1.5
		$label.rect_scale*=1.5
	set_process(true)
	self.angular_velocity=direction*rand_range(0.5,1.5)
	self.linear_velocity.x=direction*rand_range(200,400)
	self.linear_velocity.y=-rand_range(200,500)
	$label.text=str(int(damage))
	if origin=="Enemy":$label.modulate=Color('#eb001e')#Color("#A30015")#Color("#FFAAAA")
	self.modulate.a=0
	$label.rect_pivot_offset=$label.rect_size/2
	$twnScale.interpolate_property(self,"scale:x",4,self.scale.x,duration,Tween.TRANS_BACK,Tween.EASE_OUT)
	$twnScale.interpolate_property(self,"scale:y",0,self.scale.y,duration,Tween.TRANS_BACK,Tween.EASE_OUT)
	$twnScale.interpolate_property(self,"modulate:a",0,1,duration/4,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$twnScale.start()
func _process(_delta):
	if self.global_position.y>OS.window_size.y:self.queue_free()
