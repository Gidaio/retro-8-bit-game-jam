extends KinematicBody2D

export (int) var speed = 120
export (int) var dash_speed = 300
export (float) var dash_length = 0.2
var velocity = Vector2()
var sprite_direction = "right"
var attacking = false
var dashing = false
var dash_timer = 0


func occupied():
	return attacking or dashing

func handle_attacking():
	if Input.is_action_just_pressed("attack") and !occupied():
		attacking = true
		$AnimationPlayer.play("attack")
		var _error = $AnimationPlayer.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished", [], CONNECT_ONESHOT)

func handle_dashing():
	if Input.is_action_just_pressed("dash") and !occupied():
		dashing = true
		$AnimationPlayer.stop()
		$Sprite.frame = 4
		dash_timer = dash_length

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

func handle_sprite():
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

func _physics_process(delta):
	if dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			dashing = false

	handle_attacking()
	handle_dashing()
	if dashing:
		velocity = move_and_slide(velocity.normalized() * dash_speed)
	elif !occupied():
		get_input()
		velocity = move_and_slide(velocity * speed)
		handle_sprite()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		attacking = false
