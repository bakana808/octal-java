proc(_player_getRoom, @player,

	@ploc = import('playerLoc.'.@player)
	
	if(!is_array(@ploc), return(array(0,0)), return(@ploc[]))
	
)

proc(_player_setRoom, @player, @roomID,

	export('playerLoc.'.@player, @roomID)
	
	queue_push(closure(
	
		@playerLocs = import('allPlayerLocs')
		foreach(@playerLocs, @roomIDKey, @players, array_remove_values(@players, @player))
		if(!array_index_exists(@playerLocs, _room_toKey(@roomID)), @playerLocs[_room_toKey(@roomID)] = array())
		@playerLocs[_room_toKey(@roomID)][] = @player #this line causes issues (^this line fixes it)
		export('allPlayerLocs', @playerLocs)
				
	))

	@knownRooms = import('playerKnownRooms.'.@player)
	if(!is_array(@knownRooms), @knownRooms = array())
	@knownRooms[] = @roomID
	foreach(_room_getAdjacentRooms(@roomID), @rel, @knownRooms[] = _vec2_add(@roomID, @rel))
	export('playerKnownRooms.'.@player, array_unique(@knownRooms))
	
)

proc(_player_getKnownRooms, @player,

	@knownRooms = import('playerKnownRooms.'.@player)
	if(!is_array(@knownRooms), return(array(array(0,0), array(1,0), array(-1,0), array(0,1), array(0,-1))), return(@knownRooms[]))
	
)

proc(_player_getRoomPlayers, @roomID,

	@playerLocs = import('allPlayerLocs')
	
	try(return(@playerLocs[_room_toKey(@roomID)]), return(array()))
	
)

proc(_player_respawn, @player = player(),

	scriptas(@player, '*',

		_player_setRoom(player(), array(0,0))
		_scoreboard_reset(player())
		
		set_pwalkspeed(player(), 0.3)
		set_max_health(pinfo(player())[13], 6)
		set_entity_health(pinfo(player())[13], 100)
		set_phunger(player(), 20)

		set_ploc(player(), array(0,66,0,world))
		 
		@inv = _emptyinv()
		@inv[0] = array(type:'261:0') 
		@inv[8] = array(type: 345, meta: array(display: color(e) . 'Status', lore: array(color(8) . color(o) . 'STATUS MENU')))
		set_pinv(player(), @inv)
		
		_item_give(Bomb, player())
		_item_give(Bomb, player())
		_item_give(Heal, player())
		_item_give(Heal, player())
		_item_give(Fireball, player())
		_item_give(Fireball, player())
		
		_room_printLayout(player())
		
	)

)