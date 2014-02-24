
#========================================================================================
#	Module System
#========================================================================================

@mod_commands = array()
export('ocp.mod.commands', @mod_commands)

@mod_loaded = array() #an array of loaded mods
@mod_includes = array() #an array of paths representing every include file 
@mod_autoruns = array() #an array of paths representing every autorun file
@mod_infos = array() #an array of information from every module
@mod_configs = array() #an array of configurations from every module 

@ext_autorun = 'ocpa'
@ext_include = 'ocpi'

foreach(directory_contents('modules'), @mod,

	@loaded = false
	
	if(is_directory('modules/'.@mod),
		foreach(directory_contents('modules/'.@mod), @file,
			@split = split('.', @file)
			switch(@split[1],
			
				@ext_autorun,rel
	
					async_read('modules/'.@mod.'/'.@file, 
						closure(@contents, @exception, eval(@contents))
					)
					array_push(@mod_autoruns, 'modules/'.@mod.'/'.@file)
					@loaded = true,
					
				@ext_include, 
				
					array_push(@mod_includes, 'modules/'.@mod.'/'.@file)
					@loaded = true,

				'yml', #yml's are always used for configs
				
					if(@split[0] == 'info',
						async_read('modules/'.@mod.'/'.@file, 
							closure(@contents, @exception, 
								@decoded = yml_decode(@contents)
								@mod_infos = import('ocp.mod.infos')
								@mod_infos[@mod] = @decoded 
								export('ocp.mod.infos', @mod_infos)
								async_read('modules/'.@mod.'/'.@decoded[config],
									closure(@contents, @exception,
										if(@exception == null,
											@mod_configs = import('ocp.mod.configs')
											@mod_configs[@mod] = yml_decode(@contents) 
											export('ocp.mod.configs', @mod_configs)
										)
									)
								)
							)
						)
					)
					@loaded = true
			)
		)
	)
	
	if(@loaded,
		array_push(@mod_loaded, @mod)
	)
)

export('ocp.mod.loaded', @mod_loaded)
export('ocp.mod.includes', @mod_includes)
export('ocp.mod.autoruns', @mod_autoruns)
export('ocp.mod.infos', @mod_infos)
export('ocp.mod.configs', @mod_configs)


@mod_includes = import('ocp.mod.includes')
if(is_array(@mod_includes), foreach(@mod_includes, @path, include(@path)))


#========================================================================================
#	Commands
#========================================================================================

_cmnd_register(array('/ocp debug'), 'motd', 'Shows the MOTD of the server.',
	closure(

		@mod_loaded = import('ocp.mod.loaded')
		
		_ocp_msg(@arguments[1], 
			_adv_string_fill(color(f) . color(l) . '--------------------------------------------------------', 304, 0) . color(r)
		)
		
		_ocp_msg(@arguments[1], 
			_adv_string_fill(color(f) . color(l) . '= OCP Debug = ', 304, 2) . color(r)
		)	
		
		_ocp_msg(@arguments[1],
			_adv_string_fill(color(8) . color(l) . '--------------------------------------------------------', 304, 0) . color(r)
		)
		
		_ocp_msg(@arguments[1], 
			_adv_string_fill(color(6) . 'Module Name', 90, 0) . color(8) . '| ' . 
			_adv_string_fill(color(6) . 'Version', 60, 0) . color(8) . '| ' . 
			_adv_string_fill(color(6) . 'Author', 60, 0) . color(8) . '| ' . 
			_adv_string_fill(color(6) . 'Info Status', 70, 0) 
		)
		
		_ocp_msg(@arguments[1], 
			_adv_string_fill(color(8) . color(l) . '----------------', 90, 0) . color(8) . '|' . 
			_adv_string_fill(color(8) . color(l) . '----------------', 60, 0) . color(8) . ' |' . 
			_adv_string_fill(color(8) . color(l) . '----------------', 60, 0) . color(8). ' |' . 
			_adv_string_fill(color(8) . color(l) . '----------------', 80, 0) . color(r)
		)
		
		foreach(@mod_loaded, @mod,
			@contents = _ocp_mod_info(@mod)
			
			switch(@contents[4],
				'COMPLETE', @color = color(a),
				'INCOMPLETE', @color = color(e),
				'NONE', @color = color(c),
			)
			
			@name = _adv_string_fill(@color . @contents[0], 90, 0)
			@vers = _adv_string_fill(@color . @contents[1], 60, 0)
			@auth = _adv_string_fill(@color . @contents[2], 60, 0)
			@stat = _adv_string_fill(@color . @contents[4], 70, 0)
			_ocp_msg(@arguments[1], @name . color(8) . '| ' . @vers . color(8) . '| ' . @auth . color(8). '| ' . @stat)
		)
		
		_ocp_msg(@arguments[1], 
			_adv_string_fill(color(f) . color(l) . '--------------------------------------------------------', 304, 0) . color(r)
		)


	)
)

#========================================================================================
#	Command Listeners
#========================================================================================
	
bind(player_command, array(id: 'ocp_event_command'), null, @event,

	cancel()

	if(_cmnd_run(@event['command']), _stop())

)

bind(player_chat, array(priority: highest, id: 'ocp_event_chat'), null, @event,

	if(_cmnd_run(@event['message']), _stop())

)

	
