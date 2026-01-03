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

@export_group("Switch mode actions")
@export var switch_to_build_mode_action:GUIDEAction
@export var switch_to_walk_mode_action:GUIDEAction

@export_group("Switch input source actions")
@export var switch_to_controller_action:GUIDEAction
@export var switch_to_keyboard_and_mouse_action:GUIDEAction

enum GameMode {
	BUILD_MODE,
	WALK_MODE
}
var _game_mode: GameMode = GameMode.WALK_MODE

enum InputMode {
	KEYBOARD_AND_MOUSE,
	CONTROLLER
}
var _input_mode: InputMode = InputMode.KEYBOARD_AND_MOUSE

func _ready():
	switch_to_build_mode_action.triggered.connect(_set_game_mode.bind(GameMode.BUILD_MODE))
	switch_to_walk_mode_action.triggered.connect(_set_game_mode.bind(GameMode.WALK_MODE))
	switch_to_controller_action.triggered.connect(_set_input_mode.bind(InputMode.CONTROLLER))
	switch_to_keyboard_and_mouse_action.triggered.connect(_set_input_mode.bind(InputMode.KEYBOARD_AND_MOUSE))
	
	_update_input()

func _set_game_mode(game_mode: GameMode):
	_game_mode = game_mode
	_update_input()
	
func _set_input_mode(input_mode: InputMode):
	_input_mode = input_mode
	_update_input()

func _update_input():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	match _input_mode:
		InputMode.KEYBOARD_AND_MOUSE:
			_update_to_keyboard_and_mouse()
		InputMode.CONTROLLER:
			_update_to_controller()

func _update_to_keyboard_and_mouse():
	GUIDE.enable_mapping_context(global_keyboard_and_mouse, true)
	match _game_mode:
		GameMode.BUILD_MODE:
			GUIDE.enable_mapping_context(build_mode_keyboard_and_mouse)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		GameMode.WALK_MODE:
			GUIDE.enable_mapping_context(walk_mode_keyboard_and_mouse)

func _update_to_controller():
	GUIDE.enable_mapping_context(global_controller, true)
	match _game_mode:
		GameMode.BUILD_MODE:
			GUIDE.enable_mapping_context(build_mode_controller)
		GameMode.WALK_MODE:
			GUIDE.enable_mapping_context(walk_mode_controller)
