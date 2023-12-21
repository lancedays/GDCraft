extends Node3D

@onready var block_scene = preload("res://scenes/block.tscn")
@onready var chunk_scene = preload("res://scenes/chunk.tscn")
@onready var player_scene = preload("res://scenes/player.tscn")
@onready var block_container = $Blocks

@export var CHUNK_SIZE = Vector3(16, 256, 16)  # Width, Height, Length
@export var WORLD_GEN_RADIUS = 1

func _ready():
	generate_world()
	spawn_player()

func spawn_player():
	var spawn_x = 0
	var spawn_z = 0
	var spawn_y = CHUNK_SIZE.y + 1

	var player = player_scene.instantiate()
	add_child(player)
	player.global_transform.origin = Vector3(spawn_x, spawn_y, spawn_z)

func generate_world():
	var min_chunk_coord = -WORLD_GEN_RADIUS
	var max_chunk_coord = WORLD_GEN_RADIUS

	for x_chunk in range(min_chunk_coord, max_chunk_coord + 1):
		for z_chunk in range(min_chunk_coord, max_chunk_coord + 1):
			var chunk = chunk_scene.instantiate()
			block_container.add_child(chunk)
			chunk.global_transform.origin = Vector3(x_chunk * CHUNK_SIZE.x, 0, z_chunk * CHUNK_SIZE.z)
			generate_chunk(chunk)

func generate_chunk(chunk):
	for x in range(CHUNK_SIZE.x):
		for y in range(CHUNK_SIZE.y):
			for z in range(CHUNK_SIZE.z):
				var block = block_scene.instantiate()
				block.transform = Transform3D(Basis(), Vector3(x, y, z))
				chunk.add_child(block)
