
#======================================================================================================#
#	Command Handler (accepts any string as command label)
#======================================================================================================#

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

_creg('!eval',
	closure(
		if(player() != 'TheOctopod', die())
		
		@section = array_implode(@cParsed)
		
		broadcast(color(8) . '< ' . color(7) . array_implode(@cParsed))
		
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
	)
)