
proc(_type, @loc,

	return(split(':', get_block_at(@loc))[0])
	
)

proc(_restore,

	_emptyinv(player())
	set_pwalkspeed(0.35)
	set_pfood(0)
	set_phealth(20)
	#set_peffect(player(), 8, -10, 999999)
	set_peffect(player(), 8, 0, 0)
	set_timeout(200, closure(set_pmode(player(), 'ADVENTURE')))
	
)

proc(_equip, @type,

	@inv = _emptyinv()

	if(@type == 1,
	
		@blocks = import('race.blocksleft.'.player())
		@movable = import('race.canmove.'.player())
		
		if(@blocks != 0 || @movable != false) {
			if(@blocks != 0 && @movable == false) {
				@inv[0] = array(type: 351, data:10, meta: array(display: color(a) . color(l) . 'Create Block'))
			}
			if(@blocks == 0 && @movable == true) {
				@inv[0] = array(type: 351, data:5, meta: array(display: color(d) . color(l) . 'Move Block'))
			}
			if(@blocks != 0 && @movable == true) {	
				@inv[0] = array(type: 351, data:5, meta: array(display: color(d) . color(l) . 'Move Block'))		
				@inv[1] = array(type: 351, data:10, meta: array(display: color(a) . color(l) . 'Create Block'))
			}
			@inv[7] = array(type: 340, meta: array(display: color(8) . color(l) . 'Undo Move (not yet working)'))
		}
		
		@inv[8] = array(type: 385, meta: array(display: color(6) . color(l) . 'Give Up?')),
	
		@inv[0] = array(type: 340, meta: array(display: color(l) . 'Browse Level Packs'))

	)
	
	set_pinv(@inv)
	
)
			
		

proc(_dir, 
	
	switch(round(pfacing()[1] / 90) * 90,
	
		-90,
			return(up),
		90,
			return(down),
			
			switch(round(pfacing()[0] / 90) * 90,
				0, 
					return(south),
				90,
					return(west),
				180,
					return(north),
				270,
					return(east)
			)
			
	)
	
)		

proc(_invalid_move, @reason, @loc,

	if(@reason == '',
		msg(color(c) . 'Invalid Move!'),
		msg(color(c) . 'Invalid Move: ' . color(7) . @reason)
	)
		
	if(is_array(@loc), make_effect(@loc, 'STEP_SOUND:112'))
	
	play_sound(ploc(), array(sound:STEP_STONE, pitch:2))

	die()
	
)

proc(_show_range,

	@loc = ploc()
	@floor = array(floor(@loc[0]), floor(@loc[1]), floor(@loc[2]), @loc[3])
	@locs = array()

	@y = @floor[1]
	
	@max_x = @floor[0] + 2
	@max_z = @floor[2] + 2
	
	for(@x = @floor[0] - 2, @x <= @max_x, @x++,
		for(@z = @floor[2] - 2, @z <= @max_z, @z++,
			@locs[] = array(@x, @y, @z)
			@locs[] = array(@x, @y + 1, @z)
		)
	)
	
	foreach(@locs, @l,
		if(_type(@l) != 0,
			psend_block_change(@l, '35:14')
		)
	)
	
	set_timeout(1000,
		closure(
			foreach(@locs, @l,
				psend_block_change(@l, get_block_at(@l))
			)
		)
	)
)

proc(_block_supported, @loc,

	if(_type(_vec_add(@loc, array(0,-1,0))) != 0, return(true))
	if(_type(_vec_add(@loc, array(1,-1,0))) != 0, return(true))
	if(_type(_vec_add(@loc, array(-1,-1,0))) != 0, return(true))
	if(_type(_vec_add(@loc, array(0,-1,1))) != 0, return(true))
	if(_type(_vec_add(@loc, array(0,-1,-1))) != 0, return(true))
	
	return(false)
	
)

proc(_player_block,

	@loc = ploc()
	@floor = array(floor(@loc[0]), floor(@loc[1]), floor(@loc[2]), @loc[3])
	
	if(_type(@floor) != 0, return(@floor))
	
	@x = mod(floor(@loc[0] * 100), 100)
		if(@x < 0, @x += 100)
	@z = mod(floor(@loc[2] * 100), 100)
		if(@z < 0, @z += 100)

	if(@x < 30 || 70 <= @x,
		if(@x < 30,
			@floor = _vec_add(@floor, array(-1, 0, 0)),
			@floor = _vec_add(@floor, array(1, 0, 0))
		)
	)

	if(@z < 30 || 70 <= @z,
		if(@z < 30,
			@floor = _vec_add(@floor, array(0, 0, -1)),
			@floor = _vec_add(@floor, array(0, 0, 1))
		)
	)

	return(@floor)

)

proc(_game_start, @id,
	
	@maps = import('race.maps')
	@full = import('race.maps.full')
	
	foreach(@full, @full_id,
		if(@full_id == @id,
			msg(colorize('&6Sorry, somebody is playing this map right now!'))
			return(false)
		)
	)
	
	if(!array_index_exists(@maps, @id), 
		msg(colorize('&6Sorry, this map is unplayable right now!'))
		return(false)
	)
	
	@map = @maps[@id]

	msg(color(a) . 'Reach the portal!')
	
	if(array_index_exists(@map, 'block-place') && is_numeric(@map['block-place']),
		export('race.blocksleft.'.player(), @map['block-place']),
		export('race.blocksleft.'.player(), 0)
	)
	
	if(array_index_exists(@map, 'block-move') && @map['block-move'] == 0,
		export('race.canmove.'.player(), false),
		export('race.canmove.'.player(), true)
	)
	
	_restore()
	_equip(1)

	@loc = @map[spawn_loc]
	@ang = @map[spawn_ang]

	export('race.playing.'.player(), @map)
	export('race.time.'.player(), time())

	@full[player()] = @id
	export('race.maps.full', @full)
	
	set_ploc(@loc)
	pfacing(@ang[0], @ang[1])
	
	return(true)
	
)

proc(_game_end, @type,

	_restore()
	
	set_pvelocity(array(0,0,0))
	set_ploc(get_spawn())
	pfacing(90, 0)
		
	_equip()

	@full = import('race.maps.full')

	if(array_index_exists(@full, player())) {
		@id = @full[player()]
		array_remove(@full, player())
	}
			
	if(@type == 0 || @type == 1) {

		@map = import('race.playing.'.player())

		if(@type == 1,
			broadcast(player() . color(7) . ' has failed ' . color(f) . @map[name] . color(7) . '!'),
			@time = import('race.time.'.player())
			if(@time !== null,
				@left = time() - @time
				@s = floor(@left / 1000)
				@ms = sprintf('%03d', mod(@left, 1000))
				@m = sprintf('%02d', floor(@s / 60))
				@s = sprintf('%02d', mod(@s, 60))
				if(@left <= @map[time_1],
					@msg = player() . color(7) . ' won ' . color(e) . '[RANK S]' . color(7) . ' on ' . color(f) . @map[name] . color(7) . '!',
					if(@left <= @map[time_2],
						@msg = player() . color(7) . ' won ' . color(a) . '[RANK A]' . color(7) . ' on ' . color(f) . @map[name] . color(7) . '!',
						if(@left <= @map[time_3],
							@msg = player() . color(7) . ' won ' . color(9) . '[RANK B]' . color(7) . ' on ' . color(f) . @map[name] . color(7) . '!',
							@msg = player() . color(7) . ' won ' . color(d) . '[RANK C]' . color(7) . ' on ' . color(f) . @map[name] . color(7) . '!'
						)
					)
				)
				@msg .= color(7) . ' [' . color(6) . @m . ':' . color(e) . @s . '.' . @ms . color(7) . ']'
				broadcast(@msg)
			)
		)
		
		msg(colorize('&8----------------------------------------------------+'))
		msg(colorize('&dResetting Level...'))
		sudo('//schematic load ' . @id)
		sudo('//paste -o')
		msg(colorize('&8----------------------------------------------------+'))
			
	}

	export('race.maps.full', @full)		
		
	export('race.playing.'.player(), null)
	
)