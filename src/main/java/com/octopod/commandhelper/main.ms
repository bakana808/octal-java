#======================================================================================================#
#	OctalLibrary CommandHelper
#======================================================================================================#

#	Author: Octopod 
#	E-mail: octopodsquad@gmail.com
# 	Last Updated: 9 / 16 / 2014

#======================================================================================================#
#	Custom Command Functions
#======================================================================================================#

bind(player_command, array(id: 'event_command'), null, @event,

	if(_cmd_run(@event['command']), cancel() consume(),

		if(!_cmd_getMode(),
			chat(substr(@event['command'], 1))
			cancel() consume()
		)
		
	)
	
)

bind(player_chat, array(priority: highest, id: 'event_chat'), null, @event,

	if(_cmd_run(@event['message'])) {cancel() consume()}

)

_creg('!eval', closure(
	_seval(player(), @cParsed)
), '*')