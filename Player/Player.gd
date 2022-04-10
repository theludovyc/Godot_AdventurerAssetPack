extends KinematicBody2D

const Gravity = 30
const Max_Speed = 300
const Accel = 1.0
const Deccel = 1.0
const Jump_Y = 500
const Jump_X = 260

var dir_x:int

var vel:Vector2

var want_jump:bool

onready var sprite = $Sprite
onready var anim_tree = $AnimationTree
onready var anim_playback = $AnimationTree.get("parameters/playback")


func _process(_delta: float) -> void:
	dir_x = int(Input.get_axis("ui_left", "ui_right"))
	
	if dir_x > 0:
		sprite.flip_h = false
	
	elif dir_x < 0:
		sprite.flip_h = true
	
	if Input.is_action_just_pressed("ui_accept") \
		and (anim_playback.get_current_node() == "Idle" \
		or anim_playback.get_current_node() == "Move"):
		want_jump = true
	elif want_jump:
		want_jump = false
	
	anim_tree["parameters/conditions/is_moving"] = dir_x != 0
	anim_tree["parameters/conditions/is_not_moving"] = dir_x == 0
	anim_tree["parameters/conditions/is_jumping"] = want_jump
	anim_tree["parameters/conditions/is_falling"] = !is_on_floor()
	anim_tree["parameters/conditions/is_on_floor"] = is_on_floor()


func _physics_process(_delta: float) -> void:
	if !is_on_floor():
		vel.y += Gravity
	else:
		vel.y = Gravity
	
	if dir_x != 0:
		vel.x = lerp(vel.x, sign(dir_x) * Max_Speed, Accel)
	else:
		vel.x = lerp(vel.x, 0, Deccel)
		
	if want_jump:
		vel.y -= Jump_Y
		
	vel = move_and_slide(vel, Vector2.UP)
