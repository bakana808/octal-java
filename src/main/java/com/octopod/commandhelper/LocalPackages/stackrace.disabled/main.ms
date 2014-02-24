
foreach(all_virtualchests(), @id, del_virtualchest(@id))

create_virtualchest(
	array(
		id: 0,
		title: color(f) . color(l) . 'Level Packs',
		size: 9,
	)
)

@maps = array()

foreach(array_sort(directory_contents('maps/'), 'STRING'), @filename,

	@file = yml_decode(read('maps/'.@filename))
	@pack_size = array_size(@file) - 2
	
	if(@pack_size <= 9) { @chest_size = 9 }
	else if(@pack_size <= 18) { @chest_size = 18 }
	else if(@pack_size <= 27) { @chest_size = 27 }
	else if(@pack_size <= 36) { @chest_size = 36 }
	else if(@pack_size <= 45) { @chest_size = 45 }
	else { @chest_size = 54 }
	
	@chests = all_virtualchests()
	@chest_id = array_size(@chests)
		
		@item_array = array(lore: array())	
			
		@pack_name = colorize(@file['pack-name'])
		@item_array[display] = @pack_name
			
		@pack_desc = split('>>', colorize(@file['pack-desc']))				
		foreach(@pack_desc, @line, @item_array[lore][] = @line)		
			
		@item_array[lore][] = color(0) . @chest_id
		
	addto_virtualchest(0, 339, 1, @item_array)	
	
	create_virtualchest(
		array(
			id: @chest_id,
			title: color(f) . color(l) . strip_colors(@pack_name),
			size: @chest_size,
		)
	)	

	foreach(@file, @id, @map,
	
		if(@id == 'pack-name' || @id == 'pack-desc', continue())

		@maps[@id] = @map
		@desc = split('>>', colorize(@map[desc]))	
		
		switch(@map[diff],
			0,
				@item = '35:3'
				@diff = color(b) . 'BEGINNER',
			1,
				@item = '35:5'
				@diff = color(a) . 'EASY',
			2,
				@item = '35:4'
				@diff = color(e) . 'NORMAL',
			3,
				@item = '35:1'
				@diff = color(6) . 'HARD',
			4,
				@item = '35:14'
				@diff = color(c) . 'INSANE',
				@item = '35:15'
				@diff = color(f) . '?????',
		)
		
		@item_array = 		
			array(
				display: color(e) . @map[name],
				lore: array(
						color(7) . 'Author: ' . color(f) . @map[author],
						color(7) . 'Difficulty: ' . @diff,
					)
			)
			
		foreach(@desc, @line,
			@item_array[lore][] = @line
		)
		
		@item_array[lore][] = color(0) . @id	
		
		addto_virtualchest(@chest_id, @item, 1, @item_array)
		
	)
	
)

bind(player_join, array(priority: monitor), null, @event,

	_restore()
	
	set_ploc(array(55, 9, -0.5, gm_lobby))
	pfacing(90, 0)
	
	_equip()

	#@inv[0] = array(type: 351, data: 10, meta: array(display: color(a) . color(l) . 'PLATFORMS'))
	#@inv[1] = array(type: 351, data: 5, meta: array(display: color(d) . color(l) . 'ANCHORS'))
	#@inv[2] = array(type: 351, data: 8, meta: array(display: color(7) . color(l) . 'PUSH BLOCK'))
	 
)

bind(player_quit, null, null, @event,

	export('race.playing.'.player(), null)
	
	@full = import('race.maps.full')
	array_remove(@full, player())
	export('race.maps.full', @full)
		
)

bind(entity_damage, null, null, @event,
	if(@event[cause] == STARVATION,
		cancel()
		modify_event(amount, 0)
	)
)

bind(block_break, null, null, @event, 
	if(pmode() != 'CREATIVE', 
		@loc = ploc()
		set_timeout(1000, closure(set_ploc(@loc)))
		cancel()
	)
)
bind(block_place, null, null, @event, 	
	if(pmode() != 'CREATIVE', 
		@loc = ploc()
		set_timeout(1000, closure(set_ploc(@loc)))
		cancel()
	)
)

bind(item_spawn, null, null, @event, cancel())

bind(inventory_click, null, null, @event,

	if(pmode() != 'CREATIVE', cancel())
	
	@chest = pget_virtualchest()

	if(@chest === null || @event[action] != PICKUP_ALL, die())

	@slot = @event[rawslot]	
	@inv = @event[inventory]
	
	if(array_index_exists(@inv, @slot) && @inv[@slot] != null) {
	
		close_pinv()

		@lore = @inv[@slot][meta][lore]
		@id = strip_colors(@lore[array_size(@lore) - 1])

		switch(@chest,
			0,		
				popen_virtualchest(@id),		
				_game_start(@id)
		)

	}
	
)

bind(player_move, null, array(threshold: 5), @event,

	@loc = ploc()
	
	if(@loc[1] < 0,
	
		_game_end(1),

	)
	
)

bind(entity_enter_portal, null, null, @event,

	@map = import('race.playing.'.player())
	
	if(@map === null, die())
	
	#if(_within_region(@event[location], @map[end_1], @map[end_2]),
	
		_game_end(0)

	#)

)

bind(pressure_plate_activated, null, null, @event,

	@loc = @event[location]
		@x = integer(@loc[0])
		@y = integer(@loc[1])
		@z = integer(@loc[2])
		
	@a = array()

	if(@x == 37 && @y == 9 && @z == 21) {
	
		@a[] = '&f&l[RIGHT-CLICK]&6 the sides of blocks to push them.'
		@a[] = ''
		@a[] = '&eThe shaded area on the floor represents the farthest you can be in order to move that block.'
		@a[] = ''
		@a[] = '&fAlso, you can only move white blocks!'

	}
	
	if(@x == 27 && @y == 11 && @z == 21) {

		@a[] = '&f&l[SNEAK+RIGHT-CLICK]&6 the sides of blocks to pull them.'
		@a[] = ''
		@a[] = '&eThe range is the same for pushing and pulling.'

	}
	
	if(@x == 18 && @y == 13 && @z == 21) {
	
		@a[] = '&6Touch the portal to win the level!'
		@a[] = '&6Ranks are given to people who win levels quickly.'

	}

	msg(colorize('&8----------------------------------------------------+'))
	foreach(@a, @line, msg(' ' . colorize(@line)))
	msg(colorize('&8----------------------------------------------------+'))
	
)
		
	
		

export('race.maps.full', associative_array())
export('race.maps', @maps)

#====================================================================================================
 
bind(player_interact, null, null, @event,

	@map = import('race.playing.'.player())
	
	if(@map != null)
	{
	
		switch(pinfo()[6],
			'340:0',
				die(),
			'385:0',
				_game_end(1)
				die()
		)
		
		
		if(pmode() == 'CREATIVE', die())
	
		if(!array_index_exists(@event, facing) || !array_index_exists(@event, location), die())
		
		@pl = _player_block()
		
		@dir = _dir()
		@facing = @event[facing]
		@loc = @event[location]
		@dist = _vec_sub(@loc, @pl)
			@x = @dist[0]
			@y = @dist[1]
			@z = @dist[2]
		
		/*
		try(
			if(@facing == up && @event[button] == right, 
				if(_type(_vec_add(@loc, array(0,1,0))) == 0 && _type(_vec_add(@event[location], array(0,2,0))) == 0,
					if(
						_vec_add(@pl, array(0,1,1)) == @loc ||
						_vec_add(@pl, array(0,1,-1)) == @loc ||
						_vec_add(@pl, array(1,1,0)) == @loc ||
						_vec_add(@pl, array(-1,1,0)) == @loc,
						set_ploc(_vec_add(@loc, array(0.5, 0, 0.5)))
						die()
					)
				)
			)
		)
		*/

		switch(pinfo()[6],
			'351:10',	
				@blocks = import('race.blocksleft.'.player())
				
				if(@blocks <= 0, 
					msg('You have no blocks left!')
					die(),				
				)

				if(@event[block] != '43:8', _invalid_move('Can only place blocks on gray stone!'))
				
				switch(@facing,
					up,
						@loc = _vec_add(@loc, array(0,1,0)),
					down,
						@loc = _vec_add(@loc, array(0,1,0)),
					north,
						@loc = _vec_add(@loc, array(0,0,-1)),
					south,
						@loc = _vec_add(@loc, array(0,0,1)),
					west,
						@loc = _vec_add(@loc, array(-1,0,0)),
					east,
						@loc = _vec_add(@loc, array(1,0,0))
				)
				
				if(_type(@loc) != 0, die())
				
				@blocks -= 1
				msg(@blocks . ' blocks left!')
					
				export('race.blocksleft.'.player(), @blocks)

				execute(
					closure(
						play_sound(@loc, array(sound: STEP_WOOL))
						set_block_at(@loc, '155:1')
					)
				),
			'351:5',	

				if(@event[block] != '155:1' && @event[block] != '43:15', die())
				
				@block = split(':', get_block_at(@pl))

				if(@block[0] == 0 || !is_integral(ploc()[1]), die())
				
				#'35:7', '35:8', '35:11', '35:14'
				@block_play = array('43:15', '155:1', '112:0')
						
				#if(!array_contains(@block_play, get_block_at(@pl)) && _type(@pl) != 0, 
				#	_invalid_move('Can only move blocks on white or black stone!')
				#)
				
				#if(@dir == down,
					switch(@facing,
						up,
							@dir = down,
						down,
							@dir = up,
						north,
							@dir = south,
						south,
							@dir = north,
						east,
							@dir = west,
						west,
							@dir = east,
					)
				#)
				
				if(pinfo(player(), 11)) {

						switch(@dir,
						
							up,	
								if(@x != 0 && @z != 0 && @y != 4){
									@out_of_range = true
								},
							
								if(@x > 2 || @x < -2 || @z > 2 || @z < -2 || @y != 1){
									@out_of_range = true
								}
							
						)
						
				} else {

					switch(@dir,
					
						up,	
							if(@x != 0 && @z != 0 && @y != 3){
								@out_of_range = true
							},
							
						down,
							if(@x != 0 && @z != 0 && @y != 0){
								@out_of_range = true
							},
						
							if(@x > 2 || @x < -2 || @z > 2 || @z < -2 || @y != 1){
								@out_of_range = true
							}
						
					)
					
				}
				
				if(@out_of_range == true,
					_invalid_move('Out of range to move block!') 
					_show_range()
				)

				if(pinfo(player(), 11)) {

					switch(@dir,

						up,
						
							#if(_vec_add(@pl, array(0,4,0)) != @loc, _invalid_move('Must be under block to pull down!'))
							@to_loc = _vec_add(@loc, array(0,-1,0)),
							
						south,

							@to_loc = _vec_add(@loc, array(0,0,-1))
							if(@block[0] == 0 || @z == 1,
								@set_loc = _vec_add(ploc(), array(0, 0, -1))
							),

						north,
					
							@to_loc = _vec_add(@loc, array(0,0,1))
							if(@block[0] == 0 || @z == -1,
								@set_loc = _vec_add(ploc(), array(0, 0, 1))
							),

						east,
						
							@to_loc = _vec_add(@loc, array(-1,0,0))
							if(@block[0] == 0 || @x == 1,
								@set_loc = _vec_add(ploc(), array(-1, 0, 0))
							),

						west,
						
							@to_loc = _vec_add(@loc, array(1,0,0))
							if(@block[0] == 0 || @x == -1,
								@set_loc = _vec_add(ploc(), array(1, 0, 0))
							),

							die()
							
					)
					
				} else {
				
					#if(is_array(@set_loc) && !array_contains(@block_play, get_block_at(@set_loc)), _invalid_move()),

					@range_long = 
						array(
								_vec_add(@pl, array(0,0,0)),
								_vec_add(@pl, array(0,3,0)),
								_vec_add(@pl, array(0,2,2)), #_vec_add(@pl, array(0,2,2)),			
								_vec_add(@pl, array(0,2,-2)), #_vec_add(@pl, array(0,2,-2)),	
								_vec_add(@pl, array(2,2,0)), #_vec_add(@pl, array(2,2,0)),	
								_vec_add(@pl, array(-2,2,0)), #_vec_add(@pl, array(-2,2,0)),	
						)
						
					@range_short = 
						array(
								_vec_add(@pl, array(0,2,1)), #_vec_add(@pl, array(0,2,1)),			
								_vec_add(@pl, array(0,2,-1)), #_vec_add(@pl, array(0,2,-1)),
								_vec_add(@pl, array(1,2,0)), #_vec_add(@pl, array(1,2,0)),
								_vec_add(@pl, array(-1,2,0)), #_vec_add(@pl, array(-1,2,0)),
						)
										
					#if(!array_contains(@range_long, @loc) && !array_contains(@range_short, @loc), _invalid_move('Out of movable range of block!'))

					switch(@dir,

						down,
						
							#if(_vec_add(@pl, array(0,0,0)) != @loc, _invalid_move('Must be on block to push down!'))
							@to_loc = _vec_add(@loc, array(0,-1,0))
							while(get_block_at(@to_loc) == '43:15' && get_block_at(@to_loc) == '155:1', @to_loc = _vec_add(@to_loc, array(0,-1,0))),
							
						up,
						
							#if(_vec_add(@pl, array(0,3,0)) != @loc, _invalid_move('Must be under block to push up!'))
							@to_loc = _vec_add(@loc, array(0,1,0))
							while(get_block_at(@to_loc) == '43:15' || get_block_at(@to_loc) == '155:1', @to_loc = _vec_add(@to_loc, array(0,1,0))),
							
						south,

							@to_loc = _vec_add(@loc, array(0,0,1))
							while(get_block_at(@to_loc) == '43:15' || get_block_at(@to_loc) == '155:1', @to_loc = _vec_add(@to_loc, array(0,0,1))),
							
						north,

							@to_loc = _vec_add(@loc, array(0,0,-1))
							while(get_block_at(@to_loc) == '43:15' || get_block_at(@to_loc) == '155:1', @to_loc = _vec_add(@to_loc, array(0,0,-1))),
							
						east,

							@to_loc = _vec_add(@loc, array(1,0,0))
							while(get_block_at(@to_loc) == '43:15' || get_block_at(@to_loc) == '155:1', @to_loc = _vec_add(@to_loc, array(1,0,0))),
							
						west,

							@to_loc = _vec_add(@loc, array(-1,0,0))
							while(get_block_at(@to_loc) == '43:15' || get_block_at(@to_loc) == '155:1', @to_loc = _vec_add(@to_loc, array(-1,0,0))),
							
							die()
							
					)
				}

				if(is_array(@set_loc), @pl = @set_loc)
				
				if(
					_type(_vec_add(@pl, array(0,1,0))) != 0 ||  _type(_vec_add(@pl, array(0,2,0))) != 0,
					#_vec_add(@pl, array(0,1,0)) == @to_loc ||  _vec_add(@pl, array(0,2,0)) == @to_loc,
					_invalid_move('Collision with yourself!')
				)

				if(_type(@to_loc) != 0,
					_invalid_move('Collision with solid block!', @loc)
				)
				
				@block = get_block_at(@loc)
				
				execute(
					closure(
						make_effect(@loc, 'STEP_SOUND:155')
						play_sound(@loc, array(sound: PISTON_EXTEND, pitch: 1))
						set_block_at(@loc, 0)
						set_block_at(@to_loc, @block)
						if(is_array(@set_loc), set_ploc(@set_loc))
					)
				)

		)

	}
	else
	{
		if(pinfo()[15] == 0, popen_virtualchest(0))
	}
	
)

foreach(all_players(), @player, scriptas(@player, _game_end()))
				