extends Node
class_name StateAnimationHandler

onready var animated_sprite : AnimatedSprite = get_node_or_null(animated_sprite_path)
onready var states_machine = get_parent()

export var animated_sprite_path : NodePath
export var recursive_animation_triggering : bool = true

var object_direction := Vector2.ZERO

#### ACCESSORS ####

func is_class(value: String): return value == "StateAnimationHandler" or .is_class(value)
func get_class() -> String: return "StateAnimationHandler"


#### BUILT-IN ####

func _ready() -> void:
	yield(owner, "ready")
	
	var __ = get_parent().connect("state_changed", self, "_on_StateMachine_state_changed")
	
	if animated_sprite:
		__ = animated_sprite.connect("animation_finished", self, "_on_animation_finished")

func _process(_delta: float) -> void:
	if owner.dir_x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif owner.dir_x < 0 and !animated_sprite.flip_h:
		animated_sprite.flip_h = true

#### VIRTUALS ####


func _update_animation(state: Node) -> void:
	if state == null:
		return
	
	var audio_stream_player = state.get_node_or_null("AudioStreamPlayer")
	var state_name = state.name
	var previous_state = states_machine.previous_state
	
	if audio_stream_player != null:
		audio_stream_player.stop()
		audio_stream_player.play()
	
	if animated_sprite == null:
		return

	var sprite_frames = animated_sprite.get_sprite_frames()
	if sprite_frames == null:
		return
	
	var anim_name = state_name
	var start_anim_name = "Start" + anim_name
	var trans_anim_name = previous_state.name + "To" + anim_name if previous_state else ""

	if sprite_frames.has_animation(start_anim_name):
		animated_sprite.play(start_anim_name)
	
	elif previous_state && sprite_frames.has_animation(trans_anim_name):
		animated_sprite.play(trans_anim_name)

	else:
		if sprite_frames.has_animation(anim_name):
			animated_sprite.play(anim_name)
		
		elif state.toggle_state_mode:
			state.exit_toggle_state()



#### SIGNAL RESPONSES #####

func _on_animation_finished():
	if animated_sprite == null:
		return
	
	var state = get_parent().get_state()
	
	if state == null:
		return
	
	var state_name = state.name
	
	var sprite_frames = animated_sprite.get_sprite_frames()
	var current_animation = animated_sprite.get_animation()
	
	if !state_name.is_subsequence_ofi(current_animation):
		return
	
	if current_animation == "Start" + state_name or ("To" + state_name).is_subsequence_ofi(current_animation):
		if sprite_frames != null and sprite_frames.has_animation(state_name):
			animated_sprite.play(state_name)
	else:
		if state.toggle_state_mode:
			state.exit_toggle_state()


func _on_StateMachine_state_changed(new_state: Node) -> void:
	_update_animation(new_state)