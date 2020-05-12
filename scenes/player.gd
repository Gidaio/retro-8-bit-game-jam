extends KinematicBody2D

export (int) var speed = 150
var velocity = Vector2()
var sprite_direction = "right"

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	velocity = velocity.normalized() * speed

	return velocity

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)

func _process(_delta):
	var animation_player = $AnimationPlayer
	var sprite = $Sprite
	if velocity.length() > 0:
		if velocity.x > 0:
			sprite.flip_h = false
		elif velocity.x < 0:
			sprite.flip_h = true
		animation_player.play("run")

	elif velocity.length() == 0:
		animation_player.stop()
		sprite.frame = 0
