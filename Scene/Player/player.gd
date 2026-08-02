extends CharacterBody2D

@export var move_spd := 700
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon: Weapon = $Weapon

var can_move := true
var mouse_pos: Vector2

func _ready() -> void:
	weapon.init_weapon(load("uid://b56wrfby01fdn"))	

func _process(delta: float) -> void:
	if not can_move:
		return
	get_mouse_pos()
	UpdataAnimation()
	Update_rotation()
	update_weapon_rotation()

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

func get_mouse_pos() -> void:
	mouse_pos = get_global_mouse_position()
	
func Update_rotation() -> void:
	if mouse_pos.x > global_position.x:
		anim_sprite.flip_h = false
	else:
		anim_sprite.flip_h = true

func update_weapon_rotation() -> void:
	if mouse_pos.x > global_position.x:
		weapon.rotate_weapon(false)
	else:
		weapon.rotate_weapon(true)	
	weapon.look_at(mouse_pos)
					
func UpdataAnimation() -> void:
	if velocity.length() > 0:
		anim_sprite.play("walk")
	else:
		anim_sprite.play("idle")
		
		
