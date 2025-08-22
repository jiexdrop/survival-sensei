extends Area2D

@export var player_2ainpc: Player2AINPC

@onready var fire: AnimatedSprite2D = $Fire
@onready var fire_place: AnimatedSprite2D = $FirePlace
@onready var level_1: Level
@onready var stick_search: Node2D

var _pending_action := ""

func _ready() -> void:
	level_1 = get_parent() as Level
	stick_search = get_parent().find_child("StickSearch") as StickSearch
	
	# Connect to both signals
	player_2ainpc.chat_received.connect(_on_ai_response)
	player_2ainpc.tts_ended.connect(_on_ai_response)

func _on_ai_response(_message: String = "") -> void:
	match _pending_action:
		"win":
			_pending_action = ""
			level_1.win()
		"show_stick":
			_pending_action = ""
			show_stick_search()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Collected Wood: ", level_1.level_state.collected_wood)
		if fire_place.visible and level_1.level_state.has_stick:
			fire.visible = true
			player_2ainpc.notify("The player lit up the fire.")
			_pending_action = "win"
		if level_1.level_state.collected_wood >= 3 and not fire_place.visible:
			fire_place.visible = true
			player_2ainpc.notify("The player collected enough wood and built a firepit.")
			_pending_action = "show_stick"
			
func show_stick_search():
	stick_search.visible = true
