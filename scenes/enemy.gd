extends KinematicBody2D


export (int) var speed = 75
export (int) var knockback_speed = 300
var player: KinematicBody2D
var hit_timer: float
var health = 100


func _ready():
	player = $"../Player"
	$AnimationPlayer.play("Move")
	if !player:
		print_debug("No player!")
		queue_free()


func _physics_process(delta):
	var direction = (player.global_position - global_position).normalized()
	if hit_timer > 0:
		var _velocity = move_and_slide(-direction * knockback_speed)
		hit_timer -= delta
	else:
		var _velocity = move_and_slide(direction * speed)
	if direction.x < 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

func get_hit(damage: int):
	if hit_timer <= 0:
		hit_timer = 0.1
		health -= damage
	if health <= 0:
		queue_free()
