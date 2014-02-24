		
#FUTURE REFERENCE: for @key, you can use arrays instead of strings. 
#Example: array('player', 'settings', 'chat') is equivilant to 'player.settings.chat'

#returns true and runs a timer. Until the timer is finished, it returns false.

proc(_ocp_wait, @key, @ms,

	@key = 'ocp.wait.'.@key
	@check = import(@key.'')

	if(@check == null,
		set_timeout(@ms,
			closure(
				export(@key.'', null)
			)
		)
		export(@key.'', true)
		return(true),
		return(false)		
	)

)

#======================================================================================================#
#	YML Config Functions
#======================================================================================================#

proc(_ocp_mod_info, @mod,
	
	@mod_loaded = import('ocp.mod.loaded')
	
	try(
		if(array_contains(@mod_loaded, @mod),
			@mod_infos = import('ocp.mod.infos')
			@info = @mod_infos[@mod]
			try(
				@mod_name = @info[name],
				@mod_name = @mod
				@no_name = true
			)
			try(
				@mod_vers = @info[version], 
				@mod_vers = 'n/a'
				@no_vers = true
			)
			try(
				@mod_auth = @info[author], 
				@mod_auth = 'n/a'
				@no_auth = true
			)
			try(
				@mod_conf = @info[config],
				@mod_conf = 'unspecified'
				@no_conf = true
			)
		),
		@mod_name = @mod
		@mod_vers = 'n/a'
		@mod_auth = 'n/a'
		@mod_conf = 'unspecified'
		@no_name = true
		@no_vers = true
		@no_auth = true
		@no_conf = true
	)
	
	if(@no_name == true || @no_vers == true || @no_auth == true || @no_conf == true,
		@status = 'INCOMPLETE'
		if(@no_name == true && @no_vers == true && @no_auth == true && @no_conf == true,
			@status = 'NONE'
		),
		@status = 'COMPLETE'
	)

	return(array(@mod_name, @mod_vers, @mod_auth, @mod_conf, @status))
	
)

#returns the decoded config file
proc(_ocp_mod_debug, @foldername,
	@mod_configs = import('ocp.mod.configs')
	try(
		return(@mod_configs[@foldername]),
		return(associative_array())
	)
)

proc(_ocp_mod_cfg, @foldername, @option,
	@mod_configs = import('ocp.mod.configs')
	try(
		@contents = @mod_configs[@foldername]
		foreach(split('.', @option), @i,
			@contents = @contents[@i]
		)
		return(@contents),
		return(null)
	)
)

#path is relative to the CommandHelper/LocalPackages/OCP/ folder
proc(_ocp_mod_makecfg, @path, @encoded, 
	write(@path, string(@encoded))
)

#======================================================================================================#
#	Command Functions
#======================================================================================================#

proc(_cmnd_register, @aliases, @node, @docs, @cmnd,

	@array = array()
	
	if(array_size(@aliases) == 0)
	{ die() }
	else
	{ @array[0] = @aliases }
		
	@array[1] = @node

	if(@docs == '')
	{ @array[2] = 'A command.' }
	else
	{ @array[2] = @docs }
	
	if(@cmnd == '')
	{ die() }
	else
	{ @array[3] = @cmnd }
	
	
	@mod_commands = import('ocp.mod.commands')

	array_push(@mod_commands, @array)
	
	export('ocp.mod.commands', @mod_commands)

)

proc(_cmnd_unregister, @root,

	@mod_commands = import('ocp.mod.commands')
	
	@count = 0
	
	foreach(@mod_commands, @array,
		foreach(@array[0], @alias,
			if(@alias == @root,
				array_remove_values(@mod_commands, @array)
				@count = @count + 1
			)
		)
	)
	
	export('ocp.mod.commands', @mod_commands)
	
	return(@count)
	
)

proc(_cmnd_run, @cmd,

	@mod_commands = import('ocp.mod.commands')
	
	foreach(@mod_commands, @array)
	{
		foreach(@array[0], @alias)
		{
			if(string_position(@cmd, @alias) == 0)
			{
				@args = parse_args(substr(@cmd, length(@alias)))
				
				@node = 	@array[1]
				@doc = 		@array[2]
				@closure = 	@array[3]
				
				if(@node != '' && !has_permission(player(), @node), return(false))
				
				execute(@args, player(), @doc, @cmd, @alias, @closure)
				
				return(true)
			}
		}
	}

	if(call_alias(@cmd), return(true))
	if(substr(@cmd, 0, 1) == '/', run(@cmd) return(true))
			
	return(false)
		
)

#======================================================================================================#
#	Base Chat Functions
#======================================================================================================#

proc(_ocp_chat, @m, @as,

	if(@as == '', @as = player())

	try(
		chatas(@as, @m)
		return(true),
		return(false)
	)
	
)

proc(_ocp_broadcast, @m,

	broadcast(@m)
	
)

proc(_ocp_msg, @t, @m,

	if(@t == '', @t = player())

	try(
		tmsg(@t, @m)
		return(true),
		return(false)
	)
	
)

#======================================================================================================#
#	Advanced String Functions
#======================================================================================================#

#returns the width of characters (assume that if a character isn't in this list, its width is 6)
proc(_adv_char_widths, @char,

	@widths = 
		array(
			'\u00a7': 0
			'[': 4,
			']': 4,
			':': 2,
			'\'': 3,
			'|': 2,
			'.': 2,
			'`': 2,
			' ': 4,
			'f': 5,
			'k': 5,
			'I': 4,
			't': 4,
			'l': 3,
			'i': 2,
		)
		
	if(@char == '',
		return(@widths),
		try(
			return(@widths[@char]), 
			return(6)68
		)
	)
	
) 

#returns an array of characters
proc(_adv_char_array, @string,
	
	@array = array()

	for(@i = 0, @i < length(@string), @i++,
		array_push(@array, @string[@i])
	)
	
	return(@array)
	
) 

#finds the applied formats to a position in a string
proc(_adv_string_formats, @string, @pos, @colorize,

	@formats = array()
	
	@colors = reg_match_all('\u00a7[0-9a-fA-Fk-or]', substr(@string, 0, @pos))

	foreach(@colors, @color,
	
		@code = substr(@color[0], 1)
		
		if(@code == 'r', @formats = array())
		
		if(reg_match('[0-9a-fA-Fk-o]', @code) != array(), array_remove_values(@formats, 'l'))
		
		array_push(@formats, @code)	
		
	)
	
	if(@colorize,
		@premade = ''	
		foreach(@formats, @format,
			@premade .= color(@format)
		)
		return(@premade),
		return(@formats)
	)
	
)

proc(_adv_string_fill, @string, @towidth, @align, @sep,

	@color = _adv_string_formats(@string, length(@string), true)

	if(!is_integer(@align), @align = 0)
	
	@left = ''
	
	@width = _adv_string_width(@string)
	
	@extra = @towidth - @width

	while(@width > @towidth,

		@left = substr(@string, length(@string) - 1) . @left
		
		@string = @string[cslice(0, -2)]
		
		@width = _adv_string_width(@string)

		@extra = @towidth - @width

	)
	
	if(@align == 2,
		@extra1 = @extra / 2
		@extra2 = @extra / 2
		if(!is_integer(@extra1),
			@extra1 += 0.5 
			@extra2 -= 0.5
		)
		if(mod(integer(@extra1), 2) != 0,
			@extra1 -= 1
			@extra2 += 1
		)
		@extra = array(integer(@extra1), integer(@extra2)),
		@extra = array(@extra)
	)
	
	@fills = array()

	foreach(@extra, @e,
	
		@fill = ''
		
		while(@e > 5,
			@fill .= ' '
			@e -= 4
		)

		switch(@e,
			5,
				@fill .= color(l) . ' ',
			4,
				@fill .= ' ',
			3, 
				@fill .= @filler_color . color(l) . '`',
			2,
				@fill .= @filler_color . '`'
		)
		
		array_push(@fills, color(r) . @fill . color(r))
		
	)
	
	if(@align == '', @align = 0)
	
	switch(@align,
		0,
			if(@sep,
				return(array(@color . @string . @fills[0] . @color, @color . @string, @fills[0] . @color, '', @left)),
				return(@color . @string . @fills[0] . @color)
			),
		1,
			if(@sep,
				return(array(@fills[0] . @color . @string, @color . @string, @fills[0], '', @left)),
				return(@fills[0] . @color . @string . @color)
			),
		2,
			if(@sep,
				return(array(@fills[0] . @color . @string . @fills[1] . @color, @color . @string, @fills[0], @fills[1], @left)),
				return(@fills[0] . @color . @string . @fills[1] . @color)
			)
	)

)
	

#returns the location(s) in the string that will cause a wordwrap
proc(_adv_string_wrap, @string, @offset,

	if(!is_integer(@offset), @offset = 0)

	@linewidth = 320 - @offset #the total width on one line is 320
	
	@max_wordlength = 15 #if a word has more characters than this number, it cuts to the next line.
	
	@chars = _adv_char_array(@string)
	
	@widths = _adv_char_widths()
	
	@totalwidth = 0
	@wraplocs = array()
	
	foreach(@chars, @i, @char,
	
		@width = _adv_char_widths(@char)
		
		@totalwidth += @width
		
		@lines = floor(@totalwidth / @linewidth)
		
		@key = @lines - 1
		
		if(!array_index_exists(@wraplocs, @key) && @key > -1,

			@temp = @i
			
			while(true,
				if(@chars[@temp] == ' ', #if the wrap location is a space
					@wraplocs[@key] = @temp #allow it to be added to the array
					break(),
					if(@i - @temp > @max_wordlength, #limits how far back in the string to check for spaces
						@wraplocs[@key] = @i #if it goes past the max wordlength, just give up and push the original position
						break(),
						@temp -= 1
					)
				)
			)
		)
	)

	return(@wraplocs)
	
)
		

#returns the total width of the string
proc(_adv_string_width, @string,

	@array = _adv_char_array(@string)
	@width = 0
	
	@colorcode = false

	foreach(@array, @i, @c,
	
		if(@c == '\u00a7' && reg_match('[0-9a-fA-Fk-or]', 
			@array[@i + 1]) != array(), 
			@colorcode = true 
			continue()
		)
		
		if(@colorcode == false, 
			if(array_contains(_adv_string_formats(@string, @i), 'l'),
				@width += _adv_char_widths(@c) + 1,
				@width += _adv_char_widths(@c)
			)
		)
		
		@colorcode = false
	)	
		
	return(@width)
)

#cuts off part of the string so its width is of @max or less, then returns
proc(_adv_string_cut, @string, @max, @wordwrap,

	@format = _adv_string_formats(@string, length(@string), true)

	@end = length(@string)
	
	@left = ''

	while(_adv_string_width(@string) > @max,

		if(strip_colors(@string[cslice(-2, -1)]) == '', @end -= 3, @end -= 1)
		
		@left = substr(@string, @end) . @left
	
		@string = substr(@string, 0, @end) #cuts one character from the end of the string
		
	)
		
		
	
	return(array(@format . @string, @format . @left))
	
)
proc(_adv_string_ins, @string, @insertarray,

	@order = array()
	
	@max = 0

	foreach(array_keys(@insertarray), @pos,
		if(@pos > @max,
			array_push(@order, @pos)
			@max = @pos,
			array_insert(@order, @pos, 0)
		)
	)
	
	@slices = array()
	
	@last = 0
	
	foreach(@order, @pos,
		
		array_push(@slices, substr(@string, @last, @pos) . @insertarray[@pos])
		
		@last = @pos
		
	)		
	
	@return = ''

	foreach(@slices, @slice, @return .= @slice)
	
	return(@return . substr(@string, @last))
	
)

#======================================================================================================#
#	Misc Funcitons
#======================================================================================================#

proc(_adv_pos, @player, @array,

	try(@player = player(@player), @player = player())

	if(@array === '',
		@loc = ploc(@player)
		@ang = pfacing(@player)
		return(array(@loc[0], @loc[1], @loc[2], @ang[0], @ang[1], @loc[3])),
		switch(array_size(@array),
			3,
				foreach(@array, @n, if(!is_numeric(@n), return(false)))
				set_ploc(@player, array(@array[0], @array[1], @array[2], pworld(@player)))
				return(true),
			4,
				foreach(@array, @n, if(!is_numeric(@n), return(false)))
				set_ploc(@player, array(@array[0], @array[1], @array[2], pworld(@player)))
				pfacing(@player, @array[3], 0)
				return(true),
			5,
				foreach(@array, @n, if(!is_numeric(@n), return(false)))
				set_ploc(@player, array(@array[0], @array[1], @array[2], pworld(@player)))
				pfacing(@player, @array[3], @array[4])
				return(true),
			6,
				foreach(@array[cslice(0,4)], @n, if(!is_numeric(@n), return(false)))
				set_ploc(@player, array(@array[0], @array[1], @array[2], pworld(@player)))
				pfacing(@player, @array[3], @array[4])
				return(true),		
				return(false)
		)
	)
	
)

proc(_world_players,

	@worlds = array()
	
	foreach(get_worlds(), @world,
		@worlds[@world] = array()
	)

	foreach(all_players(), @player,
		if(!array_index_exists(@worlds, pworld(@player)),
			@worlds[pworld(@player)] = array()
		)
	
		array_push(@worlds[pworld(@player)], @player)
		
	)
	
	return(@worlds)
	
)

proc(_writeUTF, @ba, @str,
        @len = length(@str)
        if (@len > 200) {
            die('String too long')
        }
        ba_put_byte(@ba, 0)
        ba_put_byte(@ba, @len)
        ba_put_bytes(@ba, string_get_bytes(@str, 'ascii'))
)
 
proc(_changeserver, @player, @server,
       @ba = byte_array()
       _writeUTF(@ba, 'Connect')
       _writeUTF(@ba, @server)
	   unbind('pq-'.@player)
	   bind(player_quit, array(priority: highest, id: 'pq-'.@player), array(player: @player), @event, @server,
			modify_event(message, null)
			#_bdc('^7' . player() . '^6 has entered ^7' . @server . '.')
			_bdc('^7' . player() . '^6 has entered another world.')
			unbind('pq-'.@event['player'])
			consume()
       )
	   
       send_plugin_message(@player, 'BungeeCord', @ba)
)

proc(_bungee_wait, @player, @server,

	play_sound(ploc(@player), array(pitch:2, sound:NOTE_PLING), @player)
	
	_ocp_msg(@player, '^7Don\'t move! ^6You will be sent to ^7' . @server . '^6 in 2 seconds.', true)
	
	@loc = ploc(@player)
	
	set_timeout(1000,
		closure(
			if(_vec_dist(@loc, ploc(@player)) < 2,
				@loc = ploc(@player) 
				play_sound(ploc(@player), array(pitch:1, sound:NOTE_PLING), @player)
				set_timeout(1000,
					closure(
						if(_vec_dist(@loc, ploc(@player)) < 2,
							@loc = ploc(@player)
							play_sound(ploc(@player), array(pitch:0, sound:NOTE_PLING), @player)		
							_changeserver(@player, @server)
							set_timeout(500,
								closure(
									if(ponline(@player),
										firework_effect(array(colors:RED, fade:BLACK), _vec_add(@loc, array(0,1,0))),
										firework_effect(array(colors:PURPLE, fade:BLUE), _vec_add(@loc, array(0,1,0)))
									)
								)
							),
							
							_ocp_msg(@player, '^6Request cancelled.')
						)
					)
				),
				
				_ocp_msg(@player, '^6Request cancelled.')
			)
		)
	)
	
)


proc(_sk_getplayers, @region,

	@players = array()

	foreach(all_players(), @player,
	
		if(array_contains(sk_current_regions(@player), @region),
		
			array_push(@players, @player)
			
		)
		
	)
	
	return(@players)

)
		
		

proc(_world_getplayers, @world,
	
	@worlds = get_worlds()
	
	if(!array_contains(@worlds, @world), return(ERROR_WORLD_NOT_EXIST))
	
	@players = array()
	
	foreach(all_players(), @player,
	  
		if(pworld(@player) == @world,
			array_push(@players, @player)
		)
		
	)
	
		return(@players)
	
)


proc(_array_ceilindexes, @array,

	foreach(@array, @index, @value,
	
		if(is_numeric(@value), @array[@index] = ceil(@array[@index]))
		
	)
	
	return(@array)
	
)

proc(_locFloor, @ploc, @add,

	if(@add == '', @add = array(0,1,0))

	@ploc[0] = floor(@ploc[0]) + @add[0]
	@ploc[1] = floor(@ploc[1]) + @add[1]
	@ploc[2] = floor(@ploc[2]) + @add[2]
	
	return(@ploc)
	
)

proc(_array_round, @array,

	foreach(@array, @index, @value,
	
		if(is_numeric(@value), @array[@index] = round(@array[@index]))
		
	)
	
	return(@array)
	
)

proc(_array_combine, @a1, @a2,

	@array = array()
	
	foreach(@a1, @i, @v,
		if(array_index_exists(@a2, @i) && is_numeric(@v) && is_numeric(@a2[@i]),
			@array[@i] = @v + @a2[@i]
		)
	)
	
	return(@array)
	
)

proc(_array_floor, @array,

	foreach(@array, @index, @value,
	
		if(is_numeric(@value), @array[@index] = floor(@array[@index]))
		
	)
	
	return(@array)
	
)

proc(_array_multindexes, @array, @x,

	foreach(@array, @index, @value,
	
		if(is_numeric(@value), @array[@index] = multiply(@array[@index], @x))
		
	)
	
	return(@array)
	
)

proc(_array_neg, @array,

	foreach(@array, @key, @value,
		if(is_numeric(@value), @array[@key] = neg(@value))
	)
	
	return(@array)
	
)

proc(_array_addindexes, @array, @x,

	foreach(@array, @index, @value,
	
		if(is_numeric(@value), @array[@index] = add(@array[@index], @x))
		
	)
	
	return(@array)
	
)

proc(_vec_add, @vec1, @vec2,

	@vec1[0] = @vec1[0] + @vec2[0]
	@vec1[1] = @vec1[1] + @vec2[1]
	@vec1[2] = @vec1[2] + @vec2[2]
	
	return(@vec1)
	
)

proc(_vec_dist, @loc1, @loc2,

	@x = pow((@loc1[0] - @loc2[0]), 2)
	@y = pow((@loc1[1] - @loc2[1]), 2)
	@z = pow((@loc1[2] - @loc2[2]), 2)
	
	@dist = sqrt(@x + @y + @z)
	
	return(@dist)
	
)

proc(_math_average_loc, @locarray,

	@x = 0
	@y = 0
	@z = 0
	
	foreach(@locarray, @loc,
	
		@x = @x + @loc[0]
		@y = @y + @loc[1]
		@z = @z + @loc[2]
		
	)
	
	@x = round(@x / array_size(@locarray))
	@y = round(@y / array_size(@locarray))
	@z = round(@z / array_size(@locarray))
	
	return(array(@x, @y, @z))
	
)

proc(_math_closest, @x, @numberarray,

	@diff = max(@x, @numberarray[0]) - min(@x, @numberarray[0])
	@closest = @numberarray[0]
	
	foreach(@numberarray, @n,
		
		if((max(@x, @n) - min(@x, @n)) < @diff,
		
			@diff = max(@x, @n) - min(@x, @n)
			@closest = @n
			
		)
		
	)
	
	return(@closest)
	
)

proc(_eyes, @player,

	if(@player == '', @player = player())
	
	@loc = ploc(@player)
	@loc[1] = @loc[1] + 2.620
	
	return(@loc)
	
)

proc(_feet, @player,

	if(@player == '', @player = player())
	
	@loc = ploc(@player)
	@loc[1] = @loc[1] + 1
	
	return(@loc)
	
)

proc(_time_empty,

	return(array(yr:0, mt:0, dy:0, hr:0, mn:0, sc:0))
	
)

proc(_time_get,

	@time = parse_args(simple_date('YYYY MM dd HH mm ss'))
	
	@year = @time[0]
	@month = @time[1]
	@day = @time[2]
	@hour = @time[3]
	@minute = @time[4]
	@second = @time[5]
	
	return(array(yr:@year, mt:@month, dy:@day, hr:@hour, mn:@minute, sc:@second))
	
)

proc(_time_add, @time, @offset,

)
		
proc(_time_gte, @time1, @time2,

	if(@time2[yr] < @time1[yr], return(true))
	if(@time2[mt] < @time1[mt], return(true))
	if(@time2[dy] < @time1[dy], return(true))
	if(@time2[hr] < @time1[hr], return(true))
	if(@time2[mn] < @time1[mn], return(true))
	if(@time2[sc] < @time1[sc], return(true))
	
	return(false)

)
/*
proc(_time_diff, @from, @to,

	@time = array()
	
	@time[yr] = @from[yr] - @to[yr]
	@time[mt] = @from[mt] - @to[mt]
	@time[dy] = @from[dy] - @to[dy]
	@time[hr] = @from[hr] - @to[hr]
	@time[mn] = @from[mn] - @to[mn]
	@time[sc] = @from[sc] - @to[sc]

	return(@time)
	
)
*/
proc(_time_lit, @time,

	switch(@time[mt],
	
		01, @time[mt] = 'January',
		02, @time[mt] = 'February',
		03, @time[mt] = 'March',
		04, @time[mt] = 'April',
		05, @time[mt] = 'May',
		06, @time[mt] = 'June',
		07, @time[mt] = 'July',
		08, @time[mt] = 'August',
		09, @time[mt] = 'September',
		10, @time[mt] = 'October',
		11, @time[mt] = 'November',
		12, @time[mt] = 'December',
			@time[mt] = 'ERROR',
			
	)
	
	return(@time)
	
)

proc(_time_string, @time,

	@string = array()

	foreach(array(yr, mt, dy, hr, mn, sc), @i,
	
		switch(@i,
			yr,
				@s = 'year'
				@p = 'years',
			mt,
				@s = 'month'
				@p = 'months',
			dy,
				@s = 'day'
				@p = 'days',
			hr,
				@s = 'hour'
				@p = 'hours',
			mn,
				@s = 'minute'
				@p = 'minutes',
			sc,
				@s = 'second'
				@p = 'seconds'
		)
	
		if(@time[@i] >= 1,
			if(@time[@i] == 1,
				array_push(@string, @time[@i] . ' ' . @s),
				array_push(@string, @time[@i] . ' ' . @p)
			)
		)
	)
	
	@string = array_implode(@string, ', ')
	
	return(@string)
	
)

proc(_gPrefix, @group,

	try(
		return(yml_decode(read('../../../PermissionsEx/permissions.yml'))[groups][@group][prefix]),
		return('&f')
	)

)

proc(_gSuffix, @group,

	try(
		return(yml_decode(read('../../../PermissionsEx/permissions.yml'))[groups][@group][suffix]),
		return('&f')
	)

)

proc(_gDefault,

	try(
		@groups = yml_decode(read('../../../PermissionsEx/permissions.yml'))[groups]
		foreach(@groups, @group,
			if(array_index_exists(@group, default) && @group[default] == true,
				return(array_index(@groups, @group))
			)
		),
		return('default')
	)

)

proc(_pGroup, @player,

	try(
		return(pgroup(@player)[0]),
		return(_gDefault())
	)

)

proc(_stop, cancel() consume() die())

@mod_includes = import('ocp.mod.includes')
if(is_array(@mod_includes), foreach(@mod_includes, @path, include(@path)))


	
	
	
	
	