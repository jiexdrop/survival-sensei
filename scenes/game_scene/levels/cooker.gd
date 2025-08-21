extends Area2D

@onready var level_2: Level
@export var pan: Pan
@export var player_2ainpc: Player2AINPC
@onready var shake_timer: Timer = $ShakeTimer

enum PanState {
	HIDDEN,         # Pan not collected yet
	COLLECTED,      # Pan collected but not placed
	PLACED,         # Pan placed on cooker but empty
	WITH_CARROTS,   # Pan has carrots but not cooking
	COOKING,        # Carrots are cooking
	SHAKE,
	SHAKEN,
}

var current_state = PanState.HIDDEN
var shake_count = 0
const required_shakes = 3  # Number of shakes needed

func _ready() -> void:
	level_2 = get_parent() as Level
	# Initialize pan state
	update_pan_state()

func update_pan_state():
	match current_state:
		PanState.HIDDEN:
			pan.visible = false
		PanState.COLLECTED:
			pan.visible = true
			pan.set_default()
		PanState.PLACED:
			pan.visible = true
			pan.set_default()
		PanState.WITH_CARROTS:
			pan.visible = true
			pan.set_close()
		PanState.COOKING:
			pan.visible = true
			pan.set_cooking()  # You'll need to implement this method
		PanState.SHAKE:
			pan.visible = true
			pan.set_shake()  # You'll need to implement this method
		PanState.SHAKEN:
			pan.visible = true
			pan.set_cooking()  # You'll need to implement this method

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		handle_click()

func handle_click():
	match current_state:
		PanState.HIDDEN:
			# Player collects the pan
			if level_2.level_state.has_pan:
				current_state = PanState.COLLECTED
				player_2ainpc.notify("The player has collected the pan.")
				update_pan_state()
		
		PanState.COLLECTED:
			# Player places the pan on the cooker
			current_state = PanState.PLACED
			player_2ainpc.notify("The player put the pan over the cooker.")
			update_pan_state()
		
		PanState.PLACED:
			# Player adds carrots to the pan
			if level_2.level_state.collected_carrots >= 3:
				current_state = PanState.WITH_CARROTS
				player_2ainpc.notify("The player puts the carrots on the pan.")
				update_pan_state()
		
		PanState.WITH_CARROTS:
			# Start cooking
			current_state = PanState.COOKING
			player_2ainpc.notify("The carrots are cooking!")
			update_pan_state()
			# Start timer for when shaking is needed
			shake_timer.start()
		
		PanState.COOKING:
			# Still cooking, not ready to shake yet
			player_2ainpc.notify("The carrots are still cooking...")
		
		PanState.SHAKE:
			# Shake the pan
			shake_count += 1
			pan.set_shake()
			player_2ainpc.notify("The player is shaking the pan. (" + str(shake_count) + "/" + str(required_shakes) + ")")
			
			if shake_count >= required_shakes:
				current_state = PanState.SHAKEN
				player_2ainpc.notify("The carrots are perfectly cooked!")
				update_pan_state()
			else:
				# Reset the timer to allow for more shaking
				shake_timer.start()
		
		PanState.SHAKEN:
			# Carrots are done cooking
			player_2ainpc.notify("The carrots are ready to serve!")

func _on_shake_timer_timeout() -> void:
	if current_state == PanState.COOKING:
		current_state = PanState.SHAKE
		player_2ainpc.notify("The pan needs to be shaken!")
		update_pan_state()
