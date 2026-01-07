@tool
extends MarginContainer

@export var toggle_settings_dialog_action: GUIDEAction

@onready var _tab_container:TabContainer = %TabContainer

func _ready():
	toggle_settings_dialog_action.triggered.connect(_toggle_vibility)
	_tab_container.set_tab_title(0, "Keyboard & Mouse" )
	
func _toggle_vibility():
	visible = not visible
