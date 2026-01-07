@tool
extends MarginContainer

@export_category("Inputs")
@export var toggle_settings_dialog_action: GUIDEAction
@export var walk_mode_keyboard_and_mouse_context:GUIDEMappingContext
@export var build_mode_keyboard_and_mouse_context:GUIDEMappingContext

@export_category("UI Components")
@export var section_scene:PackedScene
@export var binding_scene:PackedScene

@onready var _tab_container:TabContainer = %TabContainer
@onready var keyboard_mouse_tab: VBoxContainer = %KeyboardMouse
@onready var controller_tab: VBoxContainer = %Controller

func _ready():
	toggle_settings_dialog_action.triggered.connect(_toggle_vibility)
	_tab_container.set_tab_title(0, "Keyboard & Mouse" )
	
	# _display_input_mappings() # for debugging
	
func _toggle_vibility():
	visible = not visible
	
	if visible:
		_display_input_mappings()

func _display_input_mappings():
	var current_tab := keyboard_mouse_tab
	var contexts: Array[GUIDEMappingContext] = [
		walk_mode_keyboard_and_mouse_context,
		build_mode_keyboard_and_mouse_context
	]
	
	for context in contexts:
		var section = section_scene.instantiate()
		current_tab.add_child(section)
		section.title = context.display_name
	
		var _formatter: GUIDEInputFormatter = GUIDEInputFormatter.for_context(context, 64)
		for mapping in context.mappings:
			var icon := await _formatter.action_as_richtext_async(mapping.action)
			
			var binding = binding_scene.instantiate()
			current_tab.add_child(binding)
			binding.title = mapping.action.display_name
			binding.bound_input = icon
