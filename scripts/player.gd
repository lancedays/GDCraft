extends CharacterBody3D
var highlight_material = preload("res://assets/shaders/new_shader_material.tres")
# Movement speed and variables
var speed = 5
var mouse_sensitivity = 0.1
var jump_force = 5  # Adjust this value to control the jump height
var gravity = -9.8  # Adjust this to control gravity's effect
var look_ray_length = 2
var last_highlighted_object = null
var last_highlighted_mesh = null

func _ready():
	# Hide the cursor and capture it
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		$Camera3D.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	handle_input(delta)
	handle_player_look_at(delta)

func handle_input(delta):
	var forward = -transform.basis.z.normalized()
	var right = transform.basis.x.normalized()

	var input_vector = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		input_vector += forward
	if Input.is_action_pressed("move_backward"):
		input_vector -= forward
	if Input.is_action_pressed("move_right"):
		input_vector += right
	if Input.is_action_pressed("move_left"):
		input_vector -= right

	input_vector = input_vector.normalized()

	# Use the velocity property of CharacterBody3D
	velocity.x = input_vector.x * speed
	velocity.z = input_vector.z * speed
	
	# Apply gravity
	velocity.y += gravity * delta

	# Check for jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
	
	# Move and slide using the velocity
	move_and_slide()
	if is_on_floor():
		velocity.y = 0

func handle_player_look_at(delta):
	var space_state = get_world_3d().direct_space_state
	var cam = $Camera3D
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * look_ray_length
	var query = PhysicsRayQueryParameters3D.new()
	query.from = origin
	query.to = end
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)

	# Reset shader on previously highlighted mesh
	if last_highlighted_mesh:
		last_highlighted_mesh.material_override = null

	if result and result.collider:
		# Check for a MeshInstance3D child in the hit StaticBody3D
		var hit_mesh = find_mesh_instance_child(result.collider)
		if hit_mesh:
			hit_mesh.material_override = highlight_material
			last_highlighted_mesh = hit_mesh
	else:
		last_highlighted_mesh = null

func find_mesh_instance_child(node):
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		if child is MeshInstance3D:
			return child
	return null
