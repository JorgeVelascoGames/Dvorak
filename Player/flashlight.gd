extends SpotLight3D

@export var extra_time_on_pickup := 40.0

@onready var tweakling_timer: Timer = $TweaklingTimer
@onready var flashlight_battery: Timer = $FlashlightBattery
@onready var starting_battery_time := flashlight_battery.wait_time

var battery_below_25_percent := false
var empty_battery := false


func _ready() -> void:
	visible = false


func _process(delta: float) -> void:
	if flashlight_battery.time_left < starting_battery_time / 4.0:
		battery_below_25_percent = true
	else:
		battery_below_25_percent = false


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
	var remaining_time := flashlight_battery.time_left
	flashlight_battery.stop()
	#play sound
	flashlight_battery.start(remaining_time + extra_time_on_pickup)


func _on_flashlight_battery_timeout() -> void:
	empty_battery = true
	visible = false
