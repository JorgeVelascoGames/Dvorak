extends LevelManager

@export var books_positions : Array[Marker3D] = []

@onready var flashlight_pick_up_tutorial: TutorialPopUp = $Tutorial/FlashlightPickUpTutorial
@onready var gun_pick_up_tutorial: TutorialPopUp = $Tutorial/GunPickUpTutorial
@onready var crowbar_picking_tutorial: TutorialPopUp = $Tutorial/CrowbarPickingTutorial
@onready var error_tutorial: TutorialPopUp = $Tutorial/ErrorTutorial
@onready var gun_interact: Interactable = $Player/WalkerFixedPoint/Walker/GunSelectorHitbox/GunInteract
@onready var crowbar_interact: Interactable = $Player/WalkerFixedPoint/Walker/CrowbarSelectorHitbox/CrowbarInteract
@onready var flashlight_interact: Interactable = $Player/WalkerFixedPoint/Walker/FlashlightInteract/FlashlightInteract

var pop_ups_on_screen : Array[TutorialPopUp] = []
var tutorial_on_display : TutorialPopUp


func _ready() -> void:
	AppManager.game_manager.current_level_manager = self
	var tween := get_tree().create_tween()
	tween.tween_property(black_screen, "color", Color(0,0,0,0), 4.0)
	AppManager.game_manager.on_calamity.connect(error_tutorial.try_open_tutorial)
	flashlight_interact.on_interact.connect(flashlight_pick_up_tutorial.open_tutorial)
	crowbar_interact.on_interact.connect(crowbar_picking_tutorial.open_tutorial)
	gun_interact.on_interact.connect(gun_pick_up_tutorial.open_tutorial)


func _on_exit_gate_pass_and_books_ready() -> void:
	exit_gate = $ExitGate
	exit_gate.pass_books.shuffle()
	for book in exit_gate.pass_books:
		book.global_position = books_positions[exit_gate.pass_books.find(book)].global_position
		book.rotation_degrees = Vector3(0, 90, 0)


func open_tutorial_pop_up(tutorial : TutorialPopUp) -> void:
	pop_ups_on_screen.append(tutorial)
	if tutorial_on_display == null:
		tutorial_on_display = pop_ups_on_screen.pop_front()
		tutorial_on_display.show_tutorial()
		await tutorial_on_display.finished_tutorial
		tutorial_on_display = null
