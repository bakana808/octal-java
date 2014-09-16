#====================================================================
# Looting auto_include.ms
#====================================================================

/*
proc(_phurt, @player, @amount,
	@hp = pinfo(@player, 5)
	set_phealth(@player, max(0, @hp - @amount))
)

proc(_forward, @player,
	@facing = 	pfacing(@player)
	@yaw = 		to_radians(@facing[0])
	@pitch = 	to_radians(@facing[1])
	return(array(0 - sin(@yaw) * cos(@pitch) + cos(@yaw), 0 - sin(@pitch), cos(@yaw) * cos(@pitch) + sin(@yaw)))
)
*/

#====================================================================
# Looting main.ms
#====================================================================

bind(player_interact_entity, null, null, @event,
	#chance to loot the player, 0-100
	@chance = 50
	#min/max of amount of econ to loot
	@econ_min = 10
	@econ_max = 25
	#cooldown for the looting in ms
	@cooldown = 1000
	
	cancel()
	@target = @event[data]
	@player = @event[player]
	@key = 'loot.cooldown.'.@player
	
	if(@target != '' && import(@key.'') == null) 
	{
		export(@key.'', true)
		@tinv = pinv(@target)
		@i = rand(0, 35)
		@slot = @tinv[@i]
		
		if(@slot == null) 
		{
			#empty slot, loot their money instead
			@econ_loot = rand(@econ_min, min(@econ_max, acc_balance(@target)))
			tmsg(@player, 'You looted ' . @econ_loot . '$ from ' . @target)
			acc_add(@player, @econ_loot)
			acc_subtract(@target, @econ_loot)
		} 
		else 
		{
			if(rand(0, 100) < @chance) 
			{
				#success, drop whatever was in that slot
				tmsg(@player, 'You found ' . data_name(@slot[type]) . ' from ' . @target)
				@tinv[@i] = null
				drop_item(@slot)
				set_pinv(@target, @tinv)
			} 
			else 
			{
				#failure, time to let that bitch know he's being robbed
				tmsg(@target, 'Someone\'s trying to rob you!')
				tmsg(@player, 'Shit, you failed to rob them')
				_phurt(@target, 1)
			}
		}
		set_timeout(@cooldown, export(@key.'', null))
	}
)

