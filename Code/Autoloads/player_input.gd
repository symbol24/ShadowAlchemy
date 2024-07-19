extends Node

var move_left_right = 0
var move_up_down = 0
var aim_left_right = 0
var aim_up_down = 0
var action_1 = 0
var action_2 = 0
var action_2_released = 0
var action_3 = 0
var action_4 = 0
var start = 0
var select = 0
var action_5 = 0
var action_6 = 0
var action_7 = 0
var action_7_released = 0
var action_8 = 0

var ui_left_stick_left_right = 0
var ui_left_stick_up_down = 0
var ui_right_stick_left_right = 0
var ui_right_stick_up_down = 0
var ui_confirm = 0
var ui_cancel = 0
var ui_x = 0
var ui_y = 0
var ui_start = 0
var ui_select = 0
var ui_tab_left = 0
var ui_tab_right = 0

var focused_on_ui := false
var allow_player_input := true :
	get: return allow_player_input
	set(value):
		reset_values()
		allow_player_input = value

var any_input := false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	#Signals.FocusedOnUi.connect(toggle_focus)
	#Signals.TogglePlayerInput.connect(toggle_player_input)

func _process(_delta):
	if GameMode.is_playing() and allow_player_input:
		if !focused_on_ui: listen_to_gameplay_inputs()
		
	if focused_on_ui: listen_to_ui_inputs()
	
	any_input = Input.is_anything_pressed()

func toggle_player_input():
	allow_player_input = !allow_player_input

func toggle_focus(value):
	focused_on_ui = value

func listen_to_gameplay_inputs():
	move_left_right = Input.get_axis("left", "right")
	move_up_down = Input.get_axis("up", "down")
	aim_left_right = Input.get_axis("aim_left", "aim_right")
	aim_up_down = Input.get_axis("aim_up", "aim_down")
	action_1 = Input.is_action_just_pressed("action_1")
	action_2 = Input.is_action_just_pressed("action_2")
	action_2_released = Input.is_action_just_released("action_2")
	action_3 = Input.is_action_just_pressed("action_3")
	action_4 = Input.is_action_just_pressed("action_4")
	start = Input.is_action_just_pressed("start")
	select = Input.is_action_just_pressed("select")
	action_5 = Input.is_action_just_pressed("action_5")
	action_6 = Input.get_action_strength("action_6")
	action_7 = Input.is_action_just_pressed("action_7")
	action_7_released = Input.is_action_just_released("action_7")
	action_8 = Input.get_action_strength("action_8")

func listen_to_ui_inputs():
	ui_left_stick_left_right = Input.get_axis("ui_left", "ui_right")
	ui_left_stick_up_down = Input.get_axis("ui_up", "ui_down")
	ui_confirm = Input.is_action_just_pressed("ui_accept")
	ui_cancel = Input.is_action_just_pressed("ui_cancel")
	ui_start = Input.is_action_just_pressed("ui_start")
	ui_select = Input.is_action_just_pressed("ui_select")
	ui_tab_left = Input.get_action_strength("ui_tab_left")
	ui_tab_right = Input.get_action_strength("ui_tab_right")
	ui_y = Input.get_action_strength("ui_y")
	ui_x = Input.get_action_strength("ui_x")

func reset_values():
	move_left_right = 0
	move_up_down = 0
	aim_left_right = 0
	aim_up_down = 0
	action_1 = 0
	action_2 = 0
	action_2_released = 0
	action_3 = 0
	action_4 = 0
	start = 0
	select = 0
	action_5 = 0
	action_6 = 0
	action_7 = 0
	action_7_released = 0
	action_8 = 0

	ui_left_stick_left_right = 0
	ui_left_stick_up_down = 0
	ui_right_stick_left_right = 0
	ui_right_stick_up_down = 0
	ui_confirm = 0
	ui_cancel = 0
	ui_x = 0
	ui_y = 0
	ui_start = 0
	ui_select = 0
