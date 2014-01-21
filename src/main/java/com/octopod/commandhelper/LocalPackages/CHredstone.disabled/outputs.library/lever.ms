
proc(_chr_output, @location, @value,

	if(is_array(@location),
	
		@pair = _lever_getStates(get_block_at(@location))
		
		if(@value,
			set_block_at(@location, @pair[0]),
			set_block_at(@location, @pair[1])
		)
		
	)
	
)