extends RichTextLabel

@export_multiline var prompt: String = ""
@export var actions: Array[GUIDEAction] = []
@export var show_in_contexts: Array[GUIDEMappingContext] = []

var _formatter: GUIDEInputFormatter = GUIDEInputFormatter.for_active_contexts(64)

func _ready():
	GUIDE.input_mappings_changed.connect(_update_label)
	_update_label()

func _update_label():
	if not show_in_contexts.any(func(context): return GUIDE.is_mapping_context_enabled(context)):
		visible = false
		return
		
	visible = true
	
	var icons: Array[String] = []
	
	for action in actions:
		icons.append(await _formatter.action_as_richtext_async(action))
		
	text = prompt % icons
