extends Node2D

var speed=10
var dir=1


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("projectileAnime")
	$TimeToDie.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if dir==1:
		position.x=position.x+speed
	elif dir==-1:
		position.x=position.x-speed
	



func _on_time_to_die_timeout():
	queue_free()
