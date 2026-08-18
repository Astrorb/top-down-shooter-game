extends CharacterBody2D

class_name Player


@export var move_spd := 700
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon: Weapon = $Weapon
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: HealthBar = $HealthBar

var can_move := true
var mouse_pos: Vector2

#渲染帧回调跟随显示器刷新率运行（60/144/240 帧不固定），每一帧间隔时间长短不一
#用途：画面渲染、UI、动画、输入检测、粒子特效这类视觉内容
func _process(delta: float) -> void:
	if not can_move:
		return
	get_mouse_pos()
	UpdataAnimation()
	Update_rotation()
	update_weapon_rotation()
#物理帧回调 固定每秒运行 60 次（默认物理步长 1/60 s），时间间隔永远恒定不变
#专门给：物理移动、碰撞检测、受力、速度运算、角色位移逻辑设计
func _physics_process(delta: float) -> void:
	if not can_move: return
	#返回值固定是 Vector2，存储 X、Y 输入轴向数值（范围 -1 ~ 1）。例：按住右下 → (1, 1)
	var input := Input.get_vector("move_left","move_right","move_up","move_down")
	#.normalized() 是 Vector2 的内置方法：输入向量归一化之后，返回新的 Vector2，向量长度强制 = 1，方向不变。
	var direction := input.normalized()
	#direction：Vector2 move_spd：浮点数字（float 标量）向量 × 数字 = 缩放后的 Vector2，代表本帧要移动的速度矢量。
	var movement := direction * move_spd
	#velocity 是 CharacterBody2D 内置自带属性，本身就是 Vector2 类型，接收移动速度向量。
	velocity = movement
	move_and_slide()
	
#pickup类 _input函数中调用该方法
func setup_weapon(weapon_data: WeaponData) -> void:
	#同时这个方法调用了weapon类中的init_weapon方法
	weapon.init_weapon(weapon_data)
	weapon.show()
#获取鼠标位置
func get_mouse_pos() -> void:
	mouse_pos = get_global_mouse_position()
#更新角色翻转	
func Update_rotation() -> void:
	if mouse_pos.x > global_position.x:
		anim_sprite.flip_h = false
	else:
		anim_sprite.flip_h = true
#更新武器翻转
func update_weapon_rotation() -> void:
	if mouse_pos.x > global_position.x:
		weapon.rotate_weapon(false)
	else:
		weapon.rotate_weapon(true)	
	weapon.look_at(mouse_pos)
#更新动画表现					
func UpdataAnimation() -> void:
	if velocity.length() > 0:
		anim_sprite.play("walk")
	else:
		anim_sprite.play("idle")
		
		


func _on_health_component_on_damaged() -> void:
	var health_value := health_component.current_health / health_component.max_health
	health_bar.set_value(health_value)
	anim_sprite.material = GameManager.HIT_MATERIAL
	await  get_tree().create_timer(.3).timeout
	anim_sprite.material = null
	
	

func _on_health_component_on_defeated() -> void:
	anim_sprite.play("dead")
	can_move = false
	health_bar.hide()
	GameManager.on_player_died.emit()
	await get_tree().create_timer(3).timeout
	get_tree().reload_current_scene()
	
