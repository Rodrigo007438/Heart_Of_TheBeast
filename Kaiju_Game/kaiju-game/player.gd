extends CharacterBody2D


@export var move_speed: float = 80.0

@export var atk_duration: float = 0.2

@onready var sprite = $Sprite2D
@onready var weapon_pivot = $weaponPivot
@onready var weapon_hitbox = $weaponPivot/SwordHitbox
@onready var sword_colision = $weaponPivot/SwordHitbox/CollisionShape2D
@onready var attack_cooldown_timer = $attack_cooldown
@export var damage: int = 1

enum State {MOVE, ATTACK}

var current_state = State.MOVE
var last_direction = Vector2.RIGHT

func _ready():
	sword_colision.disabled = true
	attack_cooldown_timer.one_shot = true
	
func _physics_process(_delta):
	
	look_at_mouse()
	
	match current_state:
		State.MOVE:
			move_state()
		State.ATTACK:
			attk_state()
			
func look_at_mouse():
	var mouse_pos = get_global_mouse_position()
	
	weapon_pivot.look_at(mouse_pos)
	
	if mouse_pos.x < global_position.x:
		sprite.flip_h = true
		weapon_pivot.scale.y = -1
	else:
		sprite.flip_h = false
		
		weapon_pivot.scale.y = 1
			
func move_state():
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * move_speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		start_attk()

func start_attk():
	current_state = State.ATTACK
	sword_colision.disabled = false
	attack_cooldown_timer.start(atk_duration)
	
	sprite.modulate = Color(0,1,1)
	
	
	
func attk_state():
	#velocity = Vector2.ZERO
	
	move_and_slide()
	
	if attack_cooldown_timer.is_stopped():
		current_state = State.MOVE
		sword_colision.disabled = true
		
		sprite.modulate = Color(1, 1, 1)
		

	


func _on_sword_hitbox_body_entered(body):
	
	if body.has_method("take_damage"):
		body.take_damage(damage)
		
	if body is CharacterBody2D:
		var direction = (body.global_position - global_position).normalized()
		body.velocity = direction *200
		body.move_and_slide()
