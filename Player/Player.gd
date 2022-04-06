extends KinematicBody2D

const Gravity = 10
const Max_Speed = 100
const Accel = 0.25
const Deccel = 0.7

var dir_x:int

var vel:Vector2

var want_jump:bool

onready var sprite = $Sprite
onready var anim_tree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dir_x = Input.get_axis("ui_left", "ui_right")
	
	if dir_x > 0:
		sprite.flip_h = false
	elif dir_x < 0:
		sprite.flip_h = true
		
	want_jump = Input.is_action_just_pressed("ui_accept")
	
	anim_tree["parameters/conditions/is_moving"] = dir_x != 0
	anim_tree["parameters/conditions/is_not_moving"] = dir_x == 0
	anim_tree["parameters/conditions/is_jumping"] = want_jump
	anim_tree["parameters/conditions/is_falling"] = !is_on_floor()
	anim_tree["parameters/conditions/is_on_floor"] = is_on_floor()

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		vel.y += Gravity
	else:
		vel.y = Gravity
	
	if dir_x != 0:
		vel.x = lerp(vel.x, sign(dir_x) * Max_Speed, 0.5)
	else:
		vel.x = lerp(vel.x, 0, 0.1)
		
	vel = move_and_slide(vel, Vector2.UP)
