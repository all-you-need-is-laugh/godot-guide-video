extends Node3D

@export_group("Inputs")
@export var build_mode: GUIDEMappingContext
@export var walk_mode: GUIDEMappingContext
@export var switch_to_build_mode_action:GUIDEAction
@export var switch_to_walk_mode_action:GUIDEAction

@onready var _third_person_camera:ThirdPersonCamera = %ThirdPersonCamera
@onready var _overhead_camera:OverheadCamera = %OverheadCamera
@onready var _build_mode_ui:BuildModeUI = %BuildMode
@onready var _navigation_region_3d:NavigationRegion3D = %NavigationRegion3D

func _ready() -> void:
	switch_to_build_mode_action.triggered.connect(_switch_to_build_mode)
	switch_to_walk_mode_action.triggered.connect(_switch_to_walk_mode)
	_switch_to_walk_mode()

func _on_build_mode_building_built():
	_navigation_region_3d.bake_navigation_mesh(true)

func _switch_to_build_mode() -> void:
	GUIDE.disable_mapping_context(walk_mode)
	GUIDE.enable_mapping_context(build_mode)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_overhead_camera.active = true
	_third_person_camera.active = false
	_build_mode_ui.active = true
	pass

func _switch_to_walk_mode() -> void:
	GUIDE.disable_mapping_context(build_mode)
	GUIDE.enable_mapping_context(walk_mode)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_overhead_camera.active = false
	_third_person_camera.active = true
	_build_mode_ui.active = false
	pass
