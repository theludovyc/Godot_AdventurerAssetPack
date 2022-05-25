extends KinematicBody2D

const Gravity = 14
const Max_Speed = 320
const Accel = 0.5
const Deccel = 0.3
const Jump_Acc = Gravity * 30

var dir_x : int

var velocity : Vector2

var want_jump : bool

var default_state = "Idle"

onready var state_machine = $StateMachine
onready var animated_sprite = $AnimatedSprite

func _process(_delta: float) -> void:
	dir_x = int(Input.get_axis("ui_left", "ui_right"))

	if Input.is_action_just_pressed("ui_accept"):
		want_jump = true
		state_machine.set_state("Jump")
	elif want_jump:
		want_jump = false

func _physics_process(_delta: float) -> void:
	if !is_on_floor():
		velocity.y += Gravity
	else:
		velocity.y = Gravity

	if dir_x != 0:
		velocity.x = lerp(velocity.x, sign(dir_x) * Max_Speed, Accel)
	else:
		velocity.x = lerp(velocity.x, 0, Deccel)

	if want_jump:
		velocity.y -= Jump_Acc

	velocity = move_and_slide(velocity, Vector2.UP)
