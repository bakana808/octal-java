
export('chr.circuits', associative_array())
export('chr.circuits.inputs', associative_array())
export('chr.circuits.outputs', associative_array())

bind(player_chat, null, null, @event,

	export('chr.chat.lastSpoke', player())
	export('chr.chat.lastSaid', @event[message])
	
	foreach(import('chr.circuits'), @id, @circuit,
	
		_chr_update(@id, 'CHAT')
		
	)
	
)

bind(sign_changed, null, null, @event,

	@script = _chr_readCircuit(@event[text][1])
	
	if(@script != '') {

		_chr_reg(@script, _loc_fix(@event[location]))
		
	} else {
	
		msg('The circuit ' . @event[text][1] . '.ms doesn\'t exist.')
	
	}
	
)
	
bind(virtualchest_closed, null, array(player: player()), @event,

	del_virtualchest(@event[chest])
	unbind()
	
)

bind(player_interact, null, array(button: right), @event,

	if(!array_index_exists(@event, location), die())
	@loc = _loc_fix(@event[location])

	@id = _chr_circuitAtLoc(@loc)
	if(@id != -1, 
		_chr_vi_menu(@id) 
		cancel() 
		die()
	)
	
	@inputs = import('chr.circuits.inputs')
	@loc_key = _loc_key(@loc)
	
	if(array_index_exists(@inputs, @loc_key)){
		
		@info = @inputs[@loc_key]
		@circuits = import('chr.circuits')
		@circuit = @circuits[@info[0]]

		if(_is_powered(@loc), @power = false, @power = true)
		
		_chr_input(@info[0], @info[1], @power)
		
		switch(split(':', @event[block])[0],
			'77',
				set_timeout(1000,
					closure(
						_chr_input(@info[0], @info[1], false)
					)
				)
		)
	
	}

)