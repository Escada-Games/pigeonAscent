extends AudioStreamPlayer
var fMusicVolume:=0.0
var iMusicBusIdx:=-1
func _ready():
	iMusicBusIdx=AudioServer.get_bus_index('Music')
	var _s1 = $tween.connect("tween_step",self,'updateVolume')
	
	$tween.interpolate_property(self,'fMusicVolume',self.fMusicVolume,-20,1.0,Tween.TRANS_QUINT,Tween.EASE_IN)
	$tween.start()
	
	yield(get_tree().create_timer(0.8),'timeout')
	self.play()
	yield(self,"finished")
	
	$tween.interpolate_property(self,'fMusicVolume',self.fMusicVolume,0,0.3,Tween.TRANS_QUINT,Tween.EASE_IN)
	$tween.start()
	yield($tween,"tween_all_completed")
	self.queue_free()
	
func updateVolume(_a,_b,_c,_d):
	AudioServer.set_bus_volume_db(self.iMusicBusIdx,self.fMusicVolume)
