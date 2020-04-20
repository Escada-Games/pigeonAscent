extends RigidBody2D
var direction=1
var damage=1
var critical=false
func _ready():
	set_process(true)
	self.linear_velocity.x=direction*rand_range(10,200)
	self.linear_velocity.y=-rand_range(200,500)
	$label.text=String(damage)
	if critical:
		self.scale*=2
func _process(delta):
	if self.global_position.y>OS.window_size.y:self.queue_free()
