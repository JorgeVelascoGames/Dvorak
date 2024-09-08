extends SpotLight3D

@onready var flashlight_battery: Timer = $FlashlightBattery
@onready var starting_battery_time := flashlight_battery.wait_time
var empty_battery := false

func _ready() -> void:
	visible = false


func toggle_flashlight() -> void:
	#play sound
	if empty_battery:
		return
	
	if visible == true:
		flashlight_battery.paused = true
		visible = false
	else:
		flashlight_battery.paused = false
		visible = true
	
	if visible == true and flashlight_battery.is_stopped():
		flashlight_battery.start() #We make sure it starts working


func add_battery() -> void:
	flashlight_battery.stop()
	#play sound
	flashlight_battery.start(starting_battery_time)


func _on_flashlight_battery_timeout() -> void:
	empty_battery = true
	visible = false
