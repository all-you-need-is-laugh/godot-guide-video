extends CharacterBody3D

@export var movement_speed:float = 5
@export var bolt_scene:PackedScene

@export_group('Input Actions')
@export var move_action:GUIDEAction
@export var rotate_action: GUIDEAction

@onready var _right_hand:Node3D = %RightHand
@onready var _left_hand:Node3D = %LeftHand

func _process(_delta:float) -> void:
	velocity = basis * move_action.value_axis_3d * movement_speed
	rotation_degrees.y += rotate_action.value_axis_1d

	if not is_on_floor():
		velocity.y = -9.81

	move_and_slide()
	
func _fire_magic_bolt():	
	var spawn_points:Array[Node3D] = [_left_hand, _right_hand]
	for spawn_point:Node3D in spawn_points:
		var bolt:Node3D = bolt_scene.instantiate()
		get_parent().add_child(bolt)
		
		bolt.global_transform = spawn_point.global_transform		
		
