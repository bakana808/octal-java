
_item_reg('Bomb', '385',

	closure(
		scriptas(@arguments[0], '*',
			spawn_entity(PRIMED_TNT, 1, _vec_add(ploc(), array(0,2,0)))
		)
	)
	
)

_item_reg('Heal', '260',

	closure(
		scriptas(@arguments[0], '*',
			firework_effect(array(colors: LIME, trail: false), _vec_add(ploc(), array(0,2,0)))
			_give_health(player(), 6)
		)
	)
	
)

_item_reg('Fireball', '339',

	closure(
		scriptas(@arguments[0], '*',
			@id = _projectile(player(), SMALL_FIREBALL, 6)
			set_interval(50,
				closure(
					if(!entity_exists(@id), clear_task() die())
					make_effect(entity_loc(@id), 'MOBSPAWNER_FLAMES')
				)
			)
		)
	)
	
)
