extends Node

signal IsPlaying(is_playing)
signal WorldReady(world)

signal CharacterReady(character)
signal PlayerDead(character)
signal HPUpdated(character, change)
signal MaxHPUpdated(character, new_max)
signal PotionSelectionChanged(selection)

signal CharacterGrounded(character)
