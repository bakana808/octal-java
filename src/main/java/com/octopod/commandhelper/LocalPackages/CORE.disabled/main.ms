
bind(player_move, null, null, @event,

	@regEnter = array()
	
	if(array_size(sk_regions_at(@event['to'])) != 0 || array_size(sk_regions_at(@event['from'])) != 0,
	
		@regTo = sk_regions_at(@event['to'])
		@regFrom = sk_regions_at(@event['from'])
		
		foreach(@regTo, @region,	
			if(!array_contains(@regFrom, @region), array_push(@regEnter, @region))
		)
		
	)
	
    if(array_contains(@regEnter, 'old'),
	
		_changeserver(@event[player], 'old')
		
    )
	
    if(array_contains(@regEnter, 'cham'),
	
		_changeserver(@event[player], 'cham')
		
    )
	
    if(array_contains(@regEnter, 'pve'),
	
		_changeserver(@event[player], 'pve')
		
    )
	
    if(array_contains(@regEnter, 'pangenesis'),
	
		_changeserver(@event[player], 'pangenesis')
		
    )
	
    if(array_contains(@regEnter, 'creative'),
	
		_changeserver(@event[player], 'creative')
		
    )
	
    if(array_contains(@regEnter, 'dev'),
	
		_changeserver(@event[player], 'dev')
		
    )
	
	if(array_contains(@regEnter, 'angelsreach'),
	
		_changeserver(@event[player], 'AngelsReach')
		
    )
	
	if(array_contains(@regEnter, 'barks'),
	
		_changeserver(@event[player], 'barks')
		
    )
 
)