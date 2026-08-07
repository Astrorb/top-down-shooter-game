extends Node

#预加载爆炸动画资源
const EXPLORE_ANIM = preload("uid://wn3j770b40go")

#角色引用
var player: Player

func play_explosion_anim(pos: Vector2) -> void:
	var anim: AnimatedSprite2D = EXPLORE_ANIM.instantiate() as AnimatedSprite2D
	anim.global_position = pos
	anim.z_index = 99
	get_parent().add_child(anim)
	await anim.animation_finished
	anim.queue_free()
