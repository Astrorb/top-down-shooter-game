extends Node2D

class_name SingleBullet
#速度1000
@export var speed: float = 1000
#移动方向
var move_direction: Vector2
#伤害
var damage: float
@onready var explosion_sound: AudioStreamPlayer = $ExplosionSound

#
func _process(delta: float) -> void:
  	# 如果没有飞行方向 → 直接退出，跳过移动代码
	if move_direction == Vector2.ZERO:
		return
	#有方向，正常移动
	position += move_direction * speed * delta
	
#碰到物体，销毁自身
func _on_area_2d_body_entered(body: Node2D) -> void:
	GameManager.play_explosion_anim(global_position)
	explosion_sound.play()
	#延迟 0.08 秒,听到爆炸声，再删除当前节点
	await get_tree().create_timer(0.08).timeout
	queue_free()
	
#移动到屏幕外销毁
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
