extends Node3D

@onready var pp_shader = $FpsPlayer/base_cam/rotation_helper/Camera3D/pp_quad.get_surface_override_material(0)
@onready var sun = $DirectionalLight3D
@onready var sphere = $sphere
@onready var player = $FpsPlayer

var spheres_count = 10
var spheres = []

var default_sphere_radius = 2.0

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	var trs = []
	var rds = []
	for i in range(spheres_count):
		var sp = sphere.duplicate(3)
		sp.visible = true
		var t = Transform3D()
		var a = i * 30
		t = t.translated(Vector3(cos(deg_to_rad(a)), 0, sin(deg_to_rad(a))) * 20 + Vector3(0.0,2.0,0.0))
		trs.append(t)
		add_child(sp)

		sp.global_transform = t
		spheres.append(sp)
		var r = default_sphere_radius
		
		rds.append(r)
	pp_shader.set_shader_parameter("sphere_transforms", trs)
	pp_shader.set_shader_parameter("sphere_radius", rds)
	pp_shader.set_shader_parameter("sphere_count", spheres_count)
	
	var sun_dir = (-sun.global_transform.basis.z).normalized()
	pp_shader.set_shader_parameter("sun_vector", sun_dir)


func update_shader() :
	var trs = []
	var rds = []
	for i in range(spheres_count):
		
		var sp = spheres[i]
		
		var t = sp.global_transform

		trs.append(t)
		var r =default_sphere_radius
		rds.append(r)
	pp_shader.set_shader_parameter("sphere_transforms", trs)
	pp_shader.set_shader_parameter("sphere_radius", rds)


func _physics_process(delta):
	update_shader()


func _process(delta):
	pass



func _on_area_3d_body_entered(body):
	if body.is_in_group("sphere") :
		var impulse_vec = player.velocity * 0.1
		impulse_vec.y = 0
		var r = randf()
		body.apply_impulse(impulse_vec )
		if r >0.5 :
			body.get_node("fx").play()
		else :
			body.get_node("hum").play()

