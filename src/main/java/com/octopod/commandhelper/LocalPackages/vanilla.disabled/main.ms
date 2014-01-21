@config = yml_decode(read('config.yml'))

export('block.item', @config['blocked-items'])

export('block.entity', @config['blocked-entities'])

export('item.food',
	array(
		260, 322, 322, 263, 264, 357, 363, 364, 360, 365, 366, 367, 319, 320, 297
	)
)
	
@world_border = 1500

@blocked = import('block.entity')
	
foreach(all_entities(), @id,

	if(array_contains(@blocked, entity_type(@id)),
		entity_remove(@id)
	)
	
)

bind(player_move, null, null, @event, @world_border,

	if(abs(@event[to][0]) > @world_border || abs(@event[to][2]) > @world_border) {
		set_ploc(@event[from])
		msg('You can\'t go any further! (The radius is '.@world_border.'.)')
		msg('If you think the world needs to expand, contact TheOctopod.')
	}
	
)

bind(entity_change_block, null, null, @event, cancel())

foreach(all_players(), @player, set_phunger(@player, 0))

bind(player_join, null, null, @event, @world_border,

	@msgs = array(
		'&dI hope you like dying.',
		'&dGood luck finding a working command.',
		'&dStop looking at your hunger bar.',
	)
	
	msg(colorize(array_rand(@msgs, 1, false)[0]))
	msg(colorize('&eType &f/help &efor information.'))
	
	set_phunger(0)
	set_pwalkspeed(0.30)
	
	if(@event[first_login],
		set_timeout(100, 
			closure(set_ploc(_rand_spawn(@world_border)))
		)
	)

)

bind(player_spawn, null, null, @event, @world_border,

	set_timeout(100, 
		closure(
			set_phunger(0)
			set_pwalkspeed(0.30)

			set_ploc(_rand_spawn(@world_border))
		)
	)
	
)

bind(creature_spawn, null, null, @event,

	@blocked = import('block.entity')

	if(array_contains(@blocked, @event[type]), cancel(),
		set_timeout(50,
			closure(
				set_mob_equipment(@event[id], array(WEAPON:null, BOOTS:null, LEGGINGS:null, CHESTPLATE:null, HELMET:null))
				try(if(get_mob_age(@event[id]) < 0, entity_remove(@event[id])))
			)
		)
	)
	
)

bind(entity_damage, null, null, @event,

	if(@event[cause] == STARVATION) {
		modify_event(amount, 0) 
		cancel() 
	}
	
)

bind(player_interact, null, null, @event,

	@blocked = import('block.item')	
	
	@type = split(':', pinfo()[6])[0]

	if(array_contains(@blocked, @type)) {
		cancel()
	}
	
	@food = import('item.food')

	if(array_contains(@food, @type),
	
		cancel()
	
		ptake_item(pinfo()[6], 1)

		@health = pinfo()[5]
		
		@hp = 2
		
		switch(@type) {
			367, 
				@hp = 1
		}
		
		@health = min(20, @health + @hp)

		set_pfood(player(), 0)
		set_phealth(player(), @health)
		
		play_sound(ploc(), array(sound:EAT))
		
	)	
	
)

bind(player_interact_entity, null, null, @event, @item_nospawn,

	@type = split(':', pinfo()[6])[0]

	if(array_contains(@item_nospawn, @type)) {
		cancel()
	}	
	
)

bind(player_consume, null, null, @event, cancel())

bind(item_spawn, null, null, @event,
	@item = @event[item]
	if(@item[type] == 5, @item[data] = 0)
	modify_event(item, @item)
)

bind(inventory_click, null, null, @event, @item_nospawn,

	try(
		if(array_contains(@item_nospawn, @event[inventory][0][type]),
			cancel()
		)
		if(@event[slotitem][type] == 5){
			@item = @event[slotitem]
			@item[data] = 0
			modify_event(slotitem, @item)
		}
	)

)

_cmnd_register(array('/help'), '', '',
	closure(
		scriptas(@arguments[1], '*',
			@lines =
				array(
					' &6This is a vanilla anarchy server.',
					'&eThe spawn is randomized on every death, as to prevent spawn-killing.',
					'&eThere are no rules, so take caution when encounting other players.',
					'There are gameplay changes to emulate the gameplay of older minecraft versions.',
					'To see these changes, type &f/changes&e.'
				)
				
			@line = array_implode(@lines, '\n')


			msg(colorize('&8----------------------------------------------------+'))
			msg(colorize(@line))
			msg(colorize('&8----------------------------------------------------+'))
		)
	)
)

_cmnd_register(array('/changes'), '', '',
	closure(
		scriptas(@arguments[1], '*',
			@lines =
				array(
					' &aThis server tries to capture classic-style minecraft gameplay with the following gameplay changes:',
					' &7- No hunger & starvation. ',
					' - No sprinting. ',
					' - Modified walking speed. ',
					' - Food instantly heals health. ',
					' - Removal of experience orbs.',
					' - Removal of enchantment. ',
					' - Removal of some items. See &f/items&7',
					' - Removal of some mobs. See &f/mobs&7',
					' - Removal of mob equipment. ',
					' - Removal of mob babies. ',
					' - Removal of colored wood.',
					' - Removal of world structures.',
					' - Removal of Jungle and Ocean biomes.',
					' - Removal of The End.',
				)
				
			@line = array_implode(@lines, '\n')


			msg(colorize('&8----------------------------------------------------+'))
			msg(colorize(@line))
			msg(colorize('&8----------------------------------------------------+'))
		)
	)
)

_cmnd_register(array('/items'), '', '',
	closure(
		scriptas(@arguments[1], '*',
			@blocked = import('block.item')	
			@items = array()
			foreach(@blocked, @i, @item,
				if(mod(@i, 2) == 0,
					@items[] = color(7) . to_upper(data_name(@item)),
					@items[] = color(f) . to_upper(data_name(@item))
				)
			)
			@line = array_implode(@items, ', ')
			@lines =
				array(
					' &aThe following items are removed:',
					'&7' . @line
				)
				
			@line = array_implode(@lines, '\n')

			msg(colorize('&8----------------------------------------------------+'))
			msg(colorize(@line))
			msg(colorize('&8----------------------------------------------------+'))
		)
	)
)

_cmnd_register(array('/mobs'), '', '',
	closure(
		scriptas(@arguments[1], '*',
			@blocked = import('block.entity')	
			@items = array()
			foreach(@blocked, @i, @item,
				if(mod(@i, 2) == 0,
					@items[] = color(7) . @item,
					@items[] = color(f) . @item
				)
			)
			@line = array_implode(@items, ', ')
			@lines =
				array(
					' &aThe following entities are removed:',
					'&7' . @line
				)
				
			@line = array_implode(@lines, '\n')

			msg(colorize('&8----------------------------------------------------+'))
			msg(colorize(@line))
			msg(colorize('&8----------------------------------------------------+'))
		)
	)
)

_cmnd_register(array('/kill'), '', '',
	closure(
		runas(@arguments[1], '/kill')
	)
)






