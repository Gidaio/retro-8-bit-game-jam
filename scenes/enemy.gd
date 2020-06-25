extends KinematicBody2D


export (int) var speed = 75
var player: KinematicBody2D


func _ready():
	player = $"../Player"
	$AnimationPlayer.play("Move")
	if !player:
		print_debug("No player!")
		queue_free()


func _physics_process(_delta):
	var direction = (player.global_position - global_position).normalized()
	var _velocity = move_and_slide(direction * speed)
