
proc(_chr_output, @location, @value,

	if(is_array(@location),
	
		if(@value,
	
			set_block_at(@location, '89'),
			set_block_at(@location, '123')
			
		)
		
	)
	
)