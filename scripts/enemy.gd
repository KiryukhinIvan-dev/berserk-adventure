extends EnemyBase

func _on_attack() -> void:
	if player and attack_timer <= 0:
		if player.has_method("take_damage"):
			player.take_damage(attack_damage)
			print("Enemy hit player!")
			attack_timer = attack_cooldown
	
