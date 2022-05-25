extends KinematicBody2D

const Gravity = 14
const Max_Speed = 320
const Accel = 0.5
const Deccel = 0.3
const Jump_Acc = Gravity * 25

const MIN_MOVE_VEL = 1.0

var dir_x : int

var velocity : Vector2

signal jumped


func _physics_process(_delta: float) -> void:
	velocity.y += Gravity

	if dir_x != 0:
		velocity.x = lerp(velocity.x, sign(dir_x) * Max_Speed, Accel)
	else:
		velocity.x = lerp(velocity.x, 0, Deccel)

	velocity = move_and_slide(velocity, Vector2.UP)



func _input(_event: InputEvent) -> void:
	dir_x = int(Input.get_axis("ui_left", "ui_right"))

	if Input.is_action_just_pressed("ui_accept") && is_on_floor():
		jump()



func jump() -> void:
	velocity.y = -Jump_Acc
	emit_signal("jumped")
