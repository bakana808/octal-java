
#======================================================================================================#
#	Advanced String Functions
#======================================================================================================#

#finds the applied formats to a position in a string
proc(_string_colors, @string, @pos, @colorize,

	@formats = array()
	
	@colors = reg_match_all('\u00a7[0-9a-fA-Fk-or]', substr(@string, 0, @pos))

	foreach(@colors, @color,
	
		@code = substr(@color[0], 1)
		
		if(@code == 'r', @formats = array())
		
		if(reg_match('[0-9a-fA-Fk-o]', @code) != array(), array_remove_values(@formats, 'l'))
		
		array_push(@formats, @code)	
		
	)
	
	if(@colorize,
		foreach(@formats, @format,
			@premade .= color(@format)
		)
		return(@premade),
		return(@formats)
	)
	
)

#fills the rest of the string with filler characters until the width of it is of @towidth
#use @align: 0 = left alignment, 1 = right alignment, 2 = center alignment
#use sep to return an array with the string and the generated filler character string
 
proc(_text, @string, @towidth, @align, @sep,

	@string = colorize(@string)

	@filler_color = color(8)

	if(!is_integer(@align), @align = 0)

	@array = _truncate(@string, @towidth, @wordwrap)
	
	@string = @array[0]
	@left = @array[1]

	@extra = @towidth - _string_width(@string)

	if(@align == 2,
		@extra1 = @extra / 2
		@extra2 = @extra / 2
		if(!is_integer(@extra1),
			@extra1 += 0.5 
			@extra2 -= 0.5
		)
		if(mod(integer(@extra1), 2) != 0 && @extra1 == 1,
			@extra1 -= 1
			@extra2 += 1
		)
		@extra = array(integer(@extra1), integer(@extra2)),
		@extra = array(@extra)
	)
	
	@fills = array()

	foreach(@extra, @e,
	
		@res = res_create_resource('STRING_BUILDER')
		
		while(@e > 5,
			string_append(@res,  ' ')
			@e -= 4
		)

		switch(@e,
			5,
				string_append(@res,  color(l) . ' '),
			4,
				string_append(@res,  ' '),
			3, 
				string_append(@res,  @filler_color . color(l) . '`'),
			2,
				string_append(@res,  @filler_color . '`')
		)
		
		@fill = string(@res)
		res_free_resource(@res)
		
		@fills[] = color(r) . @fill . color(r)
		
	)
	
	if(@align == '', @align = 0)
	
	switch(@align,
		0,
			if(@sep,
				return(array(@string . @fills[0], @string, @fills[0], '', @left)),
				return(@string . @fills[0])
			),
		1,
			if(@sep,
				return(array(@fills[0] . @string, @string, @fills[0], '', @left)),
				return(@fills[0] . @string)
			),
		2,
			if(@sep,
				return(array(@fills[0] . @string . @fills[1], @string, @fills[0], @fills[1], @left)),
				return(@fills[0] . @string . @fills[1])
			)
	)

)
	

#returns the location(s) in the string that will cause a wordwrap (override the default width of 320 with @towidth)
proc(_wordwraps, @string, @towidth,

	if(is_integer(@towidth),
		@linewidth = @towidth,
		@linewidth = 320 #the total width on one line is 320
	)

	@max_wordlength = 15 #if a word has more characters than this number, it cuts to the next line.
	
	@chars = split('', @string)
	
	@widths = _char_width()
	
	@totalwidth = 0
	@wraplocs = array()
	
	foreach(@chars, @i, @char,
	
		@width = _char_width(@char)
		
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
		

#returns the total pixel width of the string
proc(_string_width, @string,

	@array = split('', @string)
	@width = 0
	
	@colorcode = false

	foreach(@array, @i, @c,
	
		try(@match = reg_match('[0-9a-fA-Fk-or]', @array[@i + 1]), @match = array())

		if(@c == '\u00a7' && @match != array(), 
			@colorcode = true 
			continue()
		)

		if(@colorcode == false, 
			if(array_contains(_string_colors(@string, @i), 'l'),
				@width += _char_width(@c) + 1,
				@width += _char_width(@c)
			)
		)
		
		@colorcode = false
	)	
		
	return(@width)
)

#cuts off part of the string so its width is of @max or less, then returns an array containing the section cut out, and the rest of the string.
#if @wordwrap is true, try to look for nearby spaces instead of cutting in the middle of words
proc(_truncate, @string, @max, @wordwrap,

	@maxwordlength = 15
	@temp = @string

	@format = _string_colors(@string, length(@string), true)

	@end = length(@string)

	@width = _string_width(@string)

	while(@width > @max,

		if(strip_colors(@string[cslice(-2, -1)]) == '', @end -= 3, @end -= 1)
		
		@left = substr(@string, @end) . @left

		@string = substr(@string, 0, @end) #cuts one character from the end of the string
		
		@width = _string_width(@string)
		
		if(@width <= @max && @wordwrap,
			
			@loops = 0

			while(@string[@end - 1] != ' ',
			
				@end -= 1

				@temp = substr(@string, 0, @end)

				if(@loops > @maxwordlength,
					
					break(),
					
				)
				
				try(@string[@end - 1], break())
				
				@loops++
				
				if(@string[@end - 1] == ' ',
				
					@left = substr(@string, @end) . @left
					
					@string = @temp

					break()
						
				)
			)
		)
	)
	
	return(array(@format . @string, @format . @left))
	
)
