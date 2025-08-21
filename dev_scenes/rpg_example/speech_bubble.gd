class_name SpeechBubble
extends TextEdit

@onready var timer = $Timer

# Words per minute for reading speed (adjust as needed)
const WORDS_PER_MINUTE = 100
# Minimum display time in seconds
const MINIMUM_DISPLAY_TIME = 2.0

func play(message: String):
	self.show()
	self.text = message
	
	# Calculate appropriate display time based on message length
	var word_count = message.split(" ", false).size()
	var reading_time_seconds = (word_count / float(WORDS_PER_MINUTE)) * 60.0
	
	# Ensure minimum display time
	var display_time = max(reading_time_seconds, MINIMUM_DISPLAY_TIME)
	
	timer.wait_time = display_time
	timer.start()

func _ready():
	self.hide()
