
_cmd_setMode(false)

bind(player_command, array(id: 'event_command'), null, @event,

	scriptas(player(), '*',
		if(_cmd_run(@event['command']), cancel() consume(),

			if(!_cmd_getMode(),
				cancel()
				chat(substr(@event['command'], 1))
			)
			
		)
	)
	
)

bind(player_chat, array(priority: highest, id: 'event_chat'), null, @event,

	scriptas(player(), '*',
	
		if(_cmd_run(@event['message']), cancel() consume())
		
	)

)

_creg('/help', closure(

	msg(colorize('&6OctoLib by Octopod'))
	msg(colorize('&7Hover over commands for more information.'))
	msg(colorize('&8---------------------------'))
	
	@command_list = import('commandList')
	@command_link = import('commandLinks')
	
	@chat_elements = array()
	
	@label = array_keys(@command_link)[0]
	@cmdArray = @command_list[@command_link[@label]]
	@tooltip = array('&6Example Usages: ')
	foreach(@cmdArray[2], @example,
		@tooltip[] = replace(@example, '<command>', @label)
	)	
	
	@chat_elements[] = array(
		text: @label,
		/*
		onHover: array(
			event: 'show_text',
			value: array_implode(@tooltip, '\n')
		),
		*/
		color: gold
	)		
		
	for(@i = 1, @i < array_size(@command_link), @i++) {
		
		@label = array_keys(@command_link)[@i]
		@cmdArray = @command_list[@command_link[@label]]
		@tooltip = array('&6Example Usages: ')
		foreach(@cmdArray[2], @example,
			@tooltip[] = replace(@example, '<command>', @label)
		)
		
		@chat_elements[] = array(
			text: ', ' . @label,
			/*
			onHover: array(
				event: 'show_text',
				value: array_implode(@tooltip, '\n')
			),
			*/
			color: gold
		)
		
	}

	chjc_msg(@chat_elements)
	
))

cmd_reg('/sudo', closure(

	@command = array_implode(@cArgs)
	sudo(@command)

), '*')

cmd_reg('!eval', closure(
		if(player() != 'TheOctopod', die())
		
		@section = array_implode(@args)
		
		broadcast(color(8) . '< ' . color(7) . array_implode(@args))
		
		if(!import('octolib.eval.multiline') && @section == '>>>',
			export('octolib.eval.multiline', true)
			export('octolib.eval.script', '')
			set_timeout(50, closure(
				bind(player_chat, null, array(player: player()), @event,
					cancel()
					if(@event[message] != '<<<',
						broadcast(color(8) . '< ' . color(7) . @event[message])
						export('octolib.eval.script', import('octolib.eval.script') . @event[message] . '\n')
						return(true)
					)
					unbind()
					chatas(player(), '!eval ' . @event[message])
				)
			))
			return(true)
		)

		if(import('octolib.eval.multiline'),
			@script = import('octolib.eval.script')
			export('octolib.eval.multiline', null)
			export('octolib.eval.script', ''),
			@script = @section
		)

		try(@return = eval(@script), 
			@ex, 
			@return = color(c) . @ex[0] . ': ' . color(7) . @ex[1]
		)

		if(@return == '') {
			broadcast(color(8) . '> ' . color(7) . '[void]')
		} else {
			broadcast(color(8) . '> ' . color(a) . @return)
		}
), '*')