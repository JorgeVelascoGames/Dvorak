extends Enemy

@onready var visible_on_screen_notifier_3d: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D

var original_speed : float
var super_speed := 14.00

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
