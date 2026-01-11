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
@export var InputSectionScene:PackedScene
@export var InputBindingScene:PackedScene

@onready var _tab_container:TabContainer = %TabContainer
@onready var _keyboard_mouse_walk_tab: VBoxContainer = %KMWalkModeContainer
@onready var _keyboard_mouse_build_tab: VBoxContainer = %KMBuildModeContainer
@onready var _controller_tab: VBoxContainer = %Controller
@onready var _input_prompt: MarginContainer = %InputPrompt
@onready var _input_detector: GUIDEInputDetector = %InputDetector

var _remapper := GUIDERemapper.new()
var _input_formatter := GUIDEInputFormatter.new(64)
var _input_mapping_built := false

func _ready():
	toggle_settings_dialog_action.triggered.connect(_toggle_vibility)
	_tab_container.set_tab_title(0, "Keyboard & Mouse" )
	
	if get_parent() == get_tree().root:
		_build_input_mappings()
	
func _toggle_vibility():
	visible = not visible
	
	if visible:
		_build_input_mappings()

func _build_input_mappings():
	if _input_mapping_built:
		return
		
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
	
	_build_section(_keyboard_mouse_walk_tab, global_keyboard_and_mouse_context)
	_build_section(_keyboard_mouse_walk_tab, walk_mode_keyboard_and_mouse_context)
	_build_section(_keyboard_mouse_build_tab, build_mode_keyboard_and_mouse_context)
	#
	_build_section(_controller_tab, global_controller_context)
	_build_section(_controller_tab, walk_mode_controller_context)
	_build_section(_controller_tab, build_mode_controller_context)
	
	_input_mapping_built = true

func _build_section(tab_container:Container, mapping_context:GUIDEMappingContext):
	var remappable_items := _remapper.get_remappable_items(mapping_context)
	
	if !remappable_items.size():
		return
	
	var section = InputSectionScene.instantiate()
	tab_container.add_child(section)
	section.title = mapping_context.display_name
	
	for item in remappable_items:
		_build_input_line(tab_container, item)

func _build_input_line(tab_container:Container, item:GUIDERemapper.ConfigItem):
	var input_binding:InputBinding = InputBindingScene.instantiate()
	input_binding.title = item.display_name

	var input := _remapper.get_bound_input_or_null(item)
	_set_bound_input_icon(input, input_binding)
	input_binding.binding_change_requested.connect(_on_binding_change_requested.bind(item))
	item.changed.connect(_set_bound_input_icon.bind(input_binding))
	
	tab_container.add_child(input_binding)

func _set_bound_input_icon(input:GUIDEInput, input_binding:InputBinding):
	var icon := await _input_formatter.input_as_richtext_async(input)
	input_binding.bound_input = icon

func _on_binding_change_requested(item: GUIDERemapper.ConfigItem):
	var input_devices:Array[GUIDEInputDetector.DeviceType] = [];
	if item.context == build_mode_controller_context or \
		item.context == walk_mode_controller_context:
		input_devices = [GUIDEInputDetector.DeviceType.JOY]
	elif item.context == build_mode_keyboard_and_mouse_context or \
		item.context == walk_mode_keyboard_and_mouse_context:
		input_devices = [GUIDEInputDetector.DeviceType.MOUSE, GUIDEInputDetector.DeviceType.KEYBOARD]
	else:
		print("Unexpected context for remapping: ", item.context.display_name);
		return;

	_input_prompt.visible = true
	 
	_input_detector.detect(item.value_type, input_devices)
	
	var detected_input:GUIDEInput = await _input_detector.input_detected
	_input_prompt.visible = false
	#print("\nDetected input: ", detected_input, " for ", item.context.display_name)
	
	if not detected_input:
		return
	
	var collisions := _remapper.get_input_collisions(item, detected_input)
	
	if collisions.any(
		func (collision: GUIDERemapper.ConfigItem):
			if collision.context == global_controller_context or \
				collision.context == global_keyboard_and_mouse_context:
				return true;

			return collision.context == item.context and not collision.is_remappable
	):
		print("Forbidden to remap non-remappable input")
		return

	#for collision in collisions:
	# 	print("Collision: ", collision.display_name, " from ", collision.context.display_name, " ", collision.is_remappable)

	for collision in collisions:
		if collision.context == item.context:
			_remapper.set_bound_input(collision, null)
	
	_remapper.set_bound_input(item, detected_input)
