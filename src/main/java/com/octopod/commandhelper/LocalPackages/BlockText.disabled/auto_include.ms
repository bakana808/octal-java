proc(_ttw, @vpos, @string,

	@pos = @vpos[]

	@map = import('text.map')
	@con = import('text.con')

	@characters = split('', @string)
	
	@h = @con[h]
	
	@z = @pos[2]
	@world = @pos[3]
	
	foreach(@characters, @c,
	
		try(@w = @con[or][@c][w], @w = @con[w])
	
		try(@locs = @map[@c], @locs = @map[unknown])

		for(@x = 0, @x < @w + 1, @x++,
			for(@y = 0, @y < @h, @y++,
				if(array_contains(@locs, array(@x, @y)),
					execute(closure(set_block_at(array(@x + @pos[0], @y + @pos[1], @z, @world), '155:0'))),
					execute(closure(set_block_at(array(@x + @pos[0], @y + @pos[1], @z, @world), '112:0')))
				)
			)
		)
		
		@pos[0] += @w + 1
		
	)
	
)