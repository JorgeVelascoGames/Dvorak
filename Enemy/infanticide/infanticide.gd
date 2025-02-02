extends Enemy
class_name InfanticideEnemy

@onready var visible_on_screen_notifier_3d: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D

var original_speed : float
var super_speed := 14.00
var dying_quotes = [
	"A sin remains unconfessed: this is not the end of their torment… nor of your guilt",
	"Another life ends at your hands, but your conscience bleeds anew, unhealed by silent prayers",
	"The hush of their final breath echoes your own torment—no redemption lies in this violence",
	"They collapse before you, yet the weight of your sin only grows, demanding a confession you dare not utter",
	"They collapse at your feet, but absolution slips away: you sense you’ve not reached the end of your cruelty",
	"With their final breath, you discover a deeper cruelty still within you…"
]

func _ready() -> void:
	super()
	original_speed = speed


func _process(delta: float) -> void:
	super(delta)
	if current_target:
		var distance = global_position.distance_to(current_target.global_position)

		if distance > 20:
			speed = super_speed
		else:
			speed = original_speed


func shot_infanticide_enemy() -> void:
	player.player_ui.display_gameplay_text(dying_quotes.pick_random(), 5)
	#TODO vhs effect here
