extends Label

@export var action: GUIDEAction

func _ready():
	var formatter: GUIDEInputFormatter = GUIDEInputFormatter.for_active_contexts()
	text = formatter.action_as_text(action)

#func _process(_delta):
	#var formatter: GUIDEInputFormatter = GUIDEInputFormatter.for_active_contexts()
	#
	#text = formatter.action_as_text(action)
