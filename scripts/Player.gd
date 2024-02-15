# This script is based on the default CharacterBody2D template. Not much interesting happening here.
extends CharacterBody2D

const SPEED = 300.0
var accel=5
const JUMP_VELOCITY = -450.0
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation: String
var reset_position: Vector2
var event: bool
var abilities: Array[StringName]
var double_jump=false
var IsSitting:bool
var prev_on_floor: bool
var direction
var PreviousDirection=-1
var prev_velocity_y=0
signal PlayerStarted
var coyote=false
var IsAttacking=false
var new_animation
var PlayerState="BeforeAttack"
var ShouldReciveInput=true


var FirstAttackFinished=false
var SecondAttackFinished=false
var ThirdAttackFinished=false
var FirstJumpAttackFinish=false
var SecondJumpAttackFinish=false
var ThirdJumpAttackFinish=false
var JT3EndFinish=false
var CastAnimeFinish=false
var CheckForAttack=false;
var CheckForDodge=false;
var attackInBuffer=false;
var DodgeInBuffer=false;
var AirAttackInBuffer=false;
var AirAttackAttack=true;
var CanDodge=true
var CanAirDash=true
var DodgeAnimeFinish=false
var AirDashAnimeFinish=false
var MoveDodge=false
var UpdateAnimation=true
var RateOfChangeOfColor=0.033
var color=0
var flick=1;
var frameCount=0
var CanCast=true


signal SummonProjectiles(pos,dir,type,color)






func _physics_process(delta: float) -> void:
	
	
	
	print($SkillCD.get_time_left ( ))
	$CanvasLayer2/TextureProgressBar.value=$SkillCD.get_time_left ( )
	
	
	
	frameCount+=1
	$AnimatedSprite2D.material.set_shader_parameter("enable_silhouette",-1)
	
	if PlayerState=="AirDash" and frameCount%2==0:
		flick=flick*-1
		frameCount=0
		$AnimatedSprite2D.material.set_shader_parameter("enable_silhouette",flick)



		
	if MoveDodge==true:
		DodgeMoveForward()
		
	if CheckForAttack==true and Input.is_action_just_pressed("attack") and is_on_floor():
		attackInBuffer=true
	
	if CheckForAttack==true and Input.is_action_just_pressed("attack") and (!is_on_floor()):
		AirAttackInBuffer=true
			

		


	#if is_on_floor() and prev_velocity_y > 1000:
		#Death()
		

	if velocity.y > prev_velocity_y:
		prev_velocity_y = velocity.y	
	if is_on_floor():
		prev_velocity_y = 0.0
		AirAttackInBuffer=false
		AirAttackAttack=true
		CanAirDash=true
		
		
	if event:
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	elif not prev_on_floor :
		# Some simple double jump implementation.
		double_jump = true
	
	if Input.is_action_just_pressed("ui_accept") and IsAttacking==false and (is_on_floor() or double_jump or coyote==true ):
		
		if not is_on_floor() and coyote==false :
			double_jump = false
		
		if Input.is_action_pressed("ui_down"):
			$CollisionShape2D.set_disabled(true);
			$DownCollisionDisabledCD.start()

		else:
			velocity.y = JUMP_VELOCITY
	
	
	direction = Input.get_axis("ui_left", "ui_right")
	if (direction==1 or direction==-1) and (PlayerState!="dodge" and PlayerState!="Cast"  and PlayerState!="ThirdJumpAttack"):
			PreviousDirection=direction
			
	if direction and IsAttacking==false and PlayerState!="ThirdJumpAttack" :
			velocity.x =  direction * SPEED
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	if prev_on_floor and !is_on_floor():
		coyote=true
		$Coyote.start()	

	prev_on_floor = is_on_floor()

		
	if IsAttacking==false or PlayerState=="dodge" or PlayerState=="AirDash" :
		move_and_slide()
		
	if Input.is_action_just_pressed("Sit"):
		IsSitting=true
	if Input.is_action_just_released("Sit"):
		IsSitting=false
	
	
	if IsAttacking==false :
	
		new_animation = &"Idle"
		
		if is_on_floor() and IsSitting and absf(velocity.x)==0:
			new_animation = &"Sit"

		elif velocity.y < 0 and double_jump==false:
			new_animation = &"double_jump"
		elif velocity.y < 0:
			new_animation = &"Jump"	
		elif velocity.y >= 0 and not is_on_floor():
			new_animation = &"Fall"
		elif absf(velocity.x) > 1:
			new_animation = &"Run"
		
		if new_animation != animation and UpdateAnimation:
			animation = new_animation
			$AnimationPlayer.play(new_animation)
		
		if velocity.x > 1:
			$AnimatedSprite2D.flip_h = false
		elif velocity.x < -1:
			$AnimatedSprite2D.flip_h = true
			
	
	if Input.is_action_just_pressed("Cast") and is_on_floor() and PlayerState=="BeforeAttack"  and  CanCast==true and ShouldReciveInput :
		ChangeColorToGreyAndRed()
		PlayerState="Cast"
		IsAttacking=true
		CastAnimeFinish=false
		CanCast=false
		$SkillCD.start()
		$AnimationPlayer.play("Cast")
	elif Input.is_action_just_pressed("Slide")  and !is_on_floor() and CanAirDash and ShouldReciveInput :
		
		PlayerState="AirDash"
		velocity.y=0
		CanAirDash=false
		IsAttacking=true
		AirDashAnimeFinish=false
		$AnimationPlayer.play("JumpDash")
			
	elif Input.is_action_just_pressed("Slide")  and is_on_floor() and CanDodge and ShouldReciveInput :
		
		PlayerState="dodge"
		IsAttacking=true
		DodgeAnimeFinish=false
		$AnimationPlayer.play("Slide")

		
	elif Input.is_action_just_pressed("attack") and is_on_floor() and PlayerState=="BeforeAttack"   and ShouldReciveInput :
		
		PlayerState="FirstAttack"
		IsAttacking=true
		FirstAttackFinished=false
		
		$AnimationPlayer.play("FirstSlash")
		
	elif  is_on_floor() and PlayerState=="FirstAttack"  and FirstAttackFinished and attackInBuffer and ShouldReciveInput:
		PlayerState="SecondAttack"
		attackInBuffer=false
		IsAttacking=true
		SecondAttackFinished=false
		$AnimationPlayer.play("SecondSlash")
		
	elif  is_on_floor() and PlayerState=="SecondAttack"  and SecondAttackFinished and attackInBuffer and ShouldReciveInput:
		
		PlayerState="ThirdAttack"
		attackInBuffer=false
		IsAttacking=true
		ThirdAttackFinished=false
		$AnimationPlayer.play("ThirdSlash")
		
		
	
	elif  is_on_floor() and PlayerState=="FirstAttack"  and FirstAttackFinished and !attackInBuffer and ShouldReciveInput:
		PlayerState="BeforeAttack"
		IsAttacking=false
	
	elif  is_on_floor() and PlayerState=="SecondAttack"  and SecondAttackFinished and !attackInBuffer and ShouldReciveInput:
		PlayerState="BeforeAttack"
		IsAttacking=false
		
	elif  is_on_floor() and PlayerState=="ThirdAttack"  and ThirdAttackFinished and !attackInBuffer and ShouldReciveInput:
		PlayerState="BeforeAttack"
		IsAttacking=false
	 

	
	elif Input.is_action_just_pressed("attack") and PlayerState=="BeforeAttack" and !is_on_floor() and AirAttackAttack==true and ShouldReciveInput:
		PlayerState="FirstJumpAttack"
		IsAttacking=true
		FirstJumpAttackFinish=false
		$AnimationPlayer.play("JT")
		
	elif  !is_on_floor() and PlayerState=="FirstJumpAttack" and FirstJumpAttackFinish==true and AirAttackInBuffer and AirAttackAttack==true and ShouldReciveInput:
		
		PlayerState="SecondJumpAttack"
		IsAttacking=true
		AirAttackInBuffer=false
		SecondJumpAttackFinish=false
		$AnimationPlayer.play("JT2")
		
	
	elif  !is_on_floor() and PlayerState=="SecondJumpAttack" and SecondJumpAttackFinish==true and AirAttackInBuffer and AirAttackAttack==true and ShouldReciveInput:
		
		PlayerState="ThirdJumpAttack"
		CanDodge=false
		IsAttacking=false
		AirAttackInBuffer=false
		ThirdJumpAttackFinish=false
		AirAttackAttack=false
		UpdateAnimation=false
		$AnimationPlayer.play("JT3")
		
		
	elif  !is_on_floor() and PlayerState=="FirstJumpAttack" and FirstJumpAttackFinish==true and !AirAttackInBuffer and ShouldReciveInput:
		PlayerState="BeforeAttack"
		IsAttacking=false
		AirAttackAttack=false
		
		
	elif  !is_on_floor() and PlayerState=="SecondJumpAttack" and SecondJumpAttackFinish==true and !AirAttackInBuffer and ShouldReciveInput:
		PlayerState="BeforeAttack"
		IsAttacking=false
		AirAttackAttack=false
		
	elif  PlayerState=="ThirdJumpAttack" and is_on_floor() and ShouldReciveInput:
		PlayerState="LastPartOfJumpAttack"
		CanDodge=false
		IsAttacking=true
		AirAttackAttack=true
		UpdateAnimation=false
		JT3EndFinish=false
		$AnimationPlayer.play("JT3End")
		
	elif  PlayerState=="LastPartOfJumpAttack" and JT3EndFinish:
		PlayerState="BeforeAttack"
		IsAttacking=false
		CanDodge=true
		AirAttackAttack=true
		UpdateAnimation=true
		JT3EndFinish=false
		
	elif PlayerState=="Cast" and CastAnimeFinish:
		SummonProjectiles.emit(position,PreviousDirection,1,color)
		PlayerState="BeforeAttack"
		IsAttacking=false
		AirAttackAttack=false
		
	elif  PlayerState=="dodge" and DodgeAnimeFinish :
		
		PlayerState="BeforeAttack"
		IsAttacking=false
		
	elif  PlayerState=="dodge" and !is_on_floor() :
		
		IsAttacking=false
		MoveDodge=false
		velocity=Vector2(0,0)
		accel=0
		PlayerState="BeforeAttack"
		
	elif  PlayerState=="AirDash" and AirDashAnimeFinish==true :
		
		velocity=Vector2(0,0)
		PlayerState="BeforeAttack"
		IsAttacking=false
		
		


func _ready():
	$CanvasLayer/ColorRect.material.set_shader_parameter("saturation_factor",1)
	$AnimatedSprite2D.material.set_shader_parameter("IncreaseFactor",0)
	PlayerStarted.emit()
	$Diallouge.set_visible(false)

func Death():
	PlayerStarted.emit()
	$AnimationPlayer.play("Death")
	PlayerState="Death"
	IsAttacking=true
	
	
func _on_coyote_timeout():
	coyote=false


func _on_down_collision_disabled_cd_timeout():
	$CollisionShape2D.set_disabled(false);



func _on_animation_player_animation_finished(anim_name):
	
	if anim_name=="FirstSlash":
		
		$AnimationPlayer.play(new_animation)
		FirstAttackFinished=true
		
	elif anim_name=="SecondSlash":
		
		
		SecondAttackFinished=true
		$AnimationPlayer.play(new_animation)
		
	elif anim_name=="ThirdSlash":
		
		
		ThirdAttackFinished=true
		$AnimationPlayer.play(new_animation)

		
	elif anim_name=="JT":
		
		FirstJumpAttackFinish=true
		$AnimationPlayer.play(new_animation)
		
	elif anim_name=="JT2":
		
		SecondJumpAttackFinish=true
		$AnimationPlayer.play(new_animation)
		
	elif anim_name=="JT3End":
		JT3EndFinish=true
		$AnimationPlayer.play(new_animation)
		
		
	elif anim_name=="Slide":
		
		DodgeAnimeFinish=true
		$AnimationPlayer.play(new_animation)
		
	elif anim_name=="JumpDash":
		
		AirDashAnimeFinish=true
		$AnimationPlayer.play(new_animation)
		
	elif anim_name=="Cast":
		
		CastAnimeFinish=true
		$AnimationPlayer.play(new_animation)
		
	elif anim_name=="Death":
		
		$Diallouge.set_visible(true)
		$Diallouge/Timer.start()
		
		
		
		
		

		

func CheckForAttackInputTrue():
	CheckForAttack=true
	
func CheckForAttackInputFalse():
	CheckForAttack=false
	
func CheckForDodgeTrue():
	CheckForDodge=true
	
func CheckForDodgeFalse():
	CheckForDodge=false
	
func DashForwardForThirdAttack():
	if direction==1:
		position.x=position.x+20
		$AnimatedSprite2D.flip_h = false
		
	if direction==-1:
		position.x=position.x-20
		$AnimatedSprite2D.flip_h = true
	

func DodgeMoveForward():
	if PreviousDirection==1:
		position.x=position.x+accel
		$AnimatedSprite2D.flip_h = false
		
	if PreviousDirection==-1:
		position.x=position.x-accel
		$AnimatedSprite2D.flip_h = true
	
func SetMoveDodgeTrue():
	MoveDodge=true
	
func SetMoveDodgeFalse():
	MoveDodge=false
	
func SetCanDodgeTrue():
	CanDodge=true
	
func SetCanDodgeFalse():
	CanDodge=false

func SetAccel(x):
	accel=x
	
func SetCanAirDashFalse():
	CanAirDash=false

func SendProjectileSignal(x):
	SummonProjectiles.emit(position,PreviousDirection,x,color)

func ChangeColorToGreyAndRed():
	
	var saturation_factor =$CanvasLayer/ColorRect.material.get_shader_parameter("saturation_factor")
	color+=0.026
	
	if saturation_factor>0:
		$CanvasLayer/ColorRect.material.set_shader_parameter("saturation_factor",saturation_factor-RateOfChangeOfColor)
	$AnimatedSprite2D.material.set_shader_parameter("IncreaseFactor",color)
	
			

func _on_timer_timeout():
	$Diallouge.set_visible(false)
	IsAttacking=false
	ShouldReciveInput=true


func _on_skill_cd_timeout():
	CanCast= true
