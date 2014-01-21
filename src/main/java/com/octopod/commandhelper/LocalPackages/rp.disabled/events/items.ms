
bind(player_interact, null, array(button:left), @event,

	if(pmode() != 'CREATIVE',

		if(pinfo()[11],
			_item_rotateItems(),
			_item_useFirstItem()
		)
		
	)
	
)