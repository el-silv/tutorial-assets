extends Control

@export var deaths := 0 : set = set_deaths

func set_deaths(value: int) -> void:
	deaths = value
	$DeathCounter.text = "Deaths: %s" % deaths
