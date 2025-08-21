class_name SpeechBubble
extends TextEdit

@onready var timer = $Timer

# Words per minute for reading speed (adjust as needed)
const WORDS_PER_MINUTE = 100
# Minimum display time in seconds
const MINIMUM_DISPLAY_TIME = 2.0
# Characters revealed per second
const CHARACTERS_PER_SECOND = 20

var full_message = ""
var current_char_index = 0
var reveal_timer = null
var sensei_avatar: TextureRect  # Reference to the TextureRect

func set_message(message: String):
	full_message = message

func set_sensei_avatar(rect: TextureRect):
	sensei_avatar = rect
	sensei_avatar.hide()

func play():
	self.show()
	if sensei_avatar:
		sensei_avatar.show()  # Show the TextureRect when speech starts
	self.text = ""

	current_char_index = 0
	
	# Create reveal timer if it doesn't exist
	if reveal_timer == null:
		reveal_timer = Timer.new()
		add_child(reveal_timer)
		reveal_timer.timeout.connect(_on_reveal_timer_timeout)
	
	# Start revealing text
	reveal_timer.wait_time = 1.0 / CHARACTERS_PER_SECOND
	reveal_timer.start()
	
	# Calculate and set auto-hide timer
	var word_count = full_message.split(" ", false).size()
	var reading_time_seconds = (word_count / float(WORDS_PER_MINUTE)) * 60.0
	var display_time = max(reading_time_seconds, MINIMUM_DISPLAY_TIME)
	
	timer.wait_time = display_time
	timer.start()

func _on_reveal_timer_timeout():
	if current_char_index < full_message.length():
		# Add next character
		self.text += full_message[current_char_index]
		current_char_index += 1
	else:
		# Stop reveal timer when done
		reveal_timer.stop()

func _ready():
	self.hide()
	self.scroll_fit_content_height = true  # Adjust height to content

func _on_timer_timeout():
	if sensei_avatar:
		sensei_avatar.hide()  # Hide the TextureRect when speech ends
	self.hide()

# Optional: Skip reveal animation if player wants to fast-forward
func skip_reveal():
	if reveal_timer != null and reveal_timer.is_stopped() == false:
		reveal_timer.stop()
		self.text = full_message
		current_char_index = full_message.length()

# Optional: Clear the bubble
func clear_bubble():
	self.text = ""
	full_message = ""
	current_char_index = 0
	if reveal_timer != null:
		reveal_timer.stop()
	self.hide()
	if sensei_avatar:
		sensei_avatar.hide()
