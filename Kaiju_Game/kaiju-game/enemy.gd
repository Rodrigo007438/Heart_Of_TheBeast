extends CharacterBody2D

var vida = 3

@export var speed: float = 40.0

var player_alvo: Node2D = null

@onready var sprite = $Sprite2D

func _physics_process(_delta):
	if player_alvo != null:
		var direction = (player_alvo.global_position - global_position).normalized()
		velocity = direction * speed
		
		
		if direction.x > 0:
			sprite.flip_h = false
		
		elif direction.x < 0:
			sprite.flip_h = true
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func take_damage(amount: int):
	vida -= amount
	
	$Sprite2D.modulate = Color(1,0,0)
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.modulate = Color(1,1,1)
	
	print("VIDA RESTANTE: ", vida)
	
	if vida <= 0:
		morrer()
	
func morrer():
	print("MORREU")
	queue_free()



func _on_direction_area_body_entered(body):
	if body.name == "Player":
		player_alvo = body
		print("ENCONTRADO")

	
func _on_direction_area_body_exited(body: Node2D) -> void:
	if body == player_alvo:
		player_alvo = null
		print("FUGIU")
