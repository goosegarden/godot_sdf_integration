extends CharacterBody3D

@export var MOUSE_SENSITIVITY = 0.005
@export var gravity = 50
@export  var max_speed = 10.0
@export var jump_speed = 20

@export var active = true



var vel = Vector3()
var current_hvel = Vector3(0,0,0)
var vertical_speed = 0
var dir = Vector3()


@onready var camera = $base_cam/rotation_helper/Camera3D
@onready var cam_pos = $base_cam/rotation_helper
@onready var base_cam = $base_cam



func _ready():
	set_up_direction(Vector3.UP)
	
	add_to_group("player")
	


func _process(delta):

	if active :
		process_input(delta)
		process_movement(delta)


func process_input(delta):

	dir = Vector3()
	var cam_xform = camera.get_global_transform()
	var input_movement_vector = Vector2()

	if Input.is_action_pressed("mv_fw"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("mv_bw"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("mv_lf"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("mv_rg"):
		input_movement_vector.x += 1
	
	input_movement_vector = input_movement_vector.normalized()

	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x


	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			vertical_speed = jump_speed
		else : 
			vertical_speed = -0.2

		var bop_fac = .002
		var sintime = sin(Time.get_ticks_msec()*0.012)
		var boprot = .03
		
		if input_movement_vector.y != 0 or input_movement_vector.x != 0 :
			cam_pos.transform.origin.y += -sintime * bop_fac
		
		if input_movement_vector.x != 0 :
			camera.rotation.z = lerp_angle(camera.rotation.z, boprot * -input_movement_vector.x, 3.0 * delta)

		else : 
			camera.rotation.z = lerp_angle(camera.rotation.z, 0, 8*delta)


func process_movement(delta):
	var vel = Vector3.ZERO
	dir.y = 0

	
	vertical_speed -= delta * gravity 
	vel.y = vertical_speed

	var target  = max_speed  *dir

	current_hvel = lerp(current_hvel, target, 8.0*delta )

	vel.x = current_hvel.x
	vel.z = current_hvel.z

	set_velocity(vel)
	
	move_and_slide()
	if is_on_floor() :
		vertical_speed = 0


func _input(event):
	if active :
		if event is InputEventMouseMotion :
			var x = event.relative.x
			var y = event.relative.y
			
			base_cam.rotate_y(-x * MOUSE_SENSITIVITY)
			cam_pos.rotation.x = clamp((cam_pos.rotation.x - y * MOUSE_SENSITIVITY), -1.0,1.0)
