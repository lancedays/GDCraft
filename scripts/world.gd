extends Node3D

@onready var S_BLOCK = preload("res://scenes/block.tscn")
@onready var BLOCK_CONTAINER = $Blocks

@export var WORLD_GEN_RADIUS = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_world()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_world():
	for x in range(-WORLD_GEN_RADIUS, WORLD_GEN_RADIUS + 1):
		for z in range(-WORLD_GEN_RADIUS, WORLD_GEN_RADIUS + 1):
			var block = S_BLOCK.instantiate()
			block.transform = Transform3D(Basis(), Vector3(x,0,z))
			BLOCK_CONTAINER.add_child(block)
