extends Node

class_name EnemySpawner
const SPAWN_ANIM = preload("uid://b872n84ckwb1a")
@onready var spawner_timer: Timer = $SpawnerTimer

enum SpawnType{
	RandomTimer,
	FixedTimer
}

@export_group("Spawn")
@export var spawn_type: SpawnType

@export var min_random: float
@export var max_random: float
@export var fixed_time: float
@export var enemies_per_wave: int = 5

@export var enemy_list: Array[PackedScene] = []

var enemy_remaining: int
var spawned_enemies: int

func _ready() -> void:
	start_enemy_timer()

func spawn_enemy() -> void:
	var spawn_anim: = SPAWN_ANIM.instantiate()
	var pos_x = randf_range(-1000,1000)
	var pos_y = randf_range(-1000,1000)
	var spawn_pos := Vector2(pos_x,pos_y)
	spawn_anim.global_position = spawn_pos
	add_child(spawn_anim)
	#等待动画播放完毕，执行发射信号的函数
	await spawn_anim.on_spawn_enemy
	#销毁动画
	spawn_anim.queue_free()
	
	var random_enemy: PackedScene = enemy_list.pick_random() as PackedScene
	var enemy = random_enemy.instantiate() as Enemy
	enemy.global_position = spawn_pos
	get_parent().add_child(enemy)
	spawned_enemies += 1
	start_enemy_timer()

func start_enemy_timer() -> void:
	spawner_timer.wait_time = get_new_time()
	spawner_timer.start()

func get_new_time() -> float:
	var time: float
	if spawn_type == SpawnType.RandomTimer:
		time = randf_range(min_random,max_random)
	else:
		time = fixed_time
	return time



func _on_spawner_timer_timeout() -> void:
	
	if spawned_enemies >= enemies_per_wave:
		return
	#如果小于没播次生成敌人
	spawn_enemy()
	
