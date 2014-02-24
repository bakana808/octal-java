bind(player_chat, null, null, @event,

	@msg = @event['message']
	
	if(string_position(@msg, '?+') == 0,
	
		@parsed = parse_args(substr(@msg, 2))
	
		if(array_size(@parsed) < 2, die())
		
		@name = to_lower(@parsed[0])
		array_remove(@parsed, 0)
		
		@factoid = array_implode(@parsed)

		if(_factoid_set(@name, @factoid), 
			broadcast('Factoid set.'), 
			broadcast('Failure trying to set this factoid.')
		)
		
		die()
		
	)
	
	if(string_position(@msg, '?') == 0,
	
		@parsed = parse_args(substr(@msg, 1))
		
		if(array_size(@parsed) < 1, die())
		
		@name = to_lower(@parsed[0])
		
		@factoid = _factoid_get(@name)
		
		if(@factoid == null, broadcast('Could not find a factoid for ' . @name),
			broadcast(colorize(@factoid))
		)
		
		die()
		
	)
	
)