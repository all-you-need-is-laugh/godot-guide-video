extends Node

@export_category("Inputs")
@export_group("Controller contexts")
@export var build_mode_controller: GUIDEMappingContext
@export var walk_mode_controller: GUIDEMappingContext
@export var global_controller: GUIDEMappingContext

@export_group("Keyboard and mouse contexts")
@export var build_mode_keyboard_and_mouse: GUIDEMappingContext
@export var walk_mode_keyboard_and_mouse: GUIDEMappingContext
@export var global_keyboard_and_mouse: GUIDEMappingContext

var _current_build_mode: GUIDEMappingContext
var _current_walk_mode: GUIDEMappingContext

@export_group("Switch mode actions")
@export var switch_to_build_mode_action:GUIDEAction
@export var switch_to_walk_mode_action:GUIDEAction

@export_group("Switch input source actions")
@export var switch_to_controller_action:GUIDEAction
@export var switch_to_keyboard_and_mouse_action:GUIDEAction

@onready var _third_person_camera:ThirdPersonCamera = %ThirdPersonCamera
@onready var _overhead_camera:OverheadCamera = %OverheadCamera
@onready var _build_mode_ui:BuildModeUI = %BuildMode
@onready var _navigation_region_3d:NavigationRegion3D = %NavigationRegion3D

func _ready() -> void:
	switch_to_build_mode_action.triggered.connect(_switch_to_build_mode)
	switch_to_walk_mode_action.triggered.connect(_switch_to_walk_mode)
	_switch_to_walk_mode()

	switch_to_controller_action.triggered.connect(_switch_to_controller)
	switch_to_keyboard_and_mouse_action.triggered.connect(_switch_to_keyboard_and_mouse)
	_switch_to_keyboard_and_mouse()

func _switch_to_build_mode() -> void:
	GUIDE.disable_mapping_context(_current_walk_mode)
	GUIDE.enable_mapping_context(_current_build_mode)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _switch_to_walk_mode() -> void:
	GUIDE.disable_mapping_context(_current_build_mode)
	GUIDE.enable_mapping_context(_current_walk_mode)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _switch_mode_inputs(new_build_mode: GUIDEMappingContext, new_walk_mode: GUIDEMappingContext) -> void:
	var build_mode_should_be_reviewed = GUIDE.is_mapping_context_enabled(_current_build_mode)
	GUIDE.disable_mapping_context(_current_build_mode)
	GUIDE.disable_mapping_context(_current_walk_mode)
	_current_build_mode = new_build_mode
	_current_walk_mode = new_walk_mode
	if build_mode_should_be_reviewed:
		GUIDE.enable_mapping_context(_current_build_mode)
	else:
		GUIDE.enable_mapping_context(_current_walk_mode)

func _switch_to_controller() -> void:
	GUIDE.disable_mapping_context(global_keyboard_and_mouse)
	GUIDE.enable_mapping_context(global_controller)
	_switch_mode_inputs(build_mode_controller, walk_mode_controller)

func _switch_to_keyboard_and_mouse() -> void:
	GUIDE.disable_mapping_context(global_controller)
	GUIDE.enable_mapping_context(global_keyboard_and_mouse)
	_switch_mode_inputs(build_mode_keyboard_and_mouse, walk_mode_keyboard_and_mouse)
