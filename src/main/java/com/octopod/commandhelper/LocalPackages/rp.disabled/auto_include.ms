
include('proc.library/combat.ms')
include('proc.library/player.ms')
include('proc.library/items.ms')
include('proc.library/room.ms')
include('proc.library/loot.ms')
include('proc.library/mob.ms')

proc(_room_printLayout, @player,

	@room = _player_getRoom(@player)
	@layout = _player_getKnownRooms(@player)
	
	if(!is_array(@layout), return(false))
	
	@min_x = 0
	@min_y = 0
	@max_x = 0
	@max_y = 0

	foreach(@layout, @loc,

		if(@loc[0] < @min_x, @min_x = @loc[0])
		if(@loc[0] > @max_x, @max_x = @loc[0])
		if(@loc[1] < @min_y, @min_y = @loc[1])
		if(@loc[1] > @max_y, @max_y = @loc[1])
		
	)

	@y_range = range(@min_y - 1, @max_y + 2)
		array_reverse(@y_range)
		
	@x_range = range(@min_x - 1, @max_x + 2)
	
	@l = array()
	
	foreach(@y_range, @y,
	
		@line = ''
		
		foreach(@x_range, @x,

			if(array_contains(@layout, array(@x, @y))) {
				if(@room == array(@x, @y),
					@line .= color(f) . '\u2588',
					switch(_room_getRoomType(array(@x, @y)),
						0, #Normal Room
							@line .= color(8) . '\u2588',
						1, #Spawn Room
							@line .= color(7) . '\u2588',
						2, #Chest Room
							@line .= color(6) . '\u2588',
						3, #Boss Room
							@line .= color(c) . '\u2588',
						4, #Shop Room
							@line .= color(a) . '\u2588',
					)
				) 
			} else
			if(@room == array(@x, @y)) {
				@line .= color(f) . '\u2588', @line .= color(0) . '\u2588'
			}
			
		)
		
		@l[] = @line
		
	)

	foreach(@l, @line, tmsg(@player, @line))
	
)

proc(_show_status, @player,

	@settings = import('user.'.@player)
	@l = array()
	#310
	
	@hp = sprintf('%03d', integer(pinfo(@player)[5]))
	@hp_max = 20
	
	@xp = sprintf('%03d', 0)
	@xp_max = 20
	
	@mp = sprintf('%03d', plevel(@player))
	@mp_max = 20
	
	execute(
		closure(
		
			@l[] = '&8+---------------------------------------------------+'
			@l[] = '&8`|'. _adv_string_fill(color(e) . color(l) . player() . ', the Player' . color(r), 310, 2) . '&8|'
			@l[] = '&8+---------------------------------------------------+'
			@hp_title =  _adv_string_fill(cc('&c&l' @hp ' ' _make_bar(20, (@hp / @hp_max), array(color(c), color(0), color(4), '\u258C')) ' &c&lHP&r'), 100, 2)
			@xp_title =  _adv_string_fill(cc('&a&l' @xp ' ' _make_bar(20, (@xp / @xp_max), array(color(a), color(0), color(2), '\u258C')) ' &a&lXP&r'), 110, 2)
			@mp_title =  _adv_string_fill(cc('&d&l' @mp ' ' _make_bar(20, (@mp / @mp_max), array(color(d), color(0), color(5), '\u258C')) ' &d&lMP&r'), 100, 2)
			@l[] = '&8`|'. @hp_title . @xp_title . @mp_title . '&8|'
			@l[] = '&8+---------------------------------------------------+'
			
			foreach(@l, @line, msg(colorize(@line)))
			
		)
	)
	
)


proc(_room_getStatus, @roomID, return(import('roomStatus.'.@roomID[0].'.'.@roomID[1])))
proc(_room_setStatus, @roomID, @status, export('roomStatus.'.@roomID[0].'.'.@roomID[1], @status))

proc(_projectile, @player, @type, @dmg,

	@id = shoot_projectile(@player, @type)
	
	@projectiles = import('projectiles')
	
	if(!is_array(@projectiles), @projectiles = array())
	
	@projectiles[@id] = array(@player, @dmg)
	
	export('projectiles', @projectiles)
	
	return(@id)

)

proc(_projectile_remove, @id,

	@projectiles = import('projectiles')
	
	if(!is_array(@projectiles), return(false))
	
	if(entity_exists(@id), entity_remove(@id))
	
	array_remove(@projectiles, @id)
	
	export('projectiles', @projectiles)
	
	return(true)

)

proc(_iterate, @1, @2,

	@locs = array()

	for(@x = min(@1[0], @2[0]), @x <= max(@1[0], @2[0]), @x += 1,
		for(@y = min(@1[1], @2[1]), @y <= max(@1[1], @2[1]), @y += 1,
			for(@z = min(@1[2], @2[2]), @z <= max(@1[2], @2[2]), @z += 1,
				@locs[] = array(@x, @y, @z)
			)
		)
	)
	
	return(@locs)
	
)

proc(_make_bar, @length, @percent, @colors,

	if(!is_array(@colors),
		@colors = array(color(c), color(0), color(4), '|')
	)

	@p_inc = 1 / @length

	@lastcolor = null
	@color = @colors[0]
	@gray = @colors[1]
	
	while(@length > 0,

		if(@percent > 0,
			if(@lastcolor == COLOR,
				@bar .= @colors[3],
				@bar .= @color . @colors[3]
			)
			@lastcolor = COLOR,
			if(@lastcolor == GRAY,
				@bar .= @colors[3],
				@bar .= @gray . @colors[3]
			)
			@lastcolor = GRAY
		)
		
		@percent -= @p_inc
		@length--
		
	)

	return(@colors[2] . '[' . @bar . @colors[2] . ']')
	
)

proc(_scoreboard_reset, @player,

	@scoreboards = get_scoreboards()

	if(array_contains(@scoreboards, @player)) { remove_scoreboard(@player, true) }

	create_scoreboard(@player)
	create_objective(INFO, DUMMY, @player)

	set_objective_display(INFO, array(displayname: '', slot: SIDEBAR), @player)
	set_pscoreboard(@player, @player)
	
	_scoreboard_update(@player)
	
)
	
proc(_scoreboard_update, @player,

	set_pscore(INFO, color(6) . 'Gold', 1, @player)
	set_pscore(INFO, color(6) . 'Gold', 0, @player)
	set_pscore(INFO, color(7) . 'Keys', 1, @player)
	set_pscore(INFO, color(7) . 'Keys', 0, @player)

)


