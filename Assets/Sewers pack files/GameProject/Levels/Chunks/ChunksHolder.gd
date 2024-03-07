extends Node2D

@export var speed = 30

const CHUNK_WIDTH =  500 #360

var chunk_index = 1

var chunks_array = [
	"res://Levels/Chunks/ChunkPieces/chunk_01.tscn",
	"res://Levels/Chunks/ChunkPieces/chunk_02.tscn",
	"res://Levels/Chunks/ChunkPieces/chunk_03.tscn",
]



func _physics_process(delta):
	
	global_position.x -= speed * delta

	if global_position.x <= -CHUNK_WIDTH * (chunk_index ):
		chunk_index += 1
		var random_chunk = randi() % chunks_array.size()
		spawn_chunk(chunks_array[random_chunk], CHUNK_WIDTH * chunk_index )
		

func spawn_chunk(path: String, position_x: int):
	var chunk = load(path).instantiate()
	chunk.position.x = position_x
	chunk.z_index = 1
	call_deferred("add_child", chunk)
	


	
	

