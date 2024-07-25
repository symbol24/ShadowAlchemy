extends Node

signal IsPlaying(is_playing)
signal WorldReady(world)

signal CharacterReady(character)
signal CharacterDead(data)
signal CharacterNoMoreLive(characterData)
signal PlayerDead()
signal HPUpdated(characterdata, change)
signal MaxHPUpdated(characterdata, new_max)

signal CharacterGrounded(character)
signal UpdateAnimation(character, animation)
signal UpdateCharaterState(character, state)
signal CharacterJumping(jumping)

signal PotionTimerUpdate(potion, timer)
signal PotionSelectionChanged(selection)
signal AddPotion(data)

signal EnemyAttack(enemy)
signal EnemyAttackOver(enemy)
signal MageShoot(enemy)
