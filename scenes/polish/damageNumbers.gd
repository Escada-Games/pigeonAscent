extends RigidBody2D
var duration=0.8
var direction=1
var damage=1
var origin=""
var critical=false
func _ready():
	set_process(true)
	self.linear_velocity.x=direction*rand_range(200,400)
	self.linear_velocity.y=-rand_range(200,500)
	$label.text=String(int(damage))
	if critical:
		$label.text=$label.text+"!"
		self.scale*=2
		$label.rect_scale*=2
	if origin=="Enemy":
		$label.modulate=Color("#FFAAAA")
#	$twnScale.interpolate_property($label,"rect_scale",Vector2(3,0),Vector2(1,1),duration,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
#	$twnScale.start()
func _process(delta):
	if self.global_position.y>OS.window_size.y:self.queue_free()
