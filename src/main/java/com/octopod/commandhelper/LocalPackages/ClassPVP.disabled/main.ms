
bind(player_move, null, null, @event,

	if(pinfo()[19]) {
		set_pfood(pfood() - 1)
		_sprint_generating(player())
	}
	
)
bind(player_portal_travel, null, null, @event, 
	cancel()
	_run_start(player())
)

bind(entity_damage_player, null, null, @event,
	
	if(pworld() == lobby){cancel() die()}
	if(ponline(@event[data]),
	
		if(pinfo()[5] - @event[amount] <= 0){
			
			cancel()
			set_entity_health(pinfo()[13], 100)
			_run_end(player(), @event[data])
			_score_add(@event[data], 100)
			tmsg(@event[data], '+100 for killing ' . player())
			
		}
		
	)
	
)