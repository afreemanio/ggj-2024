extends Control


func _ready() -> void:
	SignalManager.level_changed.connect(modify_level_number)

func _process(delta: float) -> void:
	%ProgressBar.value = StatManager.player_laugh_percentage
	match StatManager.player_epona_meter:
		0:
			%Epona.text = "     "
		1:
			%Epona.text = "*    "
		2:
			%Epona.text = "* *  "
		3:
			%Epona.text = "* * *"

func modify_level_number(level_number : int) -> void:
	%Level.text = "LEVEL " + str(level_number)
