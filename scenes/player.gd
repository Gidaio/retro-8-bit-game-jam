extends KinematicBody2D

export (int) var speed = 120
export (int) var dash_speed = 300
export (float) var dash_length = 0.2
var velocity = Vector2()
var sprite_direction = "right"
var state = "running"
var dash_timer = 0



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
	velocity = velocity.normalized()

	return velocity

func handle_running_sprite():
	var animation_player = $AnimationPlayer
	var sprite = $Sprite
	if velocity.length() > 0:
		if velocity.x > 0:
			sprite.flip_h = false
		elif velocity.x < 0:
			sprite.flip_h = true

		if !animation_player.is_playing():
			animation_player.play("run")

	elif velocity.length() == 0:
		animation_player.stop()
		sprite.frame = 0

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		state = "running"
		$"Area2D/Hitbox".disabled = true

func _physics_process(delta):
	match state:
		"running":
			if Input.is_action_just_pressed("attack"):
				state = "attacking"
				$AnimationPlayer.play("attack")
				var _error = $AnimationPlayer.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished", [], CONNECT_ONESHOT)
				continue
			if Input.is_action_just_pressed("dash") and velocity.length_squared() > 0:
				state = "dashing"
				$AnimationPlayer.stop()
				$Sprite.frame = 4
				dash_timer = dash_length
				continue
			get_input()
			velocity = move_and_slide(velocity * speed)
			handle_running_sprite()
		"attacking":
			$"Area2D/Hitbox".disabled = false
		"dashing":
			dash_timer -= delta
			if dash_timer <= 0:
				state = "running"
			velocity = move_and_slide(velocity.normalized() * dash_speed)

func _on_Area2D_body_entered(body: PhysicsBody2D):
	body.get_hit()
