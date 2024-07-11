extends CharacterBody3D

@onready var camera = $Camera3D

var type = "follow_cam"

var MOUSE_SENSITIVITY_Y = .1
var MOUSE_SENSITIVITY_X = .05

var last_mlook_y = 0
var last_mlook_x = 0

var vel = Vector3(0,0,0)
var current_vel = Vector3(0,0,0)

@export var speed = 24
@export var max_speed = 48

@export var active = true
@export var mouselook = true

func _ready():
	
	if mouselook :
		activate()
	else : 
		deactivate()
	
func _physics_process(delta):
	if active :
		process_input()
		move(delta)

func move(delta) :
	var wish_vel = vel * max_speed
	var new_vel = lerp(current_vel, wish_vel, delta*10.0)
	set_velocity(new_vel)
	move_and_slide()
	current_vel = velocity

func switch_mode() :
	if active : 
		active = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else : 
		active = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func activate() :
	active = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func deactivate() :
	active = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	


func process_input() :
	vel = Vector3(0,0,0)
	if Input.is_action_pressed("mv_fw") :
		vel.z -= 1
	if Input.is_action_pressed("mv_bw") :
		vel.z += 1
	if Input.is_action_pressed("mv_lf") :
		vel.x -= 1
	if Input.is_action_pressed("mv_rg") :
		vel.x += 1
	if Input.is_action_pressed("mv_up") :
		vel.y += 1
	if Input.is_action_pressed("mv_dn") :
		vel.y -= 1
	

	vel = vel.normalized()
	vel = global_transform.basis * (vel)
	

	
		
func _input(event):
	if active : 
		if event is InputEventMouseMotion :
			var wished_r_y = event.relative.x * MOUSE_SENSITIVITY_Y
			var wished_r_x = event.relative.y * MOUSE_SENSITIVITY_X * -1.0
			#rotate_y(clamp(-deg_to_rad(wished_r_y),-.1,.1))
			rotate_y(-deg_to_rad(wished_r_y))
			#$Camera3D.rotate_x(clamp(deg_to_rad(wished_r_x),-.1,.1))
			$Camera3D.rotate_x(deg_to_rad(wished_r_x))
