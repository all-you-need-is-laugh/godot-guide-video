extends Node3D

@export_category("Inputs")
@export var switch_to_build_mode_action:GUIDEAction
@export var switch_to_walk_mode_action:GUIDEAction
@export var toggle_settings_dialog_action:GUIDEAction

@onready var _third_person_camera:ThirdPersonCamera = %ThirdPersonCamera
@onready var _overhead_camera:OverheadCamera = %OverheadCamera
@onready var _build_mode_ui:BuildModeUI = %BuildMode
@onready var _navigation_region_3d:NavigationRegion3D = %NavigationRegion3D

func _ready() -> void:
	switch_to_build_mode_action.triggered.connect(_switch_to_build_mode)
	switch_to_walk_mode_action.triggered.connect(_switch_to_walk_mode)
	toggle_settings_dialog_action.triggered.connect(_toggle_settings_dialog)

func _on_build_mode_building_built():
	_navigation_region_3d.bake_navigation_mesh(true)

func _switch_to_build_mode() -> void:
	_overhead_camera.active = true
	_third_person_camera.active = false
	_build_mode_ui.active = true

func _switch_to_walk_mode() -> void:
	_overhead_camera.active = false 
	_third_person_camera.active = true
	_build_mode_ui.active = false

func _toggle_settings_dialog():
	get_tree().paused = not get_tree().paused
