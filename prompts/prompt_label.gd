extends RichTextLabel

@export_multiline var prompt: String = ""
@export var actions: Array[GUIDEAction] = []

var _formatter: GUIDEInputFormatter = GUIDEInputFormatter.for_active_contexts(64)

func _ready():
	GUIDE.input_mappings_changed.connect(_update_label)
	_update_label()

func _update_label():
	var icons: Array[String] = []
	
	for action in actions:
		icons.append(await _formatter.action_as_richtext_async(action))
		
	text = prompt % icons
