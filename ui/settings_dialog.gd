@tool
extends MarginContainer

@export var toggle_settings_dialog_action: GUIDEAction

@export_category("Input Contexts")
@export var global_keyboard_and_mouse_context:GUIDEMappingContext
@export var global_controller_context:GUIDEMappingContext
@export var walk_mode_keyboard_and_mouse_context:GUIDEMappingContext
@export var walk_mode_controller_context:GUIDEMappingContext
@export var build_mode_keyboard_and_mouse_context:GUIDEMappingContext
@export var build_mode_controller_context:GUIDEMappingContext

@export_category("UI Components")
@export var section_scene:PackedScene
@export var binding_scene:PackedScene

@onready var _tab_container:TabContainer = %TabContainer
@onready var _keyboard_mouse_tab: VBoxContainer = %KeyboardMouse
@onready var _controller_tab: VBoxContainer = %Controller

var _remapper := GUIDERemapper.new()
var build_on_ready:bool

func _ready():
	toggle_settings_dialog_action.triggered.connect(_toggle_vibility)
	_tab_container.set_tab_title(0, "Keyboard & Mouse" )
	
	build_on_ready = get_parent() == get_tree().root
	
	if build_on_ready:
		_display_input_mappings()
	
func _toggle_vibility():
	visible = not visible
	
	if visible and not build_on_ready:
		_display_input_mappings()

func _display_input_mappings():
	var contexts: Array[GUIDEMappingContext] = [
		build_mode_controller_context,
		build_mode_keyboard_and_mouse_context,
		global_controller_context,
		global_keyboard_and_mouse_context,
		walk_mode_controller_context,
		walk_mode_keyboard_and_mouse_context,
	]
	
	var remapping_config := GUIDERemappingConfig.new();
	_remapper.initialize(contexts, remapping_config)
	
	_build_section(_keyboard_mouse_tab, global_keyboard_and_mouse_context)
	_build_section(_keyboard_mouse_tab, walk_mode_keyboard_and_mouse_context)
	_build_section(_keyboard_mouse_tab, build_mode_keyboard_and_mouse_context)
	
	_build_section(_controller_tab, global_controller_context)
	_build_section(_controller_tab, walk_mode_controller_context)
	_build_section(_controller_tab, build_mode_controller_context)


func _build_section(tab_container:Container, mapping_context:GUIDEMappingContext):
	var remappable_items := _remapper.get_remappable_items(mapping_context)
	
	if !remappable_items.size():
		return
	
	var section = section_scene.instantiate()
	tab_container.add_child(section)
	section.title = mapping_context.display_name

	var _formatter: GUIDEInputFormatter = GUIDEInputFormatter.for_context(mapping_context, 64)
	
	for item in remappable_items:
		print(item.display_name)

		var binding = binding_scene.instantiate()
		binding.title = item.display_name

		var input := _remapper.get_bound_input_or_null(item)
		var icon := await _formatter.input_as_richtext_async(input)
		binding.bound_input = icon

		tab_container.add_child(binding)
