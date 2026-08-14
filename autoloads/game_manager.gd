extends Node

signal on_enemy_died
#预加载爆炸动画资源
const EXPLORE_ANIM = preload("uid://wn3j770b40go")
const COIN = preload("uid://ce1c80tw2s4g1")

#角色引用
var player: Player
var coins: int = 600


func play_explosion_anim(pos: Vector2) -> void:
	var anim: AnimatedSprite2D = EXPLORE_ANIM.instantiate() as AnimatedSprite2D
	anim.global_position = pos
	anim.z_index = 99
	get_parent().add_child(anim)
	await anim.animation_finished
	anim.queue_free()

func create_coin(pos: Vector2) -> void:
	var random_value = randf_range(0.0,100.0)
	if random_value <= 70:
		var coin := COIN.instantiate() as Coin
		coin.global_position = pos
		get_parent().call_deferred("add_child",coin)
		
func remove_coins(amount: int) -> void:
	coins -= amount
	if coins <= 0:
		coins = 0
		

	
