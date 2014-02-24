#turns a roomID into a string used for keys in an array.
proc(_room_toKey, @roomID, return(@roomID[0] . ':' . @roomID[1]))

#turns a roomID key into an array.
proc(_room_toID, @roomIDKey, 
	@split = split(':', @roomIDKey)
	return(array(@split[0], @split[1]))
)

#returns the center of the room in the world from an ID.
proc(_room_toWorldCenter, @roomID, return(array(@roomID[0] * 32, 66, @roomID[1] * -32, world)))

#returns whether the the room is safe or not. (meaning no mobs will spawn in it)
proc(_room_isSafe, @roomID, if(array_contains(import('roomCleared'), @roomID), return(true), return(false)))
#makes a room safe.
proc(_room_makeSafe, @roomID, import('roomCleared')[] = @roomID)


#returns the room type of the roomID
proc(_room_getRoomType, @roomID, try(return(import('roomSpecials')[@roomID[0] . ':' . @roomID[1]]), return(0)))

#returns the material for the type (this will be the outline of the doorways)
proc(_room_getRoomTypeMaterial, @type,
	switch(@type,
		2, return(41), #Chest Room
		3, return(49), #Boss Room
		   return('43:8') #Default
	)
	
)

#returns an array of blank adjacent rooms to the roomID
proc(_room_getEmptyAdjecentRooms, @layout, @roomID,

	if(@roomID == '', @roomID = @layout
		@layout = import('roomLayout')
	)
	
	@free = array()

	if(!array_contains(@layout, _vec2_add(@roomID, array(1,0))), @free[] = array(1,0))
	if(!array_contains(@layout, _vec2_add(@roomID, array(-1,0))), @free[] = array(-1,0))
	if(!array_contains(@layout, _vec2_add(@roomID, array(0,1))), @free[] = array(0,1))
	if(!array_contains(@layout, _vec2_add(@roomID, array(0,-1))), @free[] = array(0,-1))
	
	return(@free)
	
)

#returns an array of adjacent rooms to the roomID
proc(_room_getAdjacentRooms, @layout, @roomID,

	if(@roomID == '', @roomID = @layout
		@layout = import('roomLayout')
	)
	
	@full = array()

	if(array_contains(@layout, _vec2_add(@roomID, array(1,0))), @full[] = array(1,0))
	if(array_contains(@layout, _vec2_add(@roomID, array(0,-1))), @full[] = array(0,-1))
	if(array_contains(@layout, _vec2_add(@roomID, array(-1,0))), @full[] = array(-1,0))
	if(array_contains(@layout, _vec2_add(@roomID, array(0,1))), @full[] = array(0,1))
	
	return(@full)
	
)

#=====================================================================================================#
#	ROOM LOADERS
#=====================================================================================================#

proc(_room_lockRoom, @roomID,

	@center = array(@roomID[0] * 32, 66, @roomID[1] * -32, world)
	@roomLayout = import('roomLayout')

	if(!is_array(@roomLayout), return(false))

	@adjacent = _room_getAdjacentRooms(@roomLayout, @roomID)	
	@type = _room_getRoomType(@roomID)
		
	@wall = array()
	@air = array()

	@iterate = _iterate(_vec_add(@center, array(14, 0, 1)), _vec_add(@center, array(14, 2, -1)))
	if(array_contains(@adjacent, array(1,0)), foreach(@iterate, @loc, @air[] = @loc))

	@iterate = _iterate(_vec_add(@center, array(-14, 0, 1)), _vec_add(@center, array(-14, 2, -1)))
	if(array_contains(@adjacent, array(-1,0)), foreach(@iterate, @loc, @air[] = @loc))
	
	@iterate = _iterate(_vec_add(@center, array(1, 0, 14)), _vec_add(@center, array(-1, 2, 14)))
	if(array_contains(@adjacent, array(0,-1)), foreach(@iterate, @loc, @air[] = @loc))

	@iterate = _iterate(_vec_add(@center, array(1, 0, -14)), _vec_add(@center, array(-1, 2, -14)))
	if(array_contains(@adjacent, array(0,1)), foreach(@iterate, @loc, @air[] = @loc))
	
	play_sound(@center, array(sound:ZOMBIE_METAL))

	foreach(@air, @loc, @loc[3] = 'world' execute(closure(set_block_at(@loc, '101'))))
	
)

proc(_room_unlockRoom, @roomID, @clear,

	@center = array(@roomID[0] * 32, 66, @roomID[1] * -32, world)
	@roomLayout = import('roomLayout')
	
	if(@clear,
		@cleared = import('roomCleared')
		@cleared[] = @roomID
		export('roomCleared', @cleared)
	)

	if(!is_array(@roomLayout), return(false))

	@adjacent = _room_getAdjacentRooms(@roomLayout, @roomID)	
	@type = _room_getRoomType(@roomID)
		
	@wall = array()
	@air = array()

	@iterate = _iterate(_vec_add(@center, array(14, 0, 1)), _vec_add(@center, array(14, 2, -1)))
	if(array_contains(@adjacent, array(1,0)), foreach(@iterate, @loc, @air[] = @loc))

	@iterate = _iterate(_vec_add(@center, array(-14, 0, 1)), _vec_add(@center, array(-14, 2, -1)))
	if(array_contains(@adjacent, array(-1,0)), foreach(@iterate, @loc, @air[] = @loc))
	
	@iterate = _iterate(_vec_add(@center, array(1, 0, 14)), _vec_add(@center, array(-1, 2, 14)))
	if(array_contains(@adjacent, array(0,-1)), foreach(@iterate, @loc, @air[] = @loc))

	@iterate = _iterate(_vec_add(@center, array(1, 0, -14)), _vec_add(@center, array(-1, 2, -14)))
	if(array_contains(@adjacent, array(0,1)), foreach(@iterate, @loc, @air[] = @loc))
	
	play_sound(@center, array(sound:ZOMBIE_METAL))

	foreach(@air, @loc, @loc[3] = 'world' execute(closure(set_block_at(@loc, '0'))))
	
)

proc(_room_loadNear, @roomID,

	queue_push(closure( _room_loadRoom(@roomID) ))
	queue_push(closure( _room_loadRoom(_vec2_add(@roomID, array(1,0))) ))
	queue_push(closure( _room_loadRoom(_vec2_add(@roomID, array(-1,0))) ))
	queue_push(closure( _room_loadRoom(_vec2_add(@roomID, array(0,1))) ))
	queue_push(closure( _room_loadRoom(_vec2_add(@roomID, array(0,-1))) ))
	
)

proc(_room_loadRoom, @roomID,

	@type = _room_getRoomType(@roomID)
	@roomLayout = import('roomLayout')
	@roomLoaded = import('roomLoaded')
	
	if(!is_array(@roomLoaded), @roomLoaded = array())
	
	if(array_contains(@roomLoaded, @roomID), return(false))
	
	@center = _room_toWorldCenter(@roomID)
	
	make_effect(@center, 'RECORD_PLAY:2258')
	
	if(!array_contains(@roomLayout, @roomID),
	
		#===[Load Blank Room]===========================================================#
	
		@iterate = _iterate( 
						_vec_add(array(@center[0], 0, @center[2]), array(-19, 72, -19)), 
						_vec_add(array(@center[0], 0, @center[2]), array(19, 62, 19))
					)
					
		foreach(@iterate, @loc, execute(closure(set_block_at(@loc, 0)))),
		
		#===[Load Random Room]===========================================================#
	
		switch(@type,
			1,
				@layout = 'layout_spawn',
				@layout = array_rand(array('layout0', 'layout1', 'layout2'), 1, false)[0]
		)

		skcb_load(@layout)
		skcb_paste(@center)

		if(!is_array(@roomLayout), return(false))

		@adjacent = _room_getAdjacentRooms(@roomLayout, @roomID)	
		@type = _room_getRoomType(@roomID)
			
		@wall = array()
		@air = array()
		
		@mat = _room_getRoomTypeMaterial(_room_getRoomType(_vec2_add(@roomID, array(1,0))))
		foreach(_iterate(_vec_add(@center, array(14, 0, 2)), _vec_add(@center, array(14, 3, -2))), @loc,
			@loc[3] = 'world'
			set_block_at(@loc, @mat)
		)	
		
		@iterate = _iterate(_vec_add(@center, array(14, 0, 1)), _vec_add(@center, array(14, 2, -1)))
		if(array_contains(@adjacent, array(1,0)),
			foreach(@iterate, @loc, @air[] = @loc),
			foreach(@iterate, @loc, @wall[] = @loc)
		)
		
		@mat = _room_getRoomTypeMaterial(_room_getRoomType(_vec2_add(@roomID, array(-1,0))))
		foreach(_iterate(_vec_add(@center, array(-14, 0, 2)), _vec_add(@center, array(-14, 3, -2))), @loc,
			@loc[3] = 'world'
			set_block_at(@loc, @mat)
		)	
			
		@iterate = _iterate(_vec_add(@center, array(-14, 0, 1)), _vec_add(@center, array(-14, 2, -1)))
		if(array_contains(@adjacent, array(-1,0)),
			foreach(@iterate, @loc, @air[] = @loc),
			foreach(@iterate, @loc, @wall[] = @loc)
		)
		
		@mat = _room_getRoomTypeMaterial(_room_getRoomType(_vec2_add(@roomID, array(0,-1))))
		foreach(_iterate(_vec_add(@center, array(2, 0, 14)), _vec_add(@center, array(-2, 3, 14))), @loc, 
			@loc[3] = 'world'
			set_block_at(@loc, @mat)
		)	

		@iterate = _iterate(_vec_add(@center, array(1, 0, 14)), _vec_add(@center, array(-1, 2, 14)))
		if(array_contains(@adjacent, array(0,-1)),
			foreach(@iterate, @loc, @air[] = @loc),
			foreach(@iterate, @loc, @wall[] = @loc)
		)
		
		@mat = _room_getRoomTypeMaterial(_room_getRoomType(_vec2_add(@roomID, array(0,1))))
		foreach(_iterate(_vec_add(@center, array(2, 0, -14)), _vec_add(@center, array(-2, 3, -14))), @loc,
			@loc[3] = 'world'
			set_block_at(@loc, @mat)
		)	

		@iterate = _iterate(_vec_add(@center, array(1, 0, -14)), _vec_add(@center, array(-1, 2, -14)))
		if(array_contains(@adjacent, array(0,1)),
			foreach(@iterate, @loc, @air[] = @loc),
			foreach(@iterate, @loc, @wall[] = @loc)
		)
		
		foreach(@wall, @loc, @loc[3] = 'world' execute(closure(set_block_at(@loc, '98'))))
		
		if(@locked,
			foreach(@air, @loc, @loc[3] = 'world' execute(closure(set_block_at(@loc, '101')))),
			foreach(@air, @loc, @loc[3] = 'world' execute(closure(set_block_at(@loc, '0'))))
		)
		
		if(@type == 2,
			set_block_at(array(@center[0], 4, @center[2], 'world'), 54),
			set_block_at(array(@center[0], 4, @center[2], 'world'), 0)
		)
		
	)
	
	#Add room to loaded rooms array
	@roomLoaded[] = @roomID
	export('roomLoaded', @roomLoaded)
	
	return(true)

)

#=====================================================================================================#
#	DUNGEON GENERATOR
#=====================================================================================================#

proc(_room_generateLayout, @rooms, @chestRooms, @bossRooms, @shopRooms,

	if(!is_numeric(@rooms), @rooms = 15)
	if(!is_numeric(@chestRooms), @chestRooms = 2)
	if(!is_numeric(@bossRooms), @bossRooms = 1)
	if(!is_numeric(@shopRooms), @shopRooms = 1)
	
	@playerLocs = associative_array()
	@distances = associative_array('0:0': 0)
	@specialRooms = associative_array('0:0': 1)
	@layout = array(array(0,0))
	@cleared = array(array(0,0))
	
	console(color(6) . 'STARTING NEW DUNGEON GENERATION!!', false)

	console('Generating Rooms...', false)

	foreach(range(0, @rooms), @room,
		
		console(' - Making room ' . (@room + 1) . '...', false)
			
		@tempLayout = @layout[]

		while(true,
		
			if(array_size(@tempLayout) == 0, console('Found no suitable rooms!', false) break(2))

			@sel = array_rand(@tempLayout, 1, false)[0]
			
			array_remove_values(@tempLayout, @sel)

			if(array_size(@free = _room_getEmptyAdjecentRooms(@layout, @sel)) == 0, console(color(c) . '    - SKIP: No empty adjecent spots!', false) continue())

			while(array_size(@free) > 0,

				@picked = array_rand(@free, 1, false)[0]
				
				array_remove_values(@free, @picked)
				
				@temp = _vec2_add(@sel, @picked)[]

				if(abs(@temp[1]) > 1, continue())
				if(array_size(_room_getAdjacentRooms(@layout, @temp)) <= 1, break(2))
				
			)

		)

		@sel = @temp

		@layout[] = @sel
		
	)
	
	#=====[GENERATING CHEST ROOMS]=====#
		
	console('Generating Chest Rooms...', false)

	foreach(range(0, @chestRooms), @room,
	
		console(' - Making room ' . (@room + 1) . '...', false)
			
		@tempLayout = @layout[]
		
		@generateNewRoom = false

		while(array_size(@tempLayout) > 0,

			@sel = array_rand(@tempLayout, 1, false)[0] array_remove_values(@tempLayout, @sel)

			if(array_index_exists(@specialRooms, @sel[0].':'.@sel[1]), console(color(c) . '    - CONT: This is a special room!', false) continue())
	
			if(array_size(@free = _room_getEmptyAdjecentRooms(@layout, @sel)) == 0, console(color(c) . ' - CONT: No empty adjecent spots!', false) continue())

			if(array_size(_room_getAdjacentRooms(@layout, @sel)) == 1, break())
		
			if(array_size(@tempLayout) == 0, 
				console('    - Found no suitable rooms! Creating a new room.', false) 
				@generateNewRoom = true
			)
			
			while(@generateNewRoom == true && array_size(@free) > 0,

				@picked = array_rand(@free, 1, false)[0]
				
				array_remove_values(@free, @picked)
				
				@temp = _vec2_add(@sel, @picked)[]
				
				@sel = @temp[]

				if(array_size(_room_getAdjacentRooms(@layout, @sel)) <= 1, break(2))
				
				if(array_size(@free) == 0, console(color(c) . '    - CONT: Could not make new room!', false))
			
			)

		)

		@layout[] = @sel
				
		@specialRooms[@sel[0].':'.@sel[1]] = 2

		@cleared[] = @sel
		
	)
	
	#=====[GENERATING BOSS ROOMS]=====#
		
	console('Generating Boss Rooms...', false)

	foreach(range(0, @bossRooms), @room,
	
		console(' - Making room ' . (@room + 1) . '...', false)
	
		@tempLayout = @layout[]
		
		@generateNewRoom = false

		while(array_size(@tempLayout) > 0,

			@sel = array_rand(@tempLayout, 1, false)[0] array_remove_values(@tempLayout, @sel)

			if(array_index_exists(@specialRooms, @sel[0].':'.@sel[1]), console(color(c) . '     - CONT: This is a special room!', false) continue())
	
			if(array_size(@free = _room_getEmptyAdjecentRooms(@layout, @sel)) == 0, console(color(c) . ' - CONT: No empty adjecent spots!', false) continue())

			if(array_size(_room_getAdjacentRooms(@layout, @sel)) == 1, break())
		
			if(array_size(@tempLayout) == 0, 
				console('     - Found no suitable rooms! Creating a new room.', false) 
				@generateNewRoom = true
			)
			
			while(@generateNewRoom == true && array_size(@free) > 0,

				@picked = array_rand(@free, 1, false)[0]
				
				array_remove_values(@free, @picked)
				
				@temp = _vec2_add(@sel, @picked)[]
				
				@sel = @temp[]

				if(array_size(_room_getAdjacentRooms(@layout, @sel)) <= 1, break(2))
				
				if(array_size(@free) == 0, console(color(c) . '    - CONT: Could not make new room!', false))
			
			)

		)

		@layout[] = @sel
				
		@specialRooms[@sel[0].':'.@sel[1]] = 3

		@cleared[] = @sel
		
	)
	
	#=====[GENERATING SHOP ROOMS]=====#
		
	console('Generating Shop Rooms...', false)

	foreach(range(0, @shopRooms), @room,
	
		console(' - Making room ' . (@room + 1) . '...', false)
	
		@tempLayout = @layout[]
		
		@generateNewRoom = false

		while(array_size(@tempLayout) > 0,

			@sel = array_rand(@tempLayout, 1, false)[0] array_remove_values(@tempLayout, @sel)

			if(array_index_exists(@specialRooms, @sel[0].':'.@sel[1]), console(color(c) . '    - CONT: This is a special room!', false) continue())
	
			if(array_size(@free = _room_getEmptyAdjecentRooms(@layout, @sel)) == 0, console(color(c) . ' - CONT: No empty adjecent spots!', false) continue())

			if(array_size(_room_getAdjacentRooms(@layout, @sel)) == 1, break())
		
			if(array_size(@tempLayout) == 0, 
				console('    - Found no suitable rooms! Creating a new room.', false) 
				@generateNewRoom = true
			)
			
			while(@generateNewRoom == true && array_size(@free) > 0,

				@picked = array_rand(@free, 1, false)[0]
				
				array_remove_values(@free, @picked)
				
				@temp = _vec2_add(@sel, @picked)[]
				
				@sel = @temp[]

				if(array_size(_room_getAdjacentRooms(@layout, @sel)) <= 1, break(2))
				
				if(array_size(@free) == 0, console(color(c) . '    - CONT: Could not make new room!', false))
			
			)

		)

		@layout[] = @sel
				
		@specialRooms[@sel[0].':'.@sel[1]] = 4

		@cleared[] = @sel
		
	)

	console('Finished Generating.', false)
	
	foreach(@layout, @ID, @playerLocs[@ID[0] . ':' . @ID[1]] = array())

	export('allPlayerLocs', @playerLocs)
	export('roomDistances', @distances)
	export('roomSpecials', @specialRooms)
	export('roomLayout', array_unique(@layout))
	export('roomCleared', @cleared)
	
	foreach(@layout, @ID, _room_loadRoom(@ID))

)
