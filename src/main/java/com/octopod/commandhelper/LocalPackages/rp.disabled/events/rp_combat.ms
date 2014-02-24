
@user_settings =
	array(
		'exp-left': 50,
		'gold': 500,
		'magic-owned': array(0, 1),
		'magic-assigned':
			array(
				1, #LRL
				0, #LLR
				null, #LLL
				null, #LRR
			),
	)
	
export('user', @user_settings)

bind(target_player, null, null, @event, if(import('mobNoTarget.'.@event[id]) == true, cancel()))

bind(entity_damage, null, null, @event,
	
	cancel()
	modify_event(amount, 0)

	#attempts to get a player attacker from the event

	if(array_index_exists(@event, shooter) && ponline(@event[shooter]), 
		@player = @event[shooter],
		if(array_index_exists(@event, damager) && ponline(@event[damager]), 
			@player = @event[damager],
			@player = null
		)
	)
	
	if(@event[cause] == BLOCK_EXPLOSION, _hurt(@event[id], 2))

	if(@event[cause] == ENTITY_ATTACK && @player == null, _hurt(@event[id], 1))

	if(@event[cause] == PROJECTILE, 
	
		@projectiles = import('projectiles')
		
		if(is_array(@projectiles) && array_index_exists(@projectiles, @event[damager]),
			@info = @projectiles[@event[damager]]
			_projectile_remove(@event[damager]),
			@info = array('_ENTITY', 1)
		)

		_hurt(@event[id], @info[1], @info[0])

	)
	
	#if(@event[type] == 'PLAYER', _scoreboard_update(@event[player]))
		
)

bind(projectile_hit, null, null, @event, set_timeout(50, closure(_projectile_remove(@event[id]))))
 
bind(player_interact, array(priority:monitor), null, @event,

	if(pmode() == CREATIVE, die())

	@type = split(':', @event[block])[0]

	if(@type == 130 || @type == 54,
	
		@used_chests = import('usedchests.'.player())
		
		if(!is_array(@used_chests), @used_chests = array())
		
		if(!array_contains(@used_chests, import('roomID')),

			bind(inventory_open, null, null, @e, @event, @used_chests,
			
				cancel()
				
				set_timeout(750,
					closure(
						make_effect(@event[location], 'MOBSPAWNER_FLAMES')
						msg(color(7) . 'You found: ' . color(f) . 'Spider Eye')
						msg(color(a) . ' + Can see enemy health on hit')
						set_block_at(@event[location], '0')
					)
				)
					
				@used_chests[] = import('roomID')
				
				export('usedchests.'.player(), @used_chests)
				
				unbind()
				
			),
			
			cancel()
			
			msg(color(7) . 'This chest is empty.')
			
		)

	)
	
	@pinfo = pinfo()	
	@item = split(':', @pinfo[6])[0]
		
	@wait_time = 400
	@wait_key = 'wait.'.player()

	if(@event[button] == right && @item == 261 && import(@wait_key.'') == null) {

		if(import('wait.'.player()) == true, die(), 

			@f = _forward(player())
			@vec = _vec_mult(@f, 1.2)

			set_entity_velocity(_projectile(player(), ARROW, 1), @vec)
			make_effect(ploc(), 'BOW_FIRE')

			export(@wait_key.'', true)
			set_timeout(@wait_time, closure(export(@wait_key.'', null)))

		)
					
	}
	
)

/*

bind(player_interact, null, null, @event,

	@pinfo = pinfo()	
	@item = split(':', @pinfo[6])
	@info = _get_iteminfo(pinv()[@pinfo[15]])
	
	if(@info[type] == 'STATUS MENU') {
		
		_show_status(player())
		die()
		
	}

	@wait_time = 800
	@wait_key = 'wait.'.player()

	@combo_key = 'magic.combo.'.player()

	@combo = import(@combo_key.'')

	if(@event[button] == right || is_array(@combo),

		switch(@event[button],
			left,
				@combo = _magic_push(0),
			right,
				@combo = _magic_push(1)
		)

		if(is_array(@combo)) {
			
			export(@wait_key.'', true)
			set_timeout(@wait_time, closure(export(@wait_key.'', null)))
		
			@s = array_size(@combo) - 1
			@combo = array(@combo[@s - 2], @combo[@s - 1], @combo[@s])
			@pattern = array()
			
			foreach(@combo, @i, @b,
				switch(@b,
					1,
						@n = color(6) . color(l) . 'R',
						@n = color(d) . color(l) . 'L'
				)
				@pattern[@i] = @n
			)
			
			@name = color(8) . '[' . array_implode(@pattern, color(8) . '-') . color(8) . ']' 
	
			@settings = import('user.'.player())

			@assigned = @settings['magic-assigned']
	
			switch(@combo,
				array(array(1,0,1)),
					@fired = _magic_use(@assigned[0], @name),
				array(array(1,1,0)),
					@fired = _magic_use(@assigned[1], @name),
				array(array(1,1,1)),
					@fired = _magic_use(@assigned[2], @name),
				array(array(1,0,0)),
					@fired = _magic_use(@assigned[3], @name),
			)
			
			if(@fired === UNASSIGNED, msg(color(c) . 'Unknown pattern.'))
			if(@fired === NOMANA, msg(color(c) . 'You don\'t have enough stamina to use this spell.'))
			
		}
			
		,
		
		#===[USED RANGE WEAPON]=============================================================================#

		if(@info[type] == 'RANGE WEAPON' && import(@wait_key.'') == null) {

			if(import('wait.'.player()) == true, die(), 
				
				@id = _projectile(player(), ARROW, 2)

				@vec = _forward(player())

				set_entity_velocity(@id, _vec_mult(@vec, 2))

				export(@wait_key.'', true)
				set_timeout(@wait_time, closure(export(@wait_key.'', null)))

			)
					
		}
		
	)

)

*/