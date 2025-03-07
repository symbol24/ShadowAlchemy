extends Node

signal GameSucces()

signal LoadWorld(world_id)
signal IsPlaying(is_playing)
signal WorldReady(world)
signal CameraReady(camera)
signal SetCameraPos(position)
signal TeleportCharacter(position)
signal UpdateActiveRoom(room)

signal CharacterReady(character)
signal CharacterInGamemode(character)
signal CharacterDead(data)
signal CharacterNoMoreLive(characterData)
signal PlayerDead()
signal HPUpdated(characterdata, change)
signal MaxHPUpdated(characterdata, new_max)
signal HealCharacter(character, value)
signal CharacterGrounded(character)
signal UpdateAnimation(character, animation)
signal UpdateCharaterState(character, state)
signal CharacterJumping(jumping)

signal PotionTimerUpdate(potion, timer)
signal PotionSelectionChanged(selection)
signal AddPotion(data)
signal SendHowManyStarterPotions(count)
signal AddStone()

signal EnemyAttack(enemy)
signal EnemyAttackOver(enemy)
signal MageShoot(enemy)

signal UIDone(value)
signal TogglePlayerUi(value)
signal DisplaySmallPopup(text)
signal PauseGame(pause)
signal FocusedOnUi(is_focused)
signal ToggleLoading(value)

signal UpdateAudioVolume(bus, percent)
signal AudioSettingsUpdated()
signal AudioExiting(audio_stream)
