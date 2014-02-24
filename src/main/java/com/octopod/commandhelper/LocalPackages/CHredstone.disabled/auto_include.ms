
include('.library/virtualchests.ms')

proc(_chr_readCircuit, @circuit,

	try(return(read('circuits.library/'.@circuit.'.ms')), return(''))
	
)

proc(_chr_reg, @script, @loc, @block,

	@circuits = import('chr.circuits')
	
	@id = array_size(@circuits) #the ID of the new circuit
	
	broadcast('Reading circuit...')	
	
	@chr_inputs = split(' ', _chr_getField(@script, 'inputs:')) #an array of inputs
	@chr_outputs = split(' ', _chr_getField(@script, 'outputs:')) #an array of outputs
	@chr_name = _chr_getField(@script, 'name:') #the circuit name
	
	@inputs = array() foreach(@chr_inputs, @i, @inputs[@i] = 0)
	export('chr.circuits.inputs.'.@id, @inputs)
	@outputs = array() foreach(@chr_outputs, @i, @outputs[@i] = 0)
	export('chr.circuits.outputs.'.@id, @outputs)

	@circuits[@id] = array(@loc, @script)
	
	broadcast('Circuit registered.')	
	
	_chr_update(@id, 'FIRST')
	
)

proc(_chr_getField, @script, @field,

	foreach(split('\n', @script), @i, @line,
		@parsed = parse_args(@line)
		if(array_size(@parsed) > 0 && @parsed[0] == @field) {
			array_remove(@parsed, 0)
			return(array_implode(@parsed))
		}
	)

)

proc(_chr_circuitAtLoc, @loc,

	@circuits = import('chr.circuits')
	foreach(@circuits, @id, @circuit,
		if(_loc_fix(@circuit[0]) == _loc_fix(@loc)) {return(@id)}
	)
	
	return(-1)
	
)

proc(_chr_update, @id, @clk,

	try(@circuit = import('chr.circuits')[@id], return(false))
	
	if(@clk == '', @clk = 'UNKNOWN')
	
	foreach(import('chr.circuits.inputs.'.@id), @var, @value, @script .= eval(@var . ' = @value \n'))
	foreach(import('chr.circuits.outputs.'.@id), @var, @value, @script .= eval(@var . ' = @value \n'))

	eval(@circuit[1])
	
	broadcast(color(8) . '> ' . color(f) . 'Circuit Update: ' . @clk)

	@outputs = import('chr.circuits.outputs.'.@id)

	foreach(@outputs, @var, @value, eval('@outputs = _chr_output_update(@outputs, @id, @var, ' . @var . ')'))

	if(@interval != 0,
		queue_delay(@interval * 50)
		queue_push(closure(_chr_update(@id, 'INTERVAL')))
	)
	
)

proc(_chr_input_assign, @id, @input, @loc,

	@input_locs = import('chr.circuits.inputs')
	
	if(@loc == '',
	
		@inputs = import('chr.circuits.inputs.'.@id)
		foreach(@input_locs, @loc_key, @array, 
			if(@array[0] == @id && @array[1] == @input) { return(_loc_key(@loc_key)) }
		)
		return(null),

		@input_locs[_loc_key(@loc)] = array(@id, @input)

	)
	
)

proc(_chr_input, @id, @input, @value,

	@inputs = import('chr.circuits.inputs.'.@id)

	try(@inputs[@input] = integer(@value), return())
	export('chr.circuits.inputs.'.@id, @inputs)
	
	broadcast(color(8) . '> ' . color(b) . 'I: ' . color(f) . @input . color(7) . ' = ' . color(f) . integer(@value))

	_chr_update(@id, 'INPUT:' . @input)

)

proc(_chr_output_loc, @id, @output, @loc,

	@output_locs = import('chr.circuits.outputs')

	if(@loc == '',
		try(return(@output_locs[@id][@output]), return(null)),
		@output_locs[@id][@output] = @loc
	)
	
)

proc(_chr_state_get, @id, @output,

	@outputs = import('chr.circuits.outputs.'.@id)
	return(@outputs[@output])
	
)

proc(_chr_state_set, @id, @output, @value,

	@loc = _chr_output_loc(@id, @output)
	
	if(!is_array(@loc), return())
	
	switch(split(':', get_block_at(@loc))[0],
		'69', #lever
			include('outputs.library/lever.ms'),
		array('123', '89'), #lantern
			include('outputs.library/lantern.ms'),
			include('outputs.library/block.ms')
	)
		
	_chr_output(@loc, @value)
	
)

proc(_chr_output_update, @outputs, @id, @key, @value,

	if(@value != @outputs[@key],
	
		@outputs[@key] = integer(@value)
		broadcast(color(8) . '> ' . color(e) . 'O: ' . color(f) . @key . color(7) . ' = ' . color(f) . integer(@value))
		_chr_state_set(@id, @key, @value)

	)
	
	return(@outputs)
	
)