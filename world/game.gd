extends Node3D

@export var walk_mode: GUIDEMappingContext

@onready var _third_person_camera:ThirdPersonCamera = %ThirdPersonCamera
@onready var _overhead_camera:OverheadCamera = %OverheadCamera
@onready var _build_mode_ui:BuildModeUI = %BuildMode
@onready var _navigation_region_3d:NavigationRegion3D = %NavigationRegion3D

func _ready() -> void:
	GUIDE.enable_mapping_context(walk_mode)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_build_mode_building_built():
	_navigation_region_3d.bake_navigation_mesh(true)
