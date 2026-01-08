extends Area2D

var speed = 400.0
var direction = Vector2.RIGHT
var drag = 10.0
var damage = 3

@onready var explosao_area = $Bomb_area/CollisionShape2D
@onready var anim_sprite = $AnimatedSprite2D
@onready var timer = Timer

func _ready():
	anim_sprite.play("tick")
	
func _physics_process(delta):
	position += direction * speed * delta
	speed = move_toward(speed, 0, drag)
	
	if timer.time_left < 1.0:
		anim_sprite.speed_scale = 2.0
		
		if fmod(timer.time_left, 0.2) > 0.1:
			anim_sprite.modulate = Color(1,0,0)
		else:
			anim_sprite.modulate = Color(1,1,1)
			
func _on_timer_timeout():
	explodir()
	
func explodir():
	speed = 0
	anim_sprite.play("EXPLODIU")
	
	explosao_area.disabled = false
	
	var tween = create_tween()
	tween.tween_property(anim_sprite, "scale", Vector2(3,3), 0.1)
	tween.tween_property(anim_sprite, "modulate", Color(1,0,0,0), 0.1)
	
	await get_tree().create_timer(0.1).timeout
	
	var vitimas = $Bomb_area.get_overlapping_bodies()
	
	for corpo in vitimas:
		if corpo.has_method("take_damage") and corpo.name != "Player":
			corpo.take_damage(damage)
			
			if corpo is CharacterBody2D:
				var dir_exposion = (corpo.global_position - global_position).normalized()
				corpo.velocity = dir_exposion * 500
				corpo.move_and_slide()

	queue_free()
