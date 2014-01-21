foreach(all_entities(), @id, try(entity_remove(@id)))

_room_generateLayout(15, 2, 1, 1)

set_timeout(500, closure(foreach(all_players(), @player, _player_respawn(@player))))

bind(player_move, null, null, @event, 

	if(pmode() != 'CREATIVE',
	
		@roomID = _player_getRoom(player())
		@center = _room_toWorldCenter(@roomID)
		@loc = _vec_sub(ploc(), @center)
		
		if(abs(@loc[0]) >= 21 || abs(@loc[2]) >= 21,
			
			if(abs(@loc[0]) > abs(@loc[2]), @axis = x, @axis = z)
			
			if(@axis == x,
				if(@loc[0] > 0,
					@dir = east,
					@dir = west
				),
				if(@loc[2] > 0,
					@dir = south,
					@dir = north
				)
			)
			
			switch(@dir,
				north,
					@roomID[1] += 1,
				south,
					@roomID[1] -= 1,
				west,
					@roomID[0] -= 1,
				east,
					@roomID[0] += 1
			)

			_player_setRoom(player(), @roomID)
			_room_printLayout(player())

			if(!_room_isSafe(@roomID), 
				_room_lockRoom(@roomID)
				_mob_spawnInRoom(@roomID)
			)

		)

	)

	if(pinfo(player(), 19)) { 

		@space_amt = 1
		@space = import('stamina.space.'.player())
		
		if(@space_amt != @space,

			@space++,
			
			_stamina_use(player(), 1) 
			
			@space = null
			
		)
		
		export('stamina.space.'.player(), @space)

	}

)


bind(player_join, null, array(priority:monitor), @event,

	set_timeout(50, closure(_player_respawn(player())))
	
	#_scoreboard_reset(player())	
	
)
		
bind(projectile_hit, null, null, @event, entity_remove(@event[id]))

bind(inventory_click, null, null, @event,

	if(pmode() == 'CREATIVE', die())

	if(pget_virtualchest() != null && @event[action] == PICKUP_ALL) {
	
		cancel()
		 
		@item = @event[slotitem]
		_buy_item(@item)

	} else {
		if(@event[action] != PICKUP_ALL && @event[action] != SWAP_WITH_CURSOR && @event[slotitem] != null) {
			
			cancel()
			
			set_pinv(pinv())
			
		}	
	}
	
)

bind(block_break, null, null, @event, if(pmode() != CREATIVE, cancel()))
bind(block_place, null, null, @event, if(pmode() != CREATIVE, cancel() set_timeout(50, closure(set_pinv(pinv())))))

bind(creature_spawn, null, null, @event, if(@event[reason] != CUSTOM && @event[reason] != SPAWNER_EGG, cancel()))

bind(item_drop, null, null, @event, cancel())
bind(item_spawn, null, null, @event, cancel())
bind(item_pickup, null, null, @event, modify_event(item, null))