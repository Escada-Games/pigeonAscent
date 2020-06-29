extends RigidBody2D
var duration=0.2
var direction=1
var damage=1
var origin=""
var critical=false
func _ready():
	set_process(true)
	self.linear_velocity.x=direction*rand_range(200,400)
	self.linear_velocity.y=-rand_range(200,500)
	$label.text=String(damage)
	if critical:
		$label.text=$label.text+"!"
		self.scale*=2
	if origin=="Enemy":
		$label.modulate=Color("#FFAAAA")
	$label.rect_scale=Vector2(2,0)
	$twnScale.interpolate_property($label,"rect_scale",$label.rect_scale,Vector2(1,1),duration,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$twnScale.start()
func _process(delta):
	if self.global_position.y>OS.window_size.y:self.queue_free()
