	
@fonts = split('\n', trim(shell('ls plugins/CommandHelper/LocalPackages/BlockText/fonts/')))

@font_map = read('fonts/MikronF/map.txt')

@font_con = yml_decode(read('fonts/MikronF/config.yml'))

@height = @font_con[h]

@find = true
@ref = 0
@end = @ref + @height

@font = array()

foreach(split('\n', @font_map), @i, @line,

	if(@find == true, 
		if(@line == '', continue(),
			@ref = @i
			@end = @ref + @height
			@find = false
			@character = @line
			@h = @height - 1
			@char = array()
			continue()
		)
	)
	
	@pattern = split('', @line)
	
	foreach(@pattern, @w, @c, 
		if(@c == '#', @char[] = array(@w, @h))
	)
	
	@h--

	if(@i == @end || @line == '', 
		@find = true
		@font[@character] = @char
	)
	
)

export('text.map', @font)
export('text.con', @font_con)

@pos = array(-100, 10, 26, world)
@s_pos = @pos[]

export('text.scroll', @s_pos)

set_interval(1000,
	closure(
	
		@s_pos = import('text.scroll')

		_ttw(@s_pos, '  penis  ')

		if(@s_pos[0] < @pos[0] + 80, @s_pos[0] += 1, @s_pos[0] = @pos[0])
		
		export('text.scroll', @s_pos)
		
	)
) 
	