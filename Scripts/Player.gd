extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_just_pressed("ui_right"):
		velocity.x += 16
	if Input.is_action_just_pressed("ui_left"):
		velocity.x -= 16
	if Input.is_action_just_pressed("ui_down"):
		velocity.y += 16
	if Input.is_action_just_pressed("ui_up"):
		velocity.y -= 16
	move_and_collide(velocity)
