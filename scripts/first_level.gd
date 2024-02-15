extends Node2D

var Projectile_Scene = preload("res://projectiles/projectile.tscn")
var Projectile_Scene2 = preload("res://projectiles/projectile2.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_player_summon_projectiles(pos, dir,type,color):
	var Projectile_Scene_Instance
	var Projectile_Scene_Instance2
	var Projectile_Scene_Instance3_1
	var Projectile_Scene_Instance3_2
	
	if type==1:
		Projectile_Scene_Instance = Projectile_Scene.instantiate()
		if dir==1:
			Projectile_Scene_Instance.position = pos + Vector2(30,-10)  			 
		elif dir==-1:
			var sprite=Projectile_Scene_Instance.find_child("AnimatedSprite2D")
			sprite.flip_h = true
			Projectile_Scene_Instance.dir=dir
			Projectile_Scene_Instance.position= pos + Vector2(-30, -10)
		
		Projectile_Scene_Instance.find_child("AnimatedSprite2D").material.set_shader_parameter("IncreaseFactor",color)
		add_child(Projectile_Scene_Instance)
		
		
	elif type==2:
		Projectile_Scene_Instance2 = Projectile_Scene2.instantiate()
		if dir==1:
			Projectile_Scene_Instance2.position = pos + Vector2(25,-10)  			 
		elif dir==-1:
			var sprite=Projectile_Scene_Instance2.find_child("AnimatedSprite2D")
			sprite.flip_h = true
			Projectile_Scene_Instance2.dir=dir
			Projectile_Scene_Instance2.position= pos + Vector2(-25, -10)
		
		Projectile_Scene_Instance2.find_child("AnimatedSprite2D").material.set_shader_parameter("IncreaseFactor",color)
		add_child(Projectile_Scene_Instance2)
		
		
		
	elif type==3:
		Projectile_Scene_Instance3_1 = Projectile_Scene2.instantiate()
		Projectile_Scene_Instance3_2 = Projectile_Scene2.instantiate()
		
		if dir==1:
			Projectile_Scene_Instance3_1.position = pos + Vector2(25,-10)  
			Projectile_Scene_Instance3_1.dir=1
			Projectile_Scene_Instance3_2.position = pos + Vector2(-25,-10) 
			Projectile_Scene_Instance3_2.dir=-1
			var sprite=Projectile_Scene_Instance3_2.find_child("AnimatedSprite2D")
			sprite.flip_h = true
			
			
		if dir==-1:
			Projectile_Scene_Instance3_1.position = pos + Vector2(25,-10)  
			Projectile_Scene_Instance3_1.dir=1
			Projectile_Scene_Instance3_2.position = pos + Vector2(-25,-10) 
			Projectile_Scene_Instance3_2.dir=-1
			var sprite=Projectile_Scene_Instance3_2.find_child("AnimatedSprite2D")
			sprite.flip_h = true
			
			
						 
		Projectile_Scene_Instance3_1.find_child("AnimatedSprite2D").material.set_shader_parameter("IncreaseFactor",color)
		Projectile_Scene_Instance3_2.find_child("AnimatedSprite2D").material.set_shader_parameter("IncreaseFactor",color)
		add_child(Projectile_Scene_Instance3_1)
		add_child(Projectile_Scene_Instance3_2)



func _on_player_player_started():
	$Player.position=$Marker2D.position
	$Player.ShouldReciveInput=false
	var AnimationPlayer2D=$Player.find_child("AnimationPlayer")
	var AnimatedSprite= $Player.find_child("AnimatedSprite2D")
	set_process_unhandled_input(true)
	if AnimatedSprite!=null:
		AnimatedSprite.flip_h = true
	
	$Player.IsAttacking=true
	$Player.direction=-1
	
	$Player.find_child("AnimationPlayer")
	AnimationPlayer2D.play("Death")
