extends VBoxContainer

const CREDIT_CONTAINER = preload("uid://6ji18qns07g4")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for credit in DataManager.payload.credits.credits_list:
		var instance = CREDIT_CONTAINER.instantiate()
		add_child(instance)
		instance.name_label.text = credit.name
		instance.role_label.text = credit.role
		
