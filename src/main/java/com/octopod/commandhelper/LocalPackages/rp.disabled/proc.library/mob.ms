
proc(_mob_spawn, @mob, @loc, @player,

	if(!is_array(@level_range), @level_range = array(@level_range, @level_range))

	@equipment = array(WEAPON: null, BOOTS: null, LEGGINGS:null, CHESTPLATE:null, HELMET:null)
	
	switch(@mob,
		FLOOD,
			@name = 'Flood'
			@type = 'zombie:baby'
			@hp = 1,
		TWITCHER,
			@name = 'Twitcher'
			@type = SKELETON
			@effect = array(1, 4)
			@equipment[HELMET] = array(type:397, data:1)
			@equipment[CHESTPLATE] = array(type:299, meta: array(color: array(b: 0, g: 0, r: 0)))
			@equipment[LEGGINGS] = array(type:300, meta: array(color: array(b: 0, g: 0, r: 0)))
			@equipment[BOOTS] = array(type:301, meta: array(color: array(b: 0, g: 0, r: 0)))
			,		
		UNDEAD_RUNNER,
			@name = 'Undead Runner'
			@type = SKELETON
			@effect = array(1, 1)
			@equipment[HELMET] = array(type:396)
			@hp = 5,
		ELITE_RUNNER,
			@name = 'Elite Runner'
			@type = SKELETON
			@effect = array(1, 2)
			@equipment[HELMET] = array(type:314)
			@hp = 5,
		UNDEAD_ARCHER,
			@name = 'Undead Archer'
			@type = SKELETON
			@effect = array(1, 2)
			@equipment[HELMET] = array(type:298)
			@equipment[WEAPON] = array(type:261)
			@hp = 5,
			
			@name = 'Undead Walker'
			@type = ZOMBIE
			@hp = 1,
	)

	@id = spawn_mob(@type, 1, @loc)[0]
	
	make_effect(@loc, 'MOBSPAWNER_FLAMES')
	#set_mob_name(@id, color(e) . color(l) . @name . color(e) . color(l))
	#set_name_visible(@id, false)
	set_mob_equipment(@id, @equipment)
	set_max_health(@id, @hp)
	
	if(is_array(@effect), set_mob_effect(@id, @effect[0], @effect[1], 999999, true))
						
	export('mobNoTarget.'.@id, true)
	set_timeout(500, closure(export('mobNoTarget.'.@id, null)))
						
	return(@id)

)

proc(_mob_generateGroup,

	return(array(UNDEAD_RUNNER, UNDEAD_RUNNER))
	
)

proc(_mob_spawnInRoom, @roomID,

	@all_mobs = import('allMobs')
	
	if(!is_array(@all_mobs), @all_mobs = associative_array())

	@mobs = _mob_generateGroup()

	@center = array(@roomID[0] * 32, 66, @roomID[1] * -32)

	execute(
		closure(
		
			#===[MOB SPAWN GENERATION]=======================================================#
			
			queue_push(
				closure(

					foreach(@mobs, @mob,
				
						@rand_loc = _vec_add(array(@center[0] , 0, @center[2]), array(rand(-12, 12), 65, rand(-12, 12)))
						
						@block = split(':', get_block_at(@rand_loc))[0]
						@b1 = split(':', get_block_at(_vec_add(@rand_loc, array(0,1,0))))[0]
						@b2 = split(':', get_block_at(_vec_add(@rand_loc, array(0,2,0))))[0]

						while(@b1 != 0 || @b2 != 0 || @block == 0,

							@rand_loc = _vec_add(array(@center[0] , 0, @center[2]), array(rand(-12, 12), 65, rand(-12, 12)))
							@block = split(':', get_block_at(@rand_loc))[0]
							@b1 = split(':', get_block_at(_vec_add(@rand_loc, array(0,1,0))))[0]
							@b2 = split(':', get_block_at(_vec_add(@rand_loc, array(0,2,0))))[0]
							
						)

						@id = _mob_spawn(@mob, _vec_add(@rand_loc, array(0.5, 1, 0.5)))

						@all_mobs[@id] = @roomID

					)
					
					export('allMobs', @all_mobs)
			
				)
			)
			
		)
	)

)

proc(_mob_killAllInRoom, @roomID,

	@all_mobs = array()
	
	foreach(import('allMobs'), @id, @rID,
		if(@rID != @roomID, 
			@all_mobs[@id] = @rID,
			try(entity_remove(@id))
		)
	)
	
	export('allMobs', @all_mobs)
	
)

proc(_mob_death, @id,

	@all_mobs = import('allMobs')
	
	if(!is_array(@all_mobs) || !array_index_exists(@all_mobs, @id), die())
	
	@roomID = @all_mobs[@id]
	
	array_remove(@all_mobs, @id)	
	@mobsLeft = array_size(array_indexes(@all_mobs, @roomID)) 

	export('allMobs', @all_mobs)

	if(@mobsLeft <= 0, 
		_room_unlockRoom(@roomID, true)
		foreach(_player_getRoomPlayers(@roomID), @player, _loot_giveRandCommon(@player))
	)

)
