
proc(_chest_openID,

	@chests = all_virtualchests()

	for(@i = 0, true, @i++,
		if(!array_contains(@chests, @i), return(@i))
	)
	
)

proc(_item_get_price, @itemArray,

	try(
		foreach(@itemArray[meta][lore], @line,
			if(string_position(@line, 'Price: ') != -1){
				return(replace(@line, 'Price: ', ''))
			}
		),
		return(0)
	)
	
)		

proc(_item_generate_sword,

	@item = array(meta: array(lore: array()))
	@item[type] = 267
	@item[meta][display] = color(f) . 'Steel Sword'
	@item[meta][lore][] = 'Price: 500'
	
	return(@item)
	
)

proc(_item_generate_armor,

	@item = array(meta: array(lore: array()))
	@item[type] = 307
	@item[meta][display] = color(f) . 'Steel Armor'
	@item[meta][lore][] = 'Price: 300'
	
	return(@item)
	
)



proc(_player_giveItem, @player, @itemArray,

	@inv = pinv()
	
	for(@i = 0, @i < 36, @i++){
		if(@inv[@i] == null){
			
			@inv[@i] = @itemArray
			break()
			
		}
	}
	
	set_pinv(@inv)
	
)

proc(_loadout_open, @player,

	@inventory = pinv(@player)
	@newInv = _emptyinv()

	set_pinv(@player, @newInv)
	
	@chestID = _chest_openID()
	
	@chestArray = array(
		id: @chestID,
		size: 54,
		title: color(2) . color(l) . '100 / 100 Points',
	)

	@chestArray[0] = _item_generate_sword()
	@chestArray[1] = _item_generate_armor()
	
	create_virtualchest(@chestArray)
	popen_virtualchest(@player, @chestID)
	
	@clickID = 
	bind(inventory_click, null, array(player: @player), @event,
		if(@event[player] == @player){
			cancel()
			_player_giveItem(@player, @event[slotitem])
		}
	)
	
	bind(virtualchest_closed, null, array(player: @player), @event, @clickID, @inventory,

		if(@event[player] == @player){

			del_virtualchest(@event[chest][id])
			unbind(@clickID)
			unbind()
			
		}
		
	)
	
)
	
proc(_sprint_generating, @player,

	clear_task(import('sprintGeneration.'.@player))
	
	scriptas(@player,
		@id = set_interval(500,
			closure(
				if(pfood() >= 20, clear_task() die())
				if(!pinfo()[19], set_pfood(pfood() + 1))
			)
		)
	)
	
	export('sprintGeneration.'.@player, @id)
	
)

proc(_score_reset, @player, export('scoreRun.'.@player, 0))
proc(_score_add, @player, @amount, export('scoreRun.'.@player, import('scoreRun.'.@player) + @amount))
proc(_score_get, @player, 
	@score = import('scoreRun.'.@player)
	if(@score == null, return(0), return(@score))
)

proc(_run_start, @player,

	@spawn = array(0.5,64,0.5,pvp_1)
	
	set_ploc(@spawn)
	_score_reset(@player)

)

proc(_run_end, @player, @reason,

	@darkLoc = array(0.5, 60, 0.5,lobby)
	@spawnLoc = array(0.5, 64, -7.5, lobby)
	
	@multiplier = 1.17
	@score = _score_get(@player)
	
	scriptas(@player,

		set_ploc(@darkLoc)
		set_timeout(50, closure(set_ploc(@darkLoc)))
		
		msg(color(8) . ' ----------------------------------------------------')
		msg('  Died by the hands of ' . @reason)
		msg(color(8) . ' ----------------------------------------------------')
		
		queue_delay(500)
		queue_push(closure(
			msg('  Credit Earnings: ' . @score)
		))
		
		queue_delay(500)
		queue_push(closure(
			msg('  Credit Multiplier: ' . sprintf('%.2f', @multiplier) . 'x')
		))
		
		queue_delay(500)
		queue_push(closure(
			msg('  Total Earnings: ' . floor(@score * @multiplier))
		))
		
		queue_delay(500)
		queue_push(closure(
			msg('  Total Credits: ' . floor(@score * @multiplier) . '\n' .
			color(8) . '----------------------------------------------------')
		))
		
		queue_delay(1000)
		queue_push(closure(
			
			set_peffect(@player, 15, 1, 1, true)
			set_ploc(@spawnLoc)
			
		))
		
	)
	
)
	
