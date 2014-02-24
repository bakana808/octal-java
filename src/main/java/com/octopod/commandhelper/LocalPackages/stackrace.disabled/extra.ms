
/*
bind(player_interact, null, array(button: RIGHT), @event,

	@type = split(':', @event[block])[0]
	
	if(@event[block] != '43:15' && @type != 35, die())

	@loc = @event[location]

	@pl = ploc()
	@pl = array(floor(@pl[0]), floor(@pl[1]), floor(@pl[2]), @pl[3])
	
	if(pinfo()[6] != '351:8',

		if(!array_index_exists(@event, facing), die())
		
		switch(@event[facing],
			up,
				@loc = _vec_add(@loc, array(0,1,0)),
			down,
				@loc = _vec_add(@loc, array(0,-1,0)),
			north,
				@loc = _vec_add(@loc, array(0,0,-1)),
			south,
				@loc = _vec_add(@loc, array(0,0,1)),
			west,
				@loc = _vec_add(@loc, array(-1,0,0)),
			east,
				@loc = _vec_add(@loc, array(1,0,0))
				
		)

		if(split(':', get_block_at(@loc))[0] != 0, die())
				
		if(
		
			array(@pl[0] + 0, @pl[1] + 0, @pl[2] + 0, @pl[3]) == @loc ||
			array(@pl[0] + 1, @pl[1] + 1, @pl[2] + 1, @pl[3]) == @loc ||
			array(@pl[0] + 1, @pl[1] + 1, @pl[2] + -1, @pl[3]) == @loc ||
			array(@pl[0] + 0, @pl[1] + 1, @pl[2] + 0, @pl[3]) == @loc ||
			array(@pl[0] + -1, @pl[1] + 1, @pl[2] + 1, @pl[3]) == @loc ||
			array(@pl[0] + -1, @pl[1] + 1, @pl[2] + -1, @pl[3]) == @loc

			, die()
		),
		
		if(@event[block] == '43:15', die())
		
		if(
		
			array(@pl[0] + 1, @pl[1] + 0, @pl[2] + 1, @pl[3]) == @loc ||
			array(@pl[0] + 1, @pl[1] + 0, @pl[2] + -1, @pl[3]) == @loc ||
			array(@pl[0] + -1, @pl[1] + 0, @pl[2] + 1, @pl[3]) == @loc ||
			array(@pl[0] + -1, @pl[1] + 0, @pl[2] + -1, @pl[3]) == @loc ||
			array(@pl[0] + 0, @pl[1] + 0, @pl[2] + 1, @pl[3]) == @loc ||
			array(@pl[0] + 0, @pl[1] + 0, @pl[2] + -1, @pl[3]) == @loc ||
			array(@pl[0] + 0, @pl[1] + 0, @pl[2] + 0, @pl[3]) == @loc ||
			array(@pl[0] + -1, @pl[1] + 0, @pl[2] + 0, @pl[3]) == @loc ||
			array(@pl[0] + -1, @pl[1] + 0, @pl[2] + -0, @pl[3]) == @loc

			, die()
		),
		

		if(
		
			array(@pl[0] + 1, @pl[1] + 1, @pl[2] + 0, @pl[3]) != @loc &&
			array(@pl[0] - 1, @pl[1] + 1, @pl[2] + 0, @pl[3]) != @loc &&
			array(@pl[0] + 0, @pl[1] + 1, @pl[2] + 1, @pl[3]) != @loc &&
			array(@pl[0] + 0, @pl[1] + 1, @pl[2] - 1, @pl[3]) != @loc &&
			array(@pl[0] + 1, @pl[1] + 2, @pl[2] + 0, @pl[3]) != @loc &&
			array(@pl[0] - 1, @pl[1] + 2, @pl[2] + 0, @pl[3]) != @loc &&
			array(@pl[0] + 0, @pl[1] + 2, @pl[2] + 1, @pl[3]) != @loc &&
			array(@pl[0] + 0, @pl[1] + 2, @pl[2] - 1, @pl[3]) != @loc

			, die()
		)

	)

	switch(pinfo()[6],
		 '351:10',
		 
			@green = import('ocp.gm.green.'.player())
			@green_locs = import('ocp.gm.greenlocs.'.player())
			
			if(@green === null, @green = 5)

			if(@green <= 0, die())
			@green -= 1
			
			msg(@green . ' wools left!')
			
			if(!is_array(@green_locs), @green_locs = array())
			@green_locs[] = @loc
			
			export('ocp.gm.greenlocs.'.player(), @green_locs)
			export('ocp.gm.green.'.player(), @green)
			export('ocp.gm.lastplaced.'.player(), GREEN)
			
			execute(
				closure(
					play_sound(@loc, array(sound: STEP_WOOL))
					set_block_at(@loc, '35:5')
				)
			),

		 '351:5',		
			if(@event[block] == '35:10' || import('ocp.gm.lastplaced.'.player()) === PURPLE, die())
			@purple_locs = import('ocp.gm.purplelocs.'.player())

			if(!is_array(@purple_locs), @purple_locs = array())
			@purple_locs[] = @loc

			execute(
				closure(
					play_sound(@loc, array(sound: STEP_WOOL))
					set_block_at(@loc, '35:10')

					if(split(':', get_block_at(array(@loc[0] + 1, @loc[1] + 0, @loc[2] + 0, @loc[3])))[0] == 0,
						set_block_at(array(@loc[0] + 1, @loc[1] + 0, @loc[2] + 0, @loc[3]), '65:5')
					)
					if(split(':', get_block_at(array(@loc[0] - 1, @loc[1] + 0, @loc[2] + 0, @loc[3])))[0] == 0,
						set_block_at(array(@loc[0] - 1, @loc[1] + 0, @loc[2] + 0, @loc[3]), '65:4')
					)
					if(split(':', get_block_at(array(@loc[0] + 0, @loc[1] + 0, @loc[2] + 1, @loc[3])))[0] == 0,
						set_block_at(array(@loc[0] + 0, @loc[1] + 0, @loc[2] + 1, @loc[3]), '65:3')
					)
					if(split(':', get_block_at(array(@loc[0] + 0, @loc[1] + 0, @loc[2] - 1, @loc[3])))[0] == 0,
						set_block_at(array(@loc[0] + 0, @loc[1] + 0, @loc[2] - 1, @loc[3]), '65:2')
					)

				)
			)
			
			if(array_size(@purple_locs) > 3,
				@loc = @purple_locs[0]
				set_block_at(@loc, '0')
				array_remove(@purple_locs, 0)
			)
			
			export('ocp.gm.purplelocs.'.player(), @purple_locs[])			
			export('ocp.gm.lastplaced.'.player(), PURPLE),
			
		'351:8',

		@block = get_block_at(@loc)
		execute(
			closure(
				play_sound(@loc, array(sound: STEP_WOOL))
				switch(@event[facing],
					up,
						if(split(':', get_block_at(_vec_add(@loc, array(0,-1,0))))[0] != 0, die())
						set_block_at(@loc, 0)
						set_block_at(_vec_add(@loc, array(0,-1,0)), @block),
					down,
						if(split(':', get_block_at(_vec_add(@loc, array(0,1,0))))[0] != 0, die())
						set_block_at(@loc, 0)
						set_block_at(_vec_add(@loc, array(0,1,0)), @block),
					north,
						if(split(':', get_block_at(_vec_add(@loc, array(0,0,1))))[0] != 0, die())
						set_block_at(@loc, 0)
						set_block_at(_vec_add(@loc, array(0,0,1)), @block),
					south,
						if(split(':', get_block_at(_vec_add(@loc, array(0,0,-1))))[0] != 0, die())
						set_block_at(@loc, 0)
						set_block_at(_vec_add(@loc, array(0,0,-1)), @block),
					west,
						if(split(':', get_block_at(_vec_add(@loc, array(1,0,0))))[0] != 0, die())
						set_block_at(@loc, 0)
						set_block_at(_vec_add(@loc, array(1,0,0)), @block),
					east,
						if(split(':', get_block_at(_vec_add(@loc, array(-1,0,0))))[0] != 0, die())
						set_block_at(@loc, 0)
						set_block_at(_vec_add(@loc, array(-1,0,0)), @block)
						
				)
				
			)
		)

	)

)

bind(entity_enter_portal, null, null, @event,

	try(@player = get_player_from_entity_id(@event[id]), die())

	@green = import('ocp.gm.green.'.@player)
	@green_locs = import('ocp.gm.greenlocs.'.@player)
	
	try(foreach(@green_locs, @loc, set_block_at(@loc, '0')))
	
	export('ocp.gm.greenlocs.'.@player, array())	
	export('ocp.gm.lastplaced.'.@player, null)	
	
	if(@green === 5, die())
	
	@green = 5
	msg('Wool refilled!')
	export('ocp.gm.green.'.@player, @green)	

	cancel()

)
*/
