extends Node

signal IsPlaying(is_playing)
signal WorldReady(world)

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
signal AddStone()

signal EnemyAttack(enemy)
signal EnemyAttackOver(enemy)
signal MageShoot(enemy)

signal DisplaySmallPopup(text)
signal PauseGame(pause)
signal FocusedOnUi(is_focused)
