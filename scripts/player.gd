extends CharacterBody3D

var highlight_material = preload("res://assets/shaders/new_shader_material.tres")
var speed = 5
var mouse_sensitivity = 0.1
var jump_force = 5  # Adjust this value to control the jump height
var gravity = -9.8  # Adjust this to control gravity's effect
var look_ray_length = 2
var last_highlighted_object = null
var last_highlighted_mesh = null
var is_noclip = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		$Camera3D.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	if Input.is_action_just_pressed("toggle_noclip"):
		is_noclip = !is_noclip
		if is_noclip:
			speed = 15
			gravity = 0
		else:
			speed = 5
			gravity = -9.8

func _physics_process(delta):
	handle_input(delta)

func handle_input(delta):
	if is_noclip:
		handle_noclip_input(delta)
	else:
		handle_normal_input(delta)

func handle_noclip_input(delta):
	var forward = -transform.basis.z.normalized()
	var right = transform.basis.x.normalized()
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction -= forward
	if Input.is_action_pressed("move_backward"):
		direction += forward
	if Input.is_action_pressed("move_right"):
		direction -= right
	if Input.is_action_pressed("move_left"):
		direction += right
	if Input.is_action_pressed("move_up"):
		direction += Vector3.UP
	if Input.is_action_pressed("move_down"):
		direction -= Vector3.UP

	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	translate(direction * speed * delta)

func handle_normal_input(delta):
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
