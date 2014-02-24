
proc(_chr_vi_id,
	@chests = all_virtualchests()
	for(@i = 0, @i >= 0, @i++,
		if(!array_contains(@chests, @i), return(@i))
	)	
)

proc(_chr_vi_menu, @id,

	@circuit = import('chr.circuits')[@id]
	
	@chest_id = _chr_vi_id()
	@chest = array()
	@chest[id] = @chest_id
	@chest[size] = 9
	@chest[title] = 'Circuit Menu'
	@chest[0] = array(type: 323, meta: array(display: 'Inputs', lore: array(array_size(import('chr.circuits.inputs.'.@id)) . ' input(s)')))
	@chest[1] = array(type: 323, meta: array(display: 'Outputs', lore: array(array_size(import('chr.circuits.outputs.'.@id)) . ' output(s)')))
	
	create_virtualchest(@chest)
	popen_virtualchest(@chest_id)
	
	@inv_click = bind(inventory_click, null, array(player: player()), @event, @id,
		
		cancel()
		switch(@event[rawslot],
			0,
				unbind()
				_chr_vi_menu_io(@id, 0),
			1,
				unbind()
				_chr_vi_menu_io(@id, 1)
		)
	
	)
	
	bind(virtualchest_closed, null, array(player: player()), @event, @bind = @inv_click,
		unbind(@bind)
		unbind()
	)

)

proc(_chr_vi_menu_io, @id, @type,

	@chest = array()
	@chest_id = _chr_vi_id()
	
	if(@type == 1,
		@contents = array_keys(import('chr.circuits.outputs.'.@id))  #outputs
		@chest[title] = 'Outputs',
		@contents = array_keys(import('chr.circuits.inputs.'.@id))  #inputs 
		@chest[title] = 'Inputs'
	)

	@chest[id] = @chest_id
	@chest[size] = min(54, ceil(array_size(@contents) / 9) * 9)
	
	@i = 0
	foreach(@contents, @name,
		@chest[@i] = array(type: 323, meta: array(display: color(6) . @name))
		@i++
	)
	
	create_virtualchest(@chest)
	popen_virtualchest(@chest_id)
	
	@inv_click = bind(inventory_click, null, array(player: player()), @event, @id, @type,

		@name = strip_colors(@event[slotitem][meta][display])
		
		if(@type == 1,
			msg('Right click the new source of output ' . color(b) . @name . color(f) . '.'),
			msg('Right click the new source of input ' . color(b) . @name . color(f) . '.')
		)

		bind(player_interact, array(priority: highest), array(player: player(), button: right), @event, @id, @name, @type,
			
			cancel()
			consume()
			unbind()

			@loc = _loc_fix(@event[location])
			if(@type == 1){
				_chr_output_loc(@id, @name, @loc)
				msg('Output ' . color(b) . @name . color(f) . ' set to location ' . color(b) . @loc)
				_chr_state_set(@id, @name, _chr_state_get(@id, @name))
			} else {
				_chr_input_assign(@id, @name, @loc)
				msg('Input ' . color(b) . @name . color(f) . ' set to location ' . color(b) . @loc)
				_chr_input(@id, @name, _is_powered(@loc))	
			}

		)
		
		close_pinv()

		cancel()
		unbind()
			
	)
	
	bind(virtualchest_closed, null, array(player: player()), @event, @bind = @inv_click,
		unbind(@bind)
		unbind()
	)
	
)
