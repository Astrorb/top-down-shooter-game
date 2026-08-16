extends CharacterBody2D
class_name Enemy

@export var move_spd := 400.0
@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var health_component: HealthComponent = $HealthComponent

var can_move: bool = true

#_physics_process(delta)：固定时间步运行（默认每秒 60 次，delta 恒定 = 1/60），和物理引擎同步
#这个敌人是 CharacterBody2D（move_and_slide() 专属节点），凡是调用 move_and_slide() 的移动逻辑，规范、稳定做法必须写在 _physics_process。
func _physics_process(delta: float) -> void:
	var player_dir = GameManager.player.global_position - global_position
	var direction := player_dir.normalized()
	var movement = direction * move_spd
	velocity = movement
	if player_dir.length() <= 120:
		return
	if not can_move: return
	
	move_and_slide()
	anim_sprite.flip_h = true if velocity.x < 0 else false


func _on_health_component_on_damaged() -> void:
	anim_sprite.material = GameManager.HIT_MATERIAL
	await get_tree().create_timer(0.3).timeout
	anim_sprite.material = null
	

func _on_health_component_on_defeated() -> void:
	can_move = false
	anim_sprite.play("death")
	collision_shape_2d.set_deferred("disabled",true)
	GameManager.create_coin(global_position)
	
	await anim_sprite.animation_finished
	GameManager.on_enemy_died.emit()
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = body as Player
	player.health_component.take_damage(2)
