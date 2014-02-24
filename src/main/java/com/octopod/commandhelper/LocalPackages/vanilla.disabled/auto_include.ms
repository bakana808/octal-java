proc(_rand_spawn, @world_border, 
	
	@partial = floor(@world_border * 0.5)
	@x = rand(0 - @partial, @partial)
	@z = rand(0 - @partial, @partial)
	@y = 256
	
	for(@y, @y > 0, @y--,
	
			@type = split(':', get_block_at(@x, @y, @z, world))[0]
			@1 = split(':', get_block_at(@x, @y + 1, @z, world))[0]
			@2 = split(':', get_block_at(@x, @y + 2, @z, world))[0]
		
		if(@type == 8 || @type == 9, 
			@x = rand(0 - @partial, @partial)
			@z = rand(0 - @partial, @partial)
			@y = 256
			
			@type = split(':', get_block_at(@x, @y, @z, world))[0]
			@1 = split(':', get_block_at(@x, @y + 1, @z, world))[0]
			@2 = split(':', get_block_at(@x, @y + 2, @z, world))[0]
		)
	
		if(@type != 0 && @1 == 0 && @2 == 0,
			break(),
		)
	)

	return(array(@x + 0.5, @y, @z + 0.5, world))
	
)

/randtp $player = >>>

	if(!ponline($player), die())
	
	@world = pworld($player)

	@loc = ploc($player)

	@x = array_rand(rand(@loc[0] - @min_dist, 0 - @max_dist), rand(@loc[0] + @min_dist, @max_dist), 1, false)[0]
	@z = array_rand(rand(@loc[1] - @min_dist, 0 - @max_dist), rand(@loc[1] + @min_dist, @max_dist), 1, false)[0]
	@y = 256
	
	for(@y, @y > 0, @y--,
	
			@type = split(':', get_block_at(@x, @y, @z, @world))[0]
			@1 = split(':', get_block_at(@x, @y + 1, @z, @world))[0]
			@2 = split(':', get_block_at(@x, @y + 2, @z, @world))[0]
		
		if(@type == 8 || @type == 9, 
			@x = array_rand(rand(@loc[0] - @min_dist, 0 - @max_dist), rand(@loc[0] + @min_dist, @max_dist), 1, false)[0]
			@z = array_rand(rand(@loc[1] - @min_dist, 0 - @max_dist), rand(@loc[1] + @min_dist, @max_dist), 1, false)[0]
			@y = 256
			
			@type = split(':', get_block_at(@x, @y, @z, @world))[0]
			@1 = split(':', get_block_at(@x, @y + 1, @z, @world))[0]
			@2 = split(':', get_block_at(@x, @y + 2, @z, @world))[0]
		)
	
		if(@type != 0 && @1 == 0 && @2 == 0,
			break(),
		)
	)

	set_ploc($player, array(@x + 0.5, @y, @z + 0.5, @world))
	
<<<