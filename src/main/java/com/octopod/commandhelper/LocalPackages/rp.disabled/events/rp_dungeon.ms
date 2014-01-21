
@mobs = array(WITCH, BAT, CREEPER, SKELETON, SPIDER, GIANT, ZOMBIE, SLIME, GHAST, PIG_ZOMBIE,
	ENDERMAN, CAVE_SPIDER, BLAZE, MAGMA_CUBE, PIG, SHEEP, COW, CHICKEN, SQUID, WOLF, MUSHROOM_COW,
	SNOWMAN, OCELOT, IRON_GOLEM, VILLAGER, HORSE)

bind(player_interact, array(priority:highest), null, @event, @doors_config, @dungeons_config,

	@doors = array(64, 96, 71)

	@block_split = split(':', @event[block])
	if(@block_split[0] != 0, @loc = @event[location])
	
	if(array_index_exists(@block_split, 1),
		if(@block_split[0] == 64 || @block_split[0] == 71 && @block_split[1] == 8 || @block_split[1] == 9, 
			@loc = _vec_add(@event[location], array(0,-1,0))
			@block_split = split(':', get_block_at(@loc))
		)
	)
	
	#===[OPEN DOOR]=============================================================================#

	if(@event[button] == right && array_contains(@doors, @block_split[0])) {
	
		@mobs = _respawn_targeted(player())
		
		cancel()	
		consume()
		
		if(!array_index_exists(@block_split, 1),
			@data = 0,
			@data = @block_split[1]
		)

		switch(@block_split[0],
			96,
				switch(@data,
					array(0, 1, 2, 3),
						@en = array(down, up),
					array(8, 9, 10, 11),
						@en = array(up, down)
				),
				
				switch(@data,
					0,
						@en = array(west, east),
					1,
						@en = array(north, south),
					2,
						@en = array(east, west),
					3,
						@en = array(south, north),
				)
		
		)

		if(!is_array(@en) || !array_contains(@en, @event[facing]), set_ploc(ploc()) die(),
		
			if(@en[0] == @event[facing],
				@door_used = ENTRANCE,
				@door_used = EXIT
			)

		)

		foreach(@doors_config, @id, @config,

			if(@config[loc] == @loc,
				
				if(@door_used == ENTRANCE,
					if(@config['ent-to'] != array(), @loc_over = @config['ent-to'])
					@area = @config['ent-border'],
					if(@config['exit-to'] != array(), @loc_over = @config['exit-to'])
					@area = @config['exit-border']
				)
				
				break()
				
			)

		)
		
		if(@area != '' && array_index_exists(@dungeons_config, @area),
		
			@area_name = @dungeons_config[@area][name]

			if(import('dungeon.warned.'.player()) != @area,
				
				@l = array()
				@l[] = '&8+---------------------------------------------------+'
				@l[] = '&7You are about to enter &f'. colorize(@area_name)
				@l[] = '&8+---------------------------------------------------+'
				@l[] = '&cWARNING: Mobs in this dungeon are higher level than you.'
				@l[] = '&cDo you still want to enter? &7(right click again)'
				@l[] = '&8+---------------------------------------------------+'
				foreach(@l, @line, msg(colorize(@line)))
				
				export('dungeon.warned.'.player(), @area)
				die(),
					
				@l = array()
				@l[] = '&8+----------------------------------------------------'
				@l[] = '&8`| ' . color(f) . color(l) . @area_name
				@l[] = '&8+----------------------------------------------------'
				foreach(@l, @line, msg(colorize(@line)))
				export('dungeon.warned.'.player(), null)
				),

		)

		if(is_array(@loc_over),
			
			set_ploc(@loc_over),

			switch(@event[facing],
				north,
					set_ploc(_vec_add(@loc, array(0.5, -1, 1.5))),
				south,
					set_ploc(_vec_add(@loc, array(0.5, -1, -1.5))),
				west,
					set_ploc(_vec_add(@loc, array(1.5, -1, 0.5))),
				east,
					set_ploc(_vec_add(@loc, array(-1.5, -1, 0.5))),
				up,
					set_ploc(_vec_add(@loc, array(0.5, -2, 0.5))),
				down,
					set_ploc(_vec_add(@loc, array(0.5, 0, 0.5))),
			)
			
		)
		
		_set_area(player(), @area)
		
		die()
		
	}

)

